import argparse
import os
import subprocess
import sys
from importlib.metadata import PackageNotFoundError, version
from shutil import which
from typing import List

PKG = "gdtoolkit"   # package name
SPEC = "==4.*"      # version specifier

class Ansi:
    """ANSI escape codes for terminal colors."""
    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"

def _colorize(enabled: bool, text: str, *codes: str) -> str:
    """Wrap text in ANSI codes if enabled."""
    if not enabled:
        return text
    return "".join(codes) + text + Ansi.RESET

def _pip_install() -> None:
    """Install or upgrade the package to the specified version."""
    subprocess.run(
        [sys.executable, "-m", "pip", "install", "--upgrade", f"{PKG}{SPEC}"],
        check=True,
    )

def _ensure_pkg(color: bool) -> None:
    """Ensure the package is installed and at the correct version."""
    try:
        ver = version(PKG)
        if not ver.startswith("4."):
            print(_colorize(color, f"{PKG} {ver} found, but not {SPEC}; installing {PKG}{SPEC}...", Ansi.YELLOW))
            _pip_install()
        else:
            print(_colorize(color, f"{PKG} {ver} OK.", Ansi.GREEN))
    except PackageNotFoundError:
        print(_colorize(color, f"{PKG} not installed; installing {PKG}{SPEC}...", Ansi.YELLOW))
        _pip_install()

def _echo_cmd(color: bool, cmd: List[str]) -> None:
    """Echo the command to be run, nicely formatted."""
    print(_colorize(color, ">", Ansi.DIM), _colorize(color, " ".join(cmd), Ansi.DIM))

def _run(color: bool, title: str, cmd: List[str]) -> int:
    """Run a command, capturing and formatting output."""
    print(_colorize(color, f"\n{title}", Ansi.BOLD, Ansi.BLUE))
    _echo_cmd(color, cmd)

    proc = subprocess.run(cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.stdout:
        print(proc.stdout, end="")
    if proc.stderr:
        sys.stderr.write(_colorize(color, proc.stderr, Ansi.RED))
    if proc.returncode == 0:
        print(_colorize(color, "✔ Success", Ansi.GREEN))
    else:
        print(_colorize(color, "✖ Failed", Ansi.RED))
    return proc.returncode

def _run_format(color: bool, paths: list[str], check: bool, line_length: int) -> int:
    """Run gdformat on the given paths."""
    cmd = ["gdformat"]
    if check:
        cmd.append("--check")
    cmd += ["--line-length", str(line_length), *paths]
    return _run(color, "gdformat", cmd)

def _run_lint(color: bool, paths: list[str]) -> int:
    """Run gdlint on the given paths."""
    cmd = ["gdlint", *paths]
    return _run(color, "gdlint", cmd)

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Format & lint GDScript."
    )
    ap.add_argument(
        "--check",
        action="store_true",
        help="Check formatting instead of writing (good for CI).",
    )
    ap.add_argument(
        "--line-length",
        type=int,
        default=100,
        help="Max line length for gdformat (default: 100).",
    )
    ap.add_argument(
        "--color",
        choices=("auto", "always", "never"),
        default="auto",
        help="Colorize output (default: auto).",
    )
    ap.add_argument(
        "--format-only", 
        action="store_true", 
        help="Run formatter only."
    )
    ap.add_argument(
        "--lint-only", 
        action="store_true", 
        help="Run linter only."
    )
    ap.add_argument(
        "paths",
        nargs="*",
        default=["."],
        help="Files/dirs to process (default: current directory).",
    )
    args = ap.parse_args()

    if args.format_only and args.lint_only:
        print("Choose either --format-only or --lint-only (not both).", file=sys.stderr)
        sys.exit(2)

    if args.color == "always":
        color = True
    elif args.color == "never":
        color = False
    else:
        color = sys.stdout.isatty() and os.environ.get("NO_COLOR") is None

    print(_colorize(color, "[1/3] Ensuring gdtoolkit 4.* ...", Ansi.BOLD, Ansi.CYAN))
    _ensure_pkg(color)

    if which("gdformat") is None or which("gdlint") is None:
        print(
            _colorize(
                color,
                "Note: 'gdformat'/'gdlint' not on PATH. If you use a venv, activate it "
                "before running this script (or install with pipx).",
                Ansi.YELLOW,
            )
        )

    if args.format_only:
        print(_colorize(color, "[2/2] Running formatter", Ansi.BOLD, Ansi.CYAN))
        sys.exit(_run_format(color, args.paths, args.check, args.line_length))

    if args.lint_only:
        print(_colorize(color, "[2/2] Running linter", Ansi.BOLD, Ansi.CYAN))
        sys.exit(_run_lint(color, args.paths))

    print(_colorize(color, "[2/3] Running formatter", Ansi.BOLD, Ansi.CYAN))
    rc_fmt = _run_format(color, args.paths, args.check, args.line_length)
    if rc_fmt != 0:
        if args.check:
            print(_colorize(color, "Hint: run without --check to apply formatting.", Ansi.DIM))
        sys.exit(rc_fmt)

    print(_colorize(color, "[3/3] Running linter", Ansi.BOLD, Ansi.CYAN))
    rc_lint = _run_lint(color, args.paths)
    sys.exit(rc_lint)

if __name__ == "__main__":
    main()
