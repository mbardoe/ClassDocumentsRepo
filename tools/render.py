from pathlib import Path
from datetime import datetime
import subprocess
import argparse
import sys
import os

HOME_DIRECTORY = ".."


def _supports_color():
    # Basic TTY check; colorama is optional (see below)
    return sys.stdout.isatty()


class Colors:
    def __init__(self, enable: bool):
        self.enable = enable
        if enable:
            # Try colorama on Windows for reliable ANSI; fallback to raw ANSI
            try:
                from colorama import init  # type: ignore
                init()
            except Exception:
                pass
            self.GREEN = "\033[32m"
            self.YELLOW = "\033[33m"
            self.CYAN = "\033[36m"
            self.DIM = "\033[2m"
            self.RESET = "\033[0m"
        else:
            self.GREEN = self.YELLOW = self.CYAN = self.DIM = self.RESET = ""

    def green(self, s): return f"{self.GREEN}{s}{self.RESET}" if self.enable else s
    def yellow(self, s): return f"{self.YELLOW}{s}{self.RESET}" if self.enable else s
    def cyan(self, s): return f"{self.CYAN}{s}{self.RESET}" if self.enable else s
    def dim(self, s): return f"{self.DIM}{s}{self.RESET}" if self.enable else s


class Renderer:
    def __init__(self, home_directory: str = '', dry_run: bool = False, color: bool = True):
        print("Version 4 Markdown Render (recursive, update-on-change, dry-run, colors)")
        self.home_directory = Path(home_directory).resolve()
        self.script_dir = Path(__file__).resolve().parent
        self.dry_run = dry_run
        self.colors = Colors(enable=color and _supports_color())
        self._built = 0
        self._skipped = 0

    def render(self):
        print(f"Scanning recursively from: {self.colors.cyan(str(self.home_directory))}")

        # Recursively find all directories that contain an existing "pdf" subfolder
        pdf_directories = []
        for directory in self.home_directory.rglob("*"):
            if directory.is_dir() and (directory / "pdf").is_dir():
                pdf_directories.append(directory)

        if not pdf_directories:
            print("No directories containing a 'pdf' subfolder were found.")
            return

        for directory in sorted(pdf_directories):
            print(f"\n📂 Processing directory: {directory}")
            md_files = sorted(directory.glob("*.md"))
            if not md_files:
                print("  (no .md files found)")
                continue
            for file in md_files:
                self.process_file(directory, file)

        # Summary
        print("\n— Summary —")
        print(self.colors.yellow(f"  Built:  {self._built}"))
        print(self.colors.green(f"  Skipped:{self._skipped}"))

    def process_file(self, directory: Path, filename: Path):
        commands = self._extract_commands(filename)
        if 'render' not in commands:
            # Skip files not marked for rendering
            return

        output_dir = directory / "pdf"   # do NOT create; only process if it exists
        output_pdf = output_dir / f"{filename.stem}.pdf"

        md_mtime = filename.stat().st_mtime
        md_fmt = self._fmt(md_mtime)

        build_reason = None
        if not output_pdf.exists():
            build_reason = "pdf missing"
        else:
            pdf_mtime = output_pdf.stat().st_mtime
            if md_mtime > pdf_mtime:
                build_reason = "markdown is newer"
            else:
                self._skipped += 1
                print(f"  {self.colors.green('SKIP')} {filename.name:30} "
                      f"[md: {md_fmt} | pdf: {self._fmt(pdf_mtime)}]")
                return

        pandoc_cmd = [
            "pandoc", "-s", str(filename),
            "--pdf-engine=pdflatex",
            f"--resource-path={directory}",
        ]

        if 'landscape' in commands:
            pandoc_cmd += ["-V", "geometry:landscape,margin=0.5in"]
        else:
            pandoc_cmd += ["-V", "geometry:margin=.5in", "-V", "papersize:letter"]

        if 'grid' in commands:
            pandoc_cmd += ["-H", str(self.script_dir / "grid-header.tex")]
        pandoc_cmd += ["-H", str(self.script_dir / "tikz-header.tex")]

        pandoc_cmd += ["-o", str(output_pdf)]

        print(f"  {self.colors.yellow('BUILD')} {filename.name:30} ({build_reason}) -> {output_pdf.name}")
        print(f"    {self.colors.dim(' '.join(map(str, pandoc_cmd)))}")

        if not self.dry_run:
            subprocess.run(pandoc_cmd, check=False)
        self._built += 1

    def _extract_commands(self, filename: Path):
        commands = []
        with open(filename, "r", encoding="utf8") as f:
            for raw in f:
                line = raw.strip()
                if line.startswith("<!--") and "command:" in line:
                    try:
                        content = line.split("command:", 1)[1]
                        command = content.split("-->", 1)[0].strip()
                        commands.append(command)
                    except IndexError:
                        print(f"  (malformed command comment in {filename.name})")
                        continue
        if commands:
            print(f"  {filename.name:30} commands -> {commands}")
        return commands

    @staticmethod
    def _fmt(ts):
        return datetime.fromtimestamp(ts).strftime("%Y-%m-%d %H:%M:%S")


def parse_args():
    p = argparse.ArgumentParser(description="Render Markdown to PDF only when updated (recursive).")
    p.add_argument("--home", default=HOME_DIRECTORY, help="Home directory to scan (default: ..)")
    p.add_argument("--dry-run", action="store_true", help="Show what would be built; do not run pandoc.")
    p.add_argument("--no-color", action="store_true", help="Disable colored output.")
    return p.parse_args()


if __name__ == '__main__':
    args = parse_args()
    r = Renderer(home_directory=args.home, dry_run=args.dry_run, color=not args.no_color)
    r.render()
