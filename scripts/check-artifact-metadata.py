#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


REQUIRED_KEYS = {
    "schema",
    "workflow",
    "runId",
    "stage",
    "status",
    "nextAction",
}

REQUIRED_FRONT_MATTER_KEYS = {
    "workflow",
    "runId",
    "executionMode",
    "stage",
    "status",
    "source",
    "allowsCodeEdit",
    "nextAction",
}

REQUIRED_HANDOFF_KEYS = {
    "fromWorkflow",
    "toWorkflow",
    "selectedItems",
    "verificationRequired",
}

ALLOWED_WORKFLOWS = {
    "workflow-bootstrap",
    "codebase-orientation",
    "code-review-triage",
    "debug-root-cause",
    "api-contract-design",
    "data-migration-planning",
    "software-delivery-pipeline",
}


def parse_scalar(value: str):
    cleaned = value.strip().strip('"')
    if cleaned == "true":
        return True
    if cleaned == "false":
        return False
    if cleaned == "null":
        return None
    return cleaned


def extract_artifact_block(text: str) -> dict[str, object] | None:
    match = re.search(r"```yaml\nartifact:\n(?P<body>.*?)\n```", text, re.DOTALL)
    if not match:
        return None
    result: dict[str, object] = {}
    for line in match.group("body").splitlines():
        if not line.startswith("  "):
            continue
        key, sep, value = line.strip().partition(":")
        if not sep:
            continue
        result[key] = parse_scalar(value)
    return result


def parse_list(value: str) -> list[str]:
    cleaned = value.strip()
    if cleaned == "[]":
        return []
    if cleaned.startswith("[") and cleaned.endswith("]"):
        inner = cleaned[1:-1].strip()
        if not inner:
            return []
        return [item.strip().strip('"') for item in inner.split(",")]
    return [cleaned]


def extract_front_matter(text: str) -> dict[str, object] | None:
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---\n", 4)
    if end == -1:
        return None
    result: dict[str, object] = {}
    for line in text[4:end].splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        key, sep, value = line.partition(":")
        if not sep:
            continue
        key = key.strip()
        value = value.strip()
        result[key] = parse_list(value) if value.startswith("[") else parse_scalar(value)
    return result


def normalize_legacy_block(block: dict[str, object]) -> dict[str, object]:
    normalized = dict(block)
    if "run_path" in normalized and "runId" not in normalized:
        run_path = str(normalized["run_path"])
        normalized["runId"] = run_path.rstrip("/").split("/")[-1]
    if "mode" in normalized and "executionMode" not in normalized:
        normalized["executionMode"] = normalized["mode"]
    if "code_edits_allowed" in normalized and "allowsCodeEdit" not in normalized:
        normalized["allowsCodeEdit"] = normalized["code_edits_allowed"]
    if "stage" not in normalized:
        normalized["stage"] = "example"
    if "source" not in normalized:
        normalized["source"] = "example"
    if "nextAction" not in normalized:
        normalized["nextAction"] = "none"
    return normalized


def validate_with_schema(block: dict[str, object], schema: dict[str, object]) -> list[str]:
    errors: list[str] = []
    for key in schema.get("required", []):
        if key not in block:
            errors.append(f"missing artifact key: {key}")
    allowed = set(schema.get("properties", {}))
    for key in block:
        if key not in allowed and schema.get("additionalProperties") is False:
            errors.append(f"unexpected artifact key: {key}")
    properties = schema.get("properties", {})
    for key, rules in properties.items():
        if key not in block:
            continue
        value = block[key]
        if "const" in rules and value != rules["const"]:
            errors.append(f"{key} must be {rules['const']}")
        if "enum" in rules and value not in rules["enum"]:
            errors.append(f"{key} has invalid value: {value}")
        if rules.get("type") == "boolean" and not isinstance(value, bool):
            errors.append(f"{key} must be boolean")
        if rules.get("type") == "string" and not isinstance(value, str):
            errors.append(f"{key} must be string")
        if isinstance(rules.get("type"), list):
            type_names = rules["type"]
            ok = ("null" in type_names and value is None) or ("string" in type_names and isinstance(value, str))
            if not ok:
                errors.append(f"{key} has invalid type")
        if isinstance(value, str) and "pattern" in rules and not re.search(rules["pattern"], value):
            errors.append(f"{key} does not match pattern {rules['pattern']}")
        if isinstance(value, str) and "minLength" in rules and len(value) < rules["minLength"]:
            errors.append(f"{key} shorter than minLength")
    return errors


def validate_required_metadata(block: dict[str, object], path: Path, require_front_matter: bool) -> list[str]:
    errors: list[str] = []
    required = REQUIRED_FRONT_MATTER_KEYS if require_front_matter else REQUIRED_KEYS
    for key in required:
        if key not in block:
            errors.append(f"missing artifact key: {key}")
    if block.get("workflow") not in ALLOWED_WORKFLOWS and block.get("workflow") != "<workflow>":
        errors.append(f"workflow has invalid value: {block.get('workflow')}")
    if "runId" in block and not isinstance(block["runId"], str):
        errors.append("runId must be string")
    if "nextAction" in block and not isinstance(block["nextAction"], str):
        errors.append("nextAction must be string")
    if "allowsCodeEdit" in block and not isinstance(block["allowsCodeEdit"], bool):
        errors.append("allowsCodeEdit must be boolean")
    if "verificationRequired" in block and not isinstance(block["verificationRequired"], bool):
        errors.append("verificationRequired must be boolean")

    is_handoff = "handoff" in path.name or block.get("stage") == "handoff"
    if is_handoff:
        for key in REQUIRED_HANDOFF_KEYS:
            if key not in block:
                errors.append(f"missing handoff artifact key: {key}")
        if "selectedItems" in block and not isinstance(block["selectedItems"], list):
            errors.append("selectedItems must be list")
    return errors


def check_file(path: Path, schema: dict[str, object], require_verification: bool) -> list[str]:
    text = path.read_text(encoding="utf-8")
    block = extract_front_matter(text)
    has_front_matter = block is not None
    if block is None:
        block = extract_artifact_block(text)
        if block is not None:
            block = normalize_legacy_block(block)
    if block is None:
        if path.name.upper().startswith("README"):
            return []
        return ["missing artifact YAML front matter"]

    errors = validate_required_metadata(block, path, has_front_matter)
    is_template = any(part.endswith("templates") for part in path.parts)
    if not has_front_matter and is_template:
        errors.append("template must use YAML front matter")
    errors.extend(validate_with_schema(block, schema))
    if require_verification and "## Verification" not in text:
        errors.append("missing Verification section")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Check machine-readable artifact metadata blocks.")
    parser.add_argument("--schema", default="docs/artifact-metadata-schema.json")
    parser.add_argument("--require-verification", action="store_true")
    parser.add_argument("paths", nargs="+")
    args = parser.parse_args()
    schema = json.loads(Path(args.schema).read_text(encoding="utf-8"))

    failed = False
    for raw in args.paths:
        path = Path(raw)
        files = [path] if path.is_file() else sorted(path.rglob("*.md"))
        for file_path in files:
            errors = check_file(file_path, schema, args.require_verification)
            for error in errors:
                failed = True
                print(f"{file_path}: {error}", file=sys.stderr)

    if failed:
        return 1
    print("Artifact metadata checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
