#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)


def parse_scalar(value: str):
    cleaned = value.strip()
    if cleaned.startswith('"') and cleaned.endswith('"'):
        return cleaned[1:-1]
    if cleaned == "true":
        return True
    if cleaned == "false":
        return False
    if cleaned == "null":
        return None
    return cleaned


def extract_front_matter(text: str) -> dict[str, object]:
    if not text.startswith("---\n"):
        raise ValueError("missing YAML front matter")
    end = text.find("\n---\n", 4)
    if end == -1:
        raise ValueError("unterminated YAML front matter")
    result: dict[str, object] = {}
    for line in text[4:end].splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        key, sep, value = line.partition(":")
        if not sep:
            continue
        result[key.strip()] = parse_scalar(value)
    return result


def extract_machine_summary_block(text: str) -> str:
    match = re.search(r"## (?:Machine-Readable Summary|机器可读摘要)\s*```yaml\n(.*?)\n```", text, re.S)
    if not match:
        raise ValueError("missing machine-readable YAML block")
    return match.group(1)


def parse_top_level_yaml(block: str) -> dict[str, object]:
    lines = block.splitlines()
    result: dict[str, object] = {}
    i = 0
    while i < len(lines):
        raw = lines[i]
        if not raw.strip():
            i += 1
            continue
        if raw.startswith(" "):
            i += 1
            continue
        key, sep, remainder = raw.partition(":")
        if not sep:
            i += 1
            continue
        key = key.strip()
        remainder = remainder.strip()
        if remainder:
            if remainder == "[]":
                result[key] = []
            else:
                result[key] = parse_scalar(remainder)
            i += 1
            continue

        child_lines: list[str] = []
        i += 1
        while i < len(lines):
            nxt = lines[i]
            if nxt and not nxt.startswith(" "):
                break
            child_lines.append(nxt)
            i += 1
        result[key] = parse_child_block(child_lines)
    return result


def parse_child_block(lines: list[str]) -> object:
    meaningful = [line for line in lines if line.strip()]
    if not meaningful:
        return []
    stripped = [line.strip() for line in meaningful]
    if stripped[0].startswith("- "):
        simple_items: list[object] = []
        complex_detected = False
        for line in stripped:
            if not line.startswith("- "):
                complex_detected = True
                break
            body = line[2:].strip()
            if not body:
                simple_items.append("")
                continue
            if ":" in body:
                complex_detected = True
                break
            simple_items.append(parse_scalar(body))
        if not complex_detected:
            return simple_items

        items: list[object] = []
        current: dict[str, object] | None = None
        current_nested_list_key: str | None = None
        for line in meaningful:
            indent = len(line) - len(line.lstrip(" "))
            stripped_line = line.strip()
            if stripped_line.startswith("- "):
                body = stripped_line[2:].strip()
                if indent <= 2:
                    current = {}
                    current_nested_list_key = None
                    items.append(current)
                    if body and ":" in body:
                        subkey, _, subvalue = body.partition(":")
                        current[subkey.strip()] = parse_scalar(subvalue)
                    elif body:
                        items[-1] = parse_scalar(body)
                        current = None
                elif current is not None and current_nested_list_key is not None:
                    current.setdefault(current_nested_list_key, [])
                    nested = current[current_nested_list_key]
                    if isinstance(nested, list):
                        nested.append(parse_scalar(body))
            elif current is not None and ":" in stripped_line and indent >= 2:
                subkey, _, subvalue = stripped_line.partition(":")
                subkey = subkey.strip()
                subvalue = subvalue.strip()
                if not subvalue:
                    current[subkey] = []
                    current_nested_list_key = subkey
                else:
                    current[subkey] = parse_scalar(subvalue)
                    current_nested_list_key = None
        return items

    mapping: dict[str, object] = {}
    for line in meaningful:
        stripped_line = line.strip()
        if ":" not in stripped_line:
            continue
        key, _, value = stripped_line.partition(":")
        mapping[key.strip()] = parse_scalar(value)
    return mapping


def require_list(mapping: dict[str, object], key: str) -> list[object]:
    value = mapping.get(key)
    if isinstance(value, list):
        return value
    raise ValueError(f"{key} must be a YAML list")


def validate_route(repo_root: Path, shared_keys: list[str], route: dict[str, object]) -> list[str]:
    errors: list[str] = []
    template_path = repo_root / str(route["template"])
    artifacts_dir = repo_root / str(route["artifactsDir"])
    if not template_path.exists():
        return [f"template not found: {template_path}"]
    if not artifacts_dir.exists():
        return [f"artifactsDir not found: {artifacts_dir}"]

    text = template_path.read_text(encoding="utf-8")
    try:
        front_matter = extract_front_matter(text)
    except ValueError as exc:
        return [f"{template_path}: {exc}"]

    try:
        yaml_block = parse_top_level_yaml(extract_machine_summary_block(text))
    except ValueError as exc:
        return [f"{template_path}: {exc}"]

    source_workflow = str(route["sourceWorkflow"])
    target_workflow = str(route["targetWorkflow"])

    if front_matter.get("fromWorkflow") != source_workflow:
        errors.append(f"{template_path}: front matter fromWorkflow mismatch")
    if front_matter.get("toWorkflow") != target_workflow:
        errors.append(f"{template_path}: front matter toWorkflow mismatch")

    for key in shared_keys:
        if key not in yaml_block:
            errors.append(f"{template_path}: missing shared YAML key {key}")

    for key in route.get("requiredYamlKeys", []):
        if key not in yaml_block:
            errors.append(f"{template_path}: missing route YAML key {key}")

    if yaml_block.get("source_workflow") != source_workflow:
        errors.append(f"{template_path}: source_workflow mismatch")
    if yaml_block.get("target_workflow") != target_workflow:
        errors.append(f"{template_path}: target_workflow mismatch")
    if yaml_block.get("recommended_next_workflow") != target_workflow:
        errors.append(f"{template_path}: recommended_next_workflow mismatch")

    try:
        source_artifacts = require_list(yaml_block, "source_of_truth_artifacts")
    except ValueError as exc:
        errors.append(f"{template_path}: {exc}")
        source_artifacts = []

    normalized_artifacts = [item for item in source_artifacts if isinstance(item, str) and item]
    if not normalized_artifacts:
        errors.append(f"{template_path}: source_of_truth_artifacts must be non-empty")

    expected_artifacts = route.get("requiredSourceArtifacts", [])
    if normalized_artifacts != expected_artifacts:
        errors.append(
            f"{template_path}: source_of_truth_artifacts mismatch; expected {expected_artifacts}, got {normalized_artifacts}"
        )

    for artifact in expected_artifacts:
        if not (artifacts_dir / str(artifact)).exists():
            errors.append(f"{template_path}: referenced artifact does not exist: {artifact}")

    for list_key in ("accepted_scope", "excluded_scope", "constraints", "unresolved_questions", "verification_focus"):
        if list_key in yaml_block and not isinstance(yaml_block[list_key], list):
            errors.append(f"{template_path}: {list_key} must be a YAML list")

    if source_workflow == "code-review-triage":
        if not isinstance(yaml_block.get("selected_findings"), list):
            errors.append(f"{template_path}: selected_findings must be a YAML list")
        if not isinstance(yaml_block.get("excluded_findings"), list):
            errors.append(f"{template_path}: excluded_findings must be a YAML list")
        if not isinstance(yaml_block.get("architecture_gate"), dict):
            errors.append(f"{template_path}: architecture_gate must be a YAML mapping")
        if not isinstance(yaml_block.get("forbidden_scope"), list):
            errors.append(f"{template_path}: forbidden_scope must be a YAML list")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate machine-readable handoff contracts")
    parser.add_argument(
        "--matrix",
        default="docs/handoff-routing-matrix.json",
        help="Path to handoff routing matrix JSON relative to repo root",
    )
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parent.parent
    matrix_path = repo_root / args.matrix
    matrix = json.loads(matrix_path.read_text(encoding="utf-8"))

    shared_keys = matrix.get("sharedYamlKeys", [])
    routes = matrix.get("routes", [])
    errors: list[str] = []
    for route in routes:
        errors.extend(validate_route(repo_root, shared_keys, route))

    if errors:
        for error in errors:
            fail(error)
        return 1

    print("Handoff contract checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
