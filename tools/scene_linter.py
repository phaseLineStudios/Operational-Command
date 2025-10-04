#!/usr/bin/env python3
from __future__ import annotations
import re
from pathlib import Path
from typing import Iterable, List, Tuple

# Regex rules
FILENAME_RE = re.compile(r"^[a-z0-9]+(?:_[a-z0-9]+)*\.tscn$")
PASCAL_RE   = re.compile(r"^[A-Z][A-Za-z0-9]*$")

NODE_DECL_RE = re.compile(r'^\s*\[node\b[^\]]*\bname="([^"]+)"')

Violation = Tuple[Path, int, str]


def _iter_tscn_files(paths: Iterable[str]) -> Iterable[Path]:
    for p in map(Path, paths):
        if p.is_file() and p.suffix == ".tscn":
            yield p
        elif p.is_dir():
            for f in p.rglob("*.tscn"):
                if f.name.endswith(".tscn"):
                    yield f


def _check_filename(path: Path) -> List[Violation]:
    v: List[Violation] = []
    if not FILENAME_RE.match(path.name):
        v.append((path, 0, f"Filename '{path.name}' must match regex {FILENAME_RE.pattern}"))
    return v


def _check_nodes(path: Path) -> List[Violation]:
    v: List[Violation] = []
    try:
        with path.open("r", encoding="utf-8") as f:
            for i, line in enumerate(f, start=1):
                m = NODE_DECL_RE.search(line)
                if not m:
                    continue
                node_name = m.group(1)
                if not PASCAL_RE.match(node_name):
                    v.append((path, i, f"Node name '{node_name}' must match regex {PASCAL_RE.pattern}"))
    except UnicodeDecodeError:
        v.append((path, 0, "File is not valid UTF-8 (cannot lint)"))
    return v


def lint(paths: Iterable[str]) -> List[Violation]:
    """Return a list of violations. Empty list means success."""
    violations: List[Violation] = []
    for scene in _iter_tscn_files(paths):
        violations.extend(_check_filename(scene))
        violations.extend(_check_nodes(scene))
    return violations

if __name__ == "__main__":
    import sys
    targets = sys.argv[1:] or ["."]
    problems = lint(targets)
    if not problems:
        print("Scene linter: OK")
        sys.exit(0)
    for path, line, msg in problems:
        loc = f"{path}" if line <= 0 else f"{path}:{line}"
        print(f"{loc}: {msg}")
    sys.exit(1)
