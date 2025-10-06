#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess
import sys
import threading
import time
from pathlib import Path
from importlib.metadata import PackageNotFoundError, version
from typing import List, Optional

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

PKG = "gdscript-to-docs"   # package name
SPEC = ""                  # version specifier

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

class _Spinner:
    """Tiny CLI spinner."""
    def __init__(self, text: str, enabled: bool = True) -> None:
        self.text = text
        self._running = False
        self._thread: Optional[threading.Thread] = None
        self.enabled = enabled and sys.stderr.isatty()

    def start(self) -> None:
        """Start the spinner in a background thread."""
        if not self.enabled:
            return
        self._running = True
        self._thread = threading.Thread(target=self._run, daemon=True)
        self._thread.start()

    def _run(self) -> None:
        """Spinner loop."""
        glyphs = "|/-\\"
        i = 0
        while self._running:
            sys.stderr.write(f"\r{self.text} {glyphs[i % len(glyphs)]}")
            sys.stderr.flush()
            i += 1
            time.sleep(0.08)
        sys.stderr.write("\r" + " " * (len(self.text) + 2) + "\r")
        sys.stderr.flush()

    def stop(self, done_text: Optional[str] = None) -> None:
        """Stop the spinner and optionally print done_text."""
        if not self.enabled:
            return
        self._running = False
        if self._thread:
            self._thread.join()
        if done_text:
            sys.stderr.write(done_text + "\n")

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

def _run(cmd: List[str], cwd: Optional[Path] = None, env: Optional[dict] = None) -> subprocess.CompletedProcess:
    """Run a command and capture its output."""
    return subprocess.run(cmd, text=True, cwd=str(cwd) if cwd else None,
                          env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

def _clean_out(out_dir: Path) -> None:
    """Remove and recreate the output directory."""
    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

def _build_g2d_cmd_for_src(args, src: Path) -> List[str]:
    """
    Map our args to the gdscript_to_docs CLI you provided:

      gdscript_to_docs.main:
        src (positional)
        --out
        --keep-structure / --single-file / --make-index / --glob / --style / --split-functions

    We expose only --out and --make-index directly, and forward anything after --extra.
    """
    cmd = [sys.executable, "-m", "gdscript_to_docs", str(src)]
    if args.out:
        cmd += ["--out", str(args.out)]
    if args.make_index:
        cmd += ["--make-index"]
    if args.extra:
        cmd += args.extra
    return cmd

def _build_g2d_cmd_fallback_binary(args, src: Path) -> List[str]:
    """Fallback to using the installed binary if the module approach fails."""
    cmd = ["gdscript_to_docs", str(src)]
    if args.out:
        cmd += ["--out", str(args.out)]
    if args.make_index:
        cmd += ["--make-index"]
    if args.extra:
        cmd += args.extra
    return cmd

def generate_docs(args) -> int:
    """Generate docs based on parsed args."""
    color = args.color and sys.stdout.isatty()
    out_dir = Path(args.out)

    if args.clean:
        _clean_out(out_dir)

    if args.dry_run:
        print(_colorize(color, "[DRY RUN] Skipping generation.", Ansi.YELLOW))
        return 0

    spinner = _Spinner(_colorize(color, "Generating docs…", Ansi.CYAN), enabled=True)
    spinner.start()

    for src_str in args.paths:
        src_path = Path(src_str)
        if not src_path.exists():
            spinner.stop()
            print(_colorize(color, f"Path not found: {src_path}", Ansi.RED))
            return 2

        cmd = _build_g2d_cmd_for_src(args, src_path)
        proc = _run(cmd)

        if proc.returncode != 0:
            cmd2 = _build_g2d_cmd_fallback_binary(args, src_path)
            proc2 = _run(cmd2)
            spinner.stop()
            sys.stdout.write(proc.stdout)
            sys.stdout.write(proc2.stdout)
            if proc2.returncode != 0:
                print(_colorize(color, f"Failed running {PKG} for {src_path}.", Ansi.RED))
                return proc2.returncode
        else:
            if args.verbose:
                sys.stdout.write(proc.stdout)

    spinner.stop(_colorize(color, "Docs generated.", Ansi.GREEN))
    return 0

def _parse_args() -> argparse.Namespace:
    """Parse command-line arguments."""
    p = argparse.ArgumentParser(
        description="Generate API docs from GDScript sources."
    )
    p.add_argument("-o", "--out", default="docs/game", help="Output directory.")
    p.add_argument("--make-index", action="store_true", help="Create an index page if supported.")
    p.add_argument("--extra", nargs=argparse.REMAINDER, help="Pass-through args for the docs tool.", default=[])

    p.add_argument("--clean", action="store_true", help="Remove output dir before generation.")
    p.add_argument("--dry-run", action="store_true", help="Do not generate; just print steps.")
    p.add_argument("--pip-quiet", type=int, default=2, help="pip verbosity (0..3).")
    p.add_argument("--no-color", dest="color", action="store_false", help="Disable ANSI colors.")
    p.add_argument("-v", "--verbose", action="store_true", help="Print generator output.")
    p.add_argument(
        "paths",
        nargs="*",
        default=["./src/"],
        help="Files/dirs to process (default: current directory).",
    )
    return p.parse_args()

def main() -> None:
    args = _parse_args()
    _ensure_pkg(color=args.color and sys.stdout.isatty(), pip_quiet=args.pip_quiet)
    code = generate_docs(args)
    sys.exit(code)

if __name__ == "__main__":
    main()
