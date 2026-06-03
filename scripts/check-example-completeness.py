#!/usr/bin/env python3
from __future__ import annotations

import argparse
import pathlib
import re
import sys
from typing import Iterable

PATTERNS: tuple[tuple[str, re.Pattern[str]], ...] = (
    ("angle-bracket placeholder", re.compile(r"<(?:(?:YYYY|project-root|run|slug)[^>]*)>")),
    ("file-line placeholder", re.compile(r"path/to/file:line")),
    ("literal TODO placeholder", re.compile(r"(?:^|\s)(?:TODO|-- TODO)(?:\s|$)")),
    ("workflow status placeholder", re.compile(r"pending\s*/\s*approved\s*/\s*skipped")),
    ("severity legend placeholder", re.compile(r"critical\s*\|\s*high\s*\|\s*medium\s*\|\s*low")),
    ("evidence confidence placeholder", re.compile(r"事实\s*/\s*推断\s*/\s*待确认|高\s*/\s*中\s*/\s*低")),
)


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
        for label, pattern in PATTERNS:
            if pattern.search(line):
                issues.append(f"{path}:{line_no}: {label}: {line.strip()}")
    return issues


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail if published examples still contain template placeholders.",
    )
    parser.add_argument("paths", nargs="+", help="Markdown files or directories to scan")
    args = parser.parse_args()

    issues: list[str] = []
    for file_path in iter_markdown_files(args.paths):
        issues.extend(check_file(file_path))

    if issues:
        print("Example completeness checks failed.", file=sys.stderr)
        for issue in issues:
            print(issue, file=sys.stderr)
        return 1

    print("Example completeness checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
