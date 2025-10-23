#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
import itertools
import threading
import time
import re
from subprocess import Popen, PIPE, STDOUT
from pathlib import Path
from importlib.metadata import PackageNotFoundError, version
from shutil import which
from typing import List

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from tools import scene_linter

PKG = "gdtoolkit"   # package name
SPEC = "==4.*"      # version specifier

# Error patterns from godot
ERROR_PATTERNS = (
    r"\bSCRIPT ERROR:",
    r"\bERROR:",
    r"\bFATAL:",
    r"\bCRASH:",
)

WARN_PATTERNS = (
    r"\bWARNING\b",
    r"\bWARN\b",
)

SUPPRESS_PATTERNS = (
    "LOG (",          # Kaldi/Vosk info
    "WARNING (Vosk",  # Vosk warnings
    "WARNING (Kaldi", # Kaldi warnings
    "VLOG[2] (VoskAPI",
    "ERROR: 1 resources still in use at exit (run with --verbose for details).",
    "   at: clear (core/io/resource.cpp:795)",
    "WARNING: ObjectDB instances leaked at exit (run with --verbose for details).",
    "   at: cleanup (core/object/object.cpp:2514)"
)

CLEAR_LEN = 120  # width for clearing spinner line

_error_re = re.compile("|".join(ERROR_PATTERNS))
_warn_re = re.compile("|".join(WARN_PATTERNS))

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

def _color_line(enabled: bool, line: str) -> str:
    if _error_re.search(line):
        return _colorize(enabled, line.rstrip("\n"), Ansi.RED) + "\n"
    if _warn_re.search(line):
        return _colorize(enabled, line.rstrip("\n"), Ansi.YELLOW) + "\n"
    return line

def _colorize(enabled: bool, text: str, *codes: str) -> str:
    """Wrap text in ANSI codes if enabled."""
    if not enabled:
        return text
    return "".join(codes) + text + Ansi.RESET

def _pip_install(color: bool, quiet: int = 2) -> None:
    """Install or upgrade the package to the specified version."""
    q = ["-q"] * max(0, min(quiet, 3))
    cmd = [
        sys.executable, "-m", "pip", "install",
        "--upgrade", f"{PKG}{SPEC}",
        "--disable-pip-version-check", "--no-input",
        "--progress-bar", "off",
        *q,
    ]
    proc = subprocess.run(cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if proc.returncode != 0:
        sys.stderr.write(proc.stdout)
        print(_colorize(color, f"Failed to install {PKG}{SPEC}.", Ansi.RED))
        proc.check_returncode()
    else:
        print(_colorize(color, f"Installed {PKG}{SPEC} successfully.", Ansi.GREEN))

def _ensure_pkg(color: bool, pip_quiet: int) -> None:
    """Ensure the package is installed and at the correct version."""
    try:
        ver = version(PKG)
        if not ver.startswith("4."):
            print(_colorize(color, f"{PKG} {ver} found, but not {SPEC}\ninstalling {PKG}{SPEC}...", Ansi.YELLOW))
            _pip_install(color, pip_quiet)
        else:
            print(_colorize(color, f"{PKG} {ver} OK.", Ansi.GREEN))
    except PackageNotFoundError:
        print(_colorize(color, f"{PKG} not installed\ninstalling {PKG}{SPEC}...", Ansi.YELLOW))
        _pip_install(color, pip_quiet)

def _resolve_godot_bin(cli_path: str | None) -> str | None:
    """
    Find a usable Godot binary. Search order: CLI arg, GODOT_BIN env, PATH, 
    tools/GODOT_BIN file, tools dir.
    """
    candidates: list[str] = []

    if cli_path:
        candidates.append(cli_path)

    env = os.environ.get("GODOT_BIN")
    if env:
        candidates.append(env)

    for name in ("godot", "godot-headless", "Godot"):
        p = which(name)
        if p:
            candidates.append(p)

    root = Path(__file__).resolve().parent.parent
    tools = root / "tools"

    marker = tools / "GODOT_BIN"
    if marker.exists():
        try:
            candidates.append(marker.read_text(encoding="utf-8").strip())
        except Exception:
            pass

    for pat in ("godot", "godot-headless", "Godot*", "Godot"):
        for found in tools.glob(pat):
            candidates.append(str(found))
        for found in tools.glob(pat + ".exe"):
            candidates.append(str(found))

    mac = tools / "Godot.app" / "Contents" / "MacOS" / "Godot"
    if mac.exists():
        candidates.append(str(mac))

    for c in candidates:
        if not c:
            continue
        p = Path(c)
        try:
            if p.exists() and os.access(str(p), os.X_OK):
                return str(p)
        except Exception:
            continue
    return None

def _hint_godot_setup() -> None:
    """Print hints for setting up Godot binary."""
    print("\nCould not find Godot. Try one of these:", file=sys.stderr)
    print("  • Pass --godot-bin PATH/TO/Godot", file=sys.stderr)
    print("  • Set env var:  GODOT_BIN=PATH/TO/Godot", file=sys.stderr)
    print("  • Put the binary (or symlink/wrapper) in ./tools/ as 'godot' or 'godot.exe'", file=sys.stderr)
    print("  • Or create ./tools/GODOT_BIN file containing the absolute path to your Godot binary", file=sys.stderr)

def _echo_cmd(color: bool, cmd: List[str]) -> None:
    """Echo the command to be run, nicely formatted."""
    print(_colorize(color, ">", Ansi.DIM), _colorize(color, " ".join(cmd), Ansi.DIM))

def _run_stream(color: bool, title: str, cmd: list[str], env: dict | None = None,
                suppress_logs: bool = False, enable_spinner: bool = False) -> int:
    """Run a command, streaming output live with a spinner."""
    print(_colorize(color, f"\n{title}", Ansi.BOLD, Ansi.BLUE))
    _echo_cmd(color, cmd)

    proc = Popen(cmd, stdout=PIPE, stderr=STDOUT, text=True, bufsize=1, env=env)
    stop = threading.Event()
    spinner = itertools.cycle("|/-\\")
    last_output = [time.time()]
    spinner_drawn = [False]
    seen_error = [False]

    def spin():
        if not enable_spinner:
            return
        while not stop.is_set():
            # only draw when it's been quiet for a moment
            if time.time() - last_output[0] > 0.3:
                sys.stdout.write("\r" + _colorize(color, f"Working {next(spinner)}", Ansi.DIM))
                sys.stdout.flush()
                spinner_drawn[0] = True
            time.sleep(0.1)

        if spinner_drawn[0]:
            sys.stdout.write("\r" + (" " * CLEAR_LEN) + "\r")
            sys.stdout.flush()

    t = threading.Thread(target=spin, daemon=True); t.start()

    try:
        if proc.stdout:
            for raw in proc.stdout:
                last_output[0] = time.time()
                line = raw
                if suppress_logs and any(line.startswith(p) for p in SUPPRESS_PATTERNS):
                    continue
                if _error_re.search(raw):
                    seen_error[0] = True
                sys.stdout.write(_color_line(color, line))
    finally:
        stop.set(); t.join()

    rc = proc.wait()
    if rc == 0 and seen_error[0]:
        print(_colorize(color, "✖ Failed", Ansi.RED))
    elif rc == 0:
        print(_colorize(color, "✔ Success", Ansi.GREEN))
    else:
        print(_colorize(color, "✖ Failed", Ansi.RED))
    return rc

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
    cmd += ["--diff", "--line-length", str(line_length), *paths]
    return _run(color, "gdformat", cmd)

def _run_lint(color: bool, paths: list[str]) -> int:
    """Run gdlint on the given paths."""
    cmd = ["gdlint", *paths]
    return _run(color, "gdlint", cmd)

def _run_scene_lint(color: bool, paths: list[str]) -> int:
    print(_colorize(color, "\nscene-linter", Ansi.BOLD, Ansi.BLUE))
    problems = scene_linter.lint(paths)
    if not problems:
        print(_colorize(color, "✔ Success", Ansi.GREEN))
        return 0

    by_file: dict[str, list[tuple[int, str]]] = {}
    for path, line, msg in problems:
        by_file.setdefault(str(path), []).append((line, msg))

    for file, items in sorted(by_file.items()):
        print(_colorize(color, file, Ansi.MAGENTA))
        for line, msg in sorted(items, key=lambda t: t[0]):
            loc = f"{line}: " if line > 0 else ""
            print(f"  {loc}{msg}")

    print(_colorize(color, "✖ Failed", Ansi.RED))
    return 1

def _run_smoke(color: bool, project_root: str, godot_bin_cli: str | None = None,
               report_every: int = 50, exclude_dirs: list[str] | None = None,
               spinner_mode: str = "auto") -> int:
    """Run Godot in headless mode to smoke-compile the project."""
    godot = _resolve_godot_bin(godot_bin_cli)
    if not godot:
        print(_colorize(color, "Godot binary not found.", Ansi.RED))
        _hint_godot_setup()
        return 3

    subprocess.run([godot, "--headless", "--version"], check=False, text=True)

    env = os.environ.copy()
    env["SMOKE_REPORT_EVERY"] = str(report_every)
    if exclude_dirs:
        env["SMOKE_EXCLUDE_DIRS"] = ";".join(exclude_dirs)

    cmd = [godot, "--headless", "--quiet", "--path", project_root,
           "--script", "res://tools/ci/smoke_compile.gd"]
    enable_spinner = (spinner_mode == "on") or (spinner_mode == "auto" and sys.stdout.isatty())
    return _run_stream(color, "godot-smoke", cmd, env=env, suppress_logs=True, enable_spinner=enable_spinner)

def main() -> None:
    ap = argparse.ArgumentParser(description="Format & lint GDScript.")
    ap.add_argument("--check", action="store_true", help="Check formatting instead of writing (good for CI).",)
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
    ap.add_argument("--format-only", action="store_true", help="Run formatter only.")
    ap.add_argument("--lint-only", action="store_true", help="Run linter only.")
    ap.add_argument("--scene-lint-only", action="store_true", help="Run scene linter only.")
    ap.add_argument("--smoke-only", action="store_true", help="Run Godot smoke-compile only.")
    ap.add_argument(
        "--pip-quiet", 
        type=int, 
        default=2, 
        help="0..3, number of -q flags for pip (default: 2)"
    )
    ap.add_argument("--godot-bin", default=None, help="Path to Godot binary (overrides env/auto-detect).")
    ap.add_argument("--project-root", default="./src/", help="Project root for Godot (--path).")
    ap.add_argument("--smoke-report-every", type=int, default=50, help="Progress interval for smoke.")
    ap.add_argument("--smoke-exclude", action="append", default=[], help="Exclude dir (res:// prefix). Repeatable.")
    ap.add_argument(
        "--smoke-spinner",
        choices=("auto", "on", "off"),
        default="auto",
        help="Spinner during smoke run: auto (TTY only), on, or off.",
    )
    ap.add_argument(
        "paths",
        nargs="*",
        default=["./src/"],
        help="Files/dirs to process (default: current directory).",
    )
    args = ap.parse_args()

    single_modes = sum(bool(x) for x in (args.format_only, args.lint_only, args.scene_lint_only, args.smoke_only))
    if single_modes > 1:
        print("Choose only one of --format-only, --lint-only, --only-scene-linter, --smoke-only.", file=sys.stderr)
        sys.exit(2)

    if args.color == "always":
        color = True
    elif args.color == "never":
        color = False
    else:
        color = sys.stdout.isatty() and os.environ.get("NO_COLOR") is None

    print(_colorize(color, f"[1/{ '2' if single_modes == 1 else '5' }] Ensuring gdtoolkit 4.*", Ansi.BOLD, Ansi.CYAN))
    _ensure_pkg(color, args.pip_quiet)

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

    if args.scene_lint_only:
        print(_colorize(color, "[2/2] Running scene linter", Ansi.BOLD, Ansi.CYAN))
        sys.exit(_run_scene_lint(color, args.paths))
    
    if args.smoke_only:
        print(_colorize(color, "[2/2] Running smoke compile", Ansi.BOLD, Ansi.CYAN))
        sys.exit(_run_smoke(color, args.project_root, args.godot_bin, args.smoke_report_every, args.smoke_exclude, args.smoke_spinner))

    print(_colorize(color, "[2/5] Running formatter", Ansi.BOLD, Ansi.CYAN))
    rc_fmt = _run_format(color, args.paths, args.check, args.line_length)
    if rc_fmt != 0:
        if args.check:
            print(_colorize(color, "Hint: run without --check to apply formatting.", Ansi.DIM))
        sys.exit(rc_fmt)

    print(_colorize(color, "[3/5] Running linter", Ansi.BOLD, Ansi.CYAN))
    rc_lint = _run_lint(color, args.paths)
    if rc_lint != 0:
        sys.exit(rc_lint)

    print(_colorize(color, "[4/5] Running scene linter", Ansi.BOLD, Ansi.CYAN))
    rc_scene = _run_scene_lint(color, args.paths)
    if rc_scene != 0:
        sys.exit(rc_scene)

    print(_colorize(color, "[5/5] Running smoke compile", Ansi.BOLD, Ansi.GREEN))
    rc_smoke = _run_smoke(color, args.project_root, args.godot_bin, args.smoke_report_every, args.smoke_exclude, args.smoke_spinner)
    sys.exit(rc_smoke)

if __name__ == "__main__":
    main()
