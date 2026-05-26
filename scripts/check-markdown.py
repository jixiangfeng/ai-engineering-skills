#!/usr/bin/env python3
from __future__ import annotations

import argparse
import sys
from pathlib import Path


def iter_markdown(root: Path):
    for path in root.rglob("*.md"):
        if ".git" not in path.parts:
            yield path


def heading_level(line: str) -> int:
    stripped = line.lstrip()
    if not stripped.startswith("#"):
        return 0
    hashes = len(stripped) - len(stripped.lstrip("#"))
    if hashes > 6:
        return 0
    if len(stripped) > hashes and stripped[hashes] == " ":
        return hashes
    return 0


def check_file(path: Path) -> list[str]:
    errors: list[str] = []
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    if text and not text.endswith("\n"):
        errors.append("missing final newline")
    if len(text) > 1000 and len(lines) < 5:
        errors.append("document appears collapsed into too few lines")

    fence_count = 0
    previous_heading = 0
    for idx, line in enumerate(lines, start=1):
        if line.rstrip("\n\r") != line.rstrip():
            errors.append(f"line {idx}: trailing whitespace")
        if len(line) > 2000 and ("# " in line or "## " in line or "|" in line):
            errors.append(f"line {idx}: possible collapsed markdown structure")
        if line.startswith("```"):
            fence_count += 1
        level = heading_level(line)
        if level:
            if previous_heading and level > previous_heading + 1:
                errors.append(f"line {idx}: heading jumps from H{previous_heading} to H{level}")
            previous_heading = level

    if fence_count % 2:
        errors.append("unbalanced fenced code block")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Minimal markdown consistency checks.")
    parser.add_argument("paths", nargs="*", default=["."], help="Files or directories to check.")
    args = parser.parse_args()

    failed = False
    for raw in args.paths:
        path = Path(raw)
        files = [path] if path.is_file() else list(iter_markdown(path))
        for file_path in files:
            if file_path.suffix != ".md":
                continue
            errors = check_file(file_path)
            for error in errors:
                failed = True
                print(f"{file_path}: {error}", file=sys.stderr)

    if failed:
        return 1
    print("Markdown checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
