#!/usr/bin/env python3
"""Validate workflow-state JSON files against the repository schema.

By default this uses a small standard-library validator that covers the schema
features used by docs/workflow-state-schema.json. Pass --strict-jsonschema to
use the external jsonschema package when it is installed.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_json(path: Path) -> Any:
    try:
        with path.open("r", encoding="utf-8") as fh:
            return json.load(fh)
    except json.JSONDecodeError as exc:
        fail(f"{path}: invalid JSON at line {exc.lineno}, column {exc.colno}: {exc.msg}")
    except OSError as exc:
        fail(f"{path}: cannot read file: {exc}")


def type_name(value: Any) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "boolean"
    if isinstance(value, str):
        return "string"
    if isinstance(value, list):
        return "array"
    if isinstance(value, dict):
        return "object"
    return type(value).__name__


def allowed_types(spec: Any) -> set[str]:
    if isinstance(spec, list):
        return set(spec)
    return {spec}


def validate_schema_shape(schema: dict[str, Any], schema_path: Path) -> None:
    required_top = {"type", "required", "additionalProperties", "properties"}
    missing = required_top - set(schema)
    if missing:
        fail(f"{schema_path}: schema missing top-level keys: {', '.join(sorted(missing))}")
    if schema.get("type") != "object":
        fail(f"{schema_path}: schema type must be object")
    if schema.get("additionalProperties") is not False:
        fail(f"{schema_path}: additionalProperties must be false")
    if not isinstance(schema.get("required"), list):
        fail(f"{schema_path}: required must be an array")
    if not isinstance(schema.get("properties"), dict):
        fail(f"{schema_path}: properties must be an object")


def validate_state(schema: dict[str, Any], state: dict[str, Any], state_path: Path) -> list[str]:
    errors: list[str] = []
    required = schema["required"]
    properties = schema["properties"]

    for field in required:
        if field not in state:
            errors.append(f"missing required field: {field}")

    if schema.get("additionalProperties") is False:
        extra = sorted(set(state) - set(properties))
        for field in extra:
            errors.append(f"unexpected field: {field}")

    for field, spec in properties.items():
        if field not in state:
            continue
        value = state[field]
        actual_type = type_name(value)
        expected_types = allowed_types(spec.get("type"))
        if actual_type not in expected_types:
            errors.append(
                f"{field}: expected {sorted(expected_types)}, got {actual_type}"
            )
            continue
        if "const" in spec and value != spec["const"]:
            errors.append(f"{field}: expected const {spec['const']!r}, got {value!r}")
        if "enum" in spec and value not in spec["enum"]:
            errors.append(f"{field}: value {value!r} is not in enum")
        if actual_type == "string" and spec.get("minLength") is not None:
            if len(value) < int(spec["minLength"]):
                errors.append(f"{field}: string shorter than minLength {spec['minLength']}")
        if actual_type == "array" and "items" in spec:
            item_types = allowed_types(spec["items"].get("type"))
            for index, item in enumerate(value):
                item_type = type_name(item)
                if item_type not in item_types:
                    errors.append(
                        f"{field}[{index}]: expected {sorted(item_types)}, got {item_type}"
                    )

    if not isinstance(state, dict):
        errors.append(f"{state_path}: state must be a JSON object")
    return errors


def validate_with_jsonschema(schema: dict[str, Any], state: dict[str, Any], state_path: Path) -> list[str]:
    try:
        import jsonschema  # type: ignore[import-not-found]
    except ImportError:
        fail("--strict-jsonschema requires the optional jsonschema package")

    validator = jsonschema.Draft202012Validator(schema)
    return [f"{state_path}: {error.message}" for error in sorted(validator.iter_errors(state), key=str)]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--schema",
        default="docs/workflow-state-schema.json",
        help="Path to workflow-state schema JSON.",
    )
    parser.add_argument(
        "--strict-jsonschema",
        action="store_true",
        help="Use the optional jsonschema package for full JSON Schema validation.",
    )
    parser.add_argument("states", nargs="+", help="workflow-state JSON files to validate.")
    args = parser.parse_args()

    schema_path = Path(args.schema)
    schema = load_json(schema_path)
    if not isinstance(schema, dict):
        fail(f"{schema_path}: schema must be a JSON object")
    validate_schema_shape(schema, schema_path)

    failed = False
    for state_arg in args.states:
        state_path = Path(state_arg)
        state = load_json(state_path)
        if not isinstance(state, dict):
            print(f"ERROR: {state_path}: state must be a JSON object", file=sys.stderr)
            failed = True
            continue
        if args.strict_jsonschema:
            errors = validate_with_jsonschema(schema, state, state_path)
        else:
            errors = validate_state(schema, state, state_path)
        if errors:
            failed = True
            for error in errors:
                print(f"ERROR: {state_path}: {error}", file=sys.stderr)
        else:
            print(f"OK: {state_path}")

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
