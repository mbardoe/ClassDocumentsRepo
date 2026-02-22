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
        print("Version 5 Markdown + Typst Render (recursive, update-on-change, dry-run, colors)")
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
            typ_files = sorted(directory.glob("*.typ"))

            if not md_files and not typ_files:
                print("  (no .md or .typ files found)")
                continue

            # Group files by stem and resolve conflicts
            files_by_stem: dict[str, dict[str, Path]] = {}

            for f in md_files:
                files_by_stem.setdefault(f.stem, {})[".md"] = f
            for f in typ_files:
                files_by_stem.setdefault(f.stem, {})[".typ"] = f

            for stem in sorted(files_by_stem.keys()):
                exts = files_by_stem[stem]
                chosen: Path | None = None

                if ".typ" in exts and ".md" in exts:
                    # Conflict: both exist. Prefer Typst, warn about Markdown.
                    chosen = exts[".typ"]
                    skipped = exts[".md"]
                    print(
                        f"  ⚠️  Both {stem}.md and {stem}.typ found; "
                        f"using {self.colors.cyan(stem + '.typ')} and skipping {skipped.name}"
                    )
                elif ".typ" in exts:
                    chosen = exts[".typ"]
                elif ".md" in exts:
                    chosen = exts[".md"]

                if chosen is not None:
                    self.process_file(directory, chosen)

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

        src_mtime = filename.stat().st_mtime
        src_fmt = self._fmt(src_mtime)

        build_reason = None
        if not output_pdf.exists():
            build_reason = "pdf missing"
        else:
            pdf_mtime = output_pdf.stat().st_mtime
            if src_mtime > pdf_mtime:
                build_reason = "source is newer"
            else:
                self._skipped += 1
                print(
                    f"  {self.colors.green('SKIP')} {filename.name:30} "
                    f"[src: {src_fmt} | pdf: {self._fmt(pdf_mtime)}]"
                )
                return

        ext = filename.suffix.lower()

        if ext == ".md":
            # Original Pandoc + LaTeX pipeline
            cmd = [
                "pandoc", "-s", str(filename),
                "--pdf-engine=pdflatex",
                f"--resource-path={directory}",
            ]

            if 'landscape' in commands:
                cmd += ["-V", "geometry:landscape,margin=0.5in"]
            else:
                cmd += ["-V", "geometry:margin=.5in", "-V", "papersize:letter"]

            if 'grid' in commands:
                cmd += ["-H", str(self.script_dir / "grid-header.tex")]
            cmd += ["-H", str(self.script_dir / "tikz-header.tex")]

            cmd += ["-o", str(output_pdf)]

        elif ext == ".typ":
            # Typst pipeline
            # Basic:
            #   typst compile file.typ pdf/file.pdf
            cmd = [
                "typst",
                "compile",
                str(filename),
                str(output_pdf),
            ]

            # If you later want to wire grid/landscape into Typst via inputs,
            # you can do something like:
            #
            # if 'grid' in commands:
            #     cmd.extend(["--input", "grid=true"])
            # if 'landscape' in commands:
            #     cmd.extend(["--input", "landscape=true"])

        else:
            # Unknown file type; ignore
            return

        print(f"  {self.colors.yellow('BUILD')} {filename.name:30} ({build_reason}) -> {output_pdf.name}")
        print(f"    {self.colors.dim(' '.join(map(str, cmd)))}")

        if not self.dry_run:
            subprocess.run(cmd, check=False)
        self._built += 1

    def _extract_commands(self, filename: Path):
        """
        Extracts command markers from the file.

        Supported syntaxes:

        - Old Markdown / HTML style:
            <!-- command: render -->
            <!-- command: grid -->

        - Typst line comments:
            // command: render
            // command: grid

        - Typst block comments (single-line):
            /* command: render */
        """
        commands = []
        with open(filename, "r", encoding="utf8") as f:
            for raw in f:
                line = raw.strip()
                if "command:" not in line:
                    continue

                try:
                    if line.startswith("<!--"):
                        # HTML-style: <!-- command: render -->
                        content = line.split("command:", 1)[1]
                        command = content.split("-->", 1)[0].strip()
                    elif line.startswith("//"):
                        # Typst line comment: // command: render
                        content = line.split("command:", 1)[1]
                        command = content.strip()
                    elif line.startswith("/*"):
                        # Typst block comment (single-line): /* command: render */
                        content = line.split("command:", 1)[1]
                        command = content.split("*/", 1)[0].strip()
                    else:
                        # Unknown style; ignore
                        continue

                    if command:
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
    p = argparse.ArgumentParser(
        description="Render Markdown and Typst files to PDF only when updated (recursive)."
    )
    p.add_argument("--home", default=HOME_DIRECTORY,
                   help="Home directory to scan (default: ..)")
    p.add_argument("--dry-run", action="store_true",
                   help="Show what would be built; do not run pandoc/typst.")
    p.add_argument("--no-color", action="store_true",
                   help="Disable colored output.")
    return p.parse_args()


if __name__ == '__main__':
    args = parse_args()
    r = Renderer(home_directory=args.home, dry_run=args.dry_run, color=not args.no_color)
    r.render()
