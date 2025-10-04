#!/usr/bin/env python3
from __future__ import annotations
import argparse, re, sys
from pathlib import Path

VERSION_LINE_RE = re.compile(r'^\s*config/version\s*=\s*"?([^"\n]+)"?\s*$')
SECTION_RE      = re.compile(r'^\s*\[(.+?)\]\s*$')

def bump_semver(s: str, part: str) -> str:
    """Bump a semantic version string."""
    m = re.match(r'^(\d+)\.(\d+)\.(\d+)(.*)$', s)
    if not m:
        return "0.0.1"
    major, minor, patch, rest = map(str, m.groups())
    M, N, P = int(major), int(minor), int(patch)
    if part == "major":
        M, N, P, rest = M + 1, 0, 0, ""
    elif part == "minor":
        N, P, rest = N + 1, 0, ""
    else:
        P += 1
    return f"{M}.{N}.{P}{rest}"

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("project_godot", nargs="?", default="project.godot")
    ap.add_argument("--part", choices=("major","minor","patch"), default="patch")
    args = ap.parse_args()

    p = Path(args.project_godot)
    txt = p.read_text(encoding="utf-8").splitlines(keepends=True)

    i = 0
    in_app = False
    line_idx = None
    curr = None

    while i < len(txt):
        sec = SECTION_RE.match(txt[i])
        if sec:
            in_app = (sec.group(1).strip().lower() == "application")
        elif in_app:
            m = VERSION_LINE_RE.match(txt[i])
            if m:
                line_idx = i
                curr = m.group(1).strip()
                break
        i += 1

    if line_idx is None:
        insert_at = None
        if any(SECTION_RE.match(l) and SECTION_RE.match(l).group(1).strip().lower()=="application" for l in txt):
            for j,l in enumerate(txt):
                if SECTION_RE.match(l) and SECTION_RE.match(l).group(1).strip().lower()=="application":
                    insert_at = j+1
                    break
        else:
            txt.append("\n" if txt and not txt[-1].endswith("\n") else "")
            txt.append("[application]\n")
            insert_at = len(txt)

        new = "0.0.1"
        txt.insert(insert_at, f'config/version="{new}"\n')
        p.write_text("".join(txt), encoding="utf-8")
        print(f"(created)  - → {new}")
        return 0

    new = bump_semver(curr, args.part)
    if new == curr:
        print(f"(unchanged) {curr} -> {new}")
        return 0

    txt[line_idx] = f'config/version="{new}"\n'
    p.write_text("".join(txt), encoding="utf-8")
    print(f"{curr} -> {new}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
