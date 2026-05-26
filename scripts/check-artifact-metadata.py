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
    "run_path",
    "mode",
    "status",
    "code_edits_allowed",
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


def check_file(path: Path, schema: dict[str, object], require_verification: bool) -> list[str]:
    text = path.read_text(encoding="utf-8")
    block = extract_artifact_block(text)
    if block is None:
        if path.name.upper().startswith("README"):
            return []
        return ["missing artifact YAML block"]

    errors = validate_with_schema(block, schema)
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
