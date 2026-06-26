#!/usr/bin/env python3
from __future__ import annotations

import argparse
import pathlib
import re
import sys
from collections.abc import Iterable

TODO_PATTERN = re.compile(r"(?:^|\s)(?:TODO|-- TODO)(?:\s|$)")


def iter_markdown_files(paths: Iterable[str]) -> Iterable[pathlib.Path]:
    for raw in paths:
        path = pathlib.Path(raw)
        if not path.exists():
            raise FileNotFoundError(f"Missing path: {path}")
        if path.is_file():
            if path.suffix.lower() == ".md":
                yield path
            continue
        for child in sorted(path.rglob("*.md")):
            if any(part.startswith(".") for part in child.parts):
                continue
            yield child


def check_file(path: pathlib.Path) -> list[str]:
    issues: list[str] = []
    for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        if TODO_PATTERN.search(line):
            issues.append(f"{path}:{line_no}: unresolved TODO placeholder: {line.strip()}")
    return issues


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail if published workflow templates contain unresolved TODO placeholders.",
    )
    parser.add_argument("paths", nargs="+", help="Markdown files or directories to scan")
    args = parser.parse_args()

    issues: list[str] = []
    for file_path in iter_markdown_files(args.paths):
        issues.extend(check_file(file_path))

    if issues:
        print("Template placeholder checks failed.", file=sys.stderr)
        for issue in issues:
            print(issue, file=sys.stderr)
        return 1

    print("Template placeholder checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
