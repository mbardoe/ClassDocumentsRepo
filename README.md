# 📚 Course Markdown Handout Template Repository

This repository serves as a **template** for creating organized, Pandoc-powered course repositories that convert Markdown files into clean PDF handouts. It is designed for math, computer science, and other technical courses where instructors want full control over formatting and rendering using a lightweight, command-driven setup.

---

## Directory Structure

This repository includes the following core directories:

```
/Class_Notes
├── pdf/            # Rendered PDFs from your markdown notes
├── img/            # Images referenced in your markdown files
├── Lecture_01.md   # Example markdown files with embedded commands

/Class_Organization
├── pdf/            # PDFs for syllabi, schedules, policies, etc.

/tools
├── render.py       # The script that processes markdown to PDF
├── grid-header.tex # Optional LaTeX header to include grid background
```

---

## How It Works

- All markdown files (`.md`) placed in folders that contain a `pdf/` subdirectory can be processed.
- Files must include a `<!-- command: render -->` line to be turned into PDFs.
- Optional commands allow for landscape formatting and grid overlays.

---

## Supported Commands in `.md` Files

| Command                         | Description                                                               |
|----------------------------------|---------------------------------------------------------------------------|
| `<!-- command: render -->`       | Required for the file to be converted into a PDF                          |
| `<!-- command: grid -->`         | Adds a grid background using `grid-header.tex`                            |
| `<!-- command: landscape -->`    | Renders the PDF in landscape orientation                                  |

You can combine these in a single file.

---

## Image Support

- Any images referenced using relative paths (e.g. `![Graph](img/example.png)`) will work as long as the image is in the same folder or a subfolder of the `.md` file.
- This is supported via Pandoc’s `--resource-path`.

---

## How to Use the Renderer

1. Open a terminal in the **top-level directory** of your course repo (same level as `tools/`).
2. Run:

```bash
python tools/render.py
```

The script will:
- Look one level up from `tools/`
- Find all subdirectories that contain a `pdf/` folder
- Process `.md` files in those folders that include the `render` command
- Save the PDF output to the respective `pdf/` folders

---

## Requirements

- Python 3.6+
- [Pandoc](https://pandoc.org/)
- A working LaTeX installation (`pdflatex` recommended)

---

## Using This Template

To start a new course with this setup:

1. Click **"Use this template"** on GitHub to create a new repo based on this structure.
2. Rename folders as needed (e.g. `Class_Notes` → `Unit_1_Notes`)
3. Add markdown handouts and images.
4. Customize the `grid-header.tex` or replace it with your own.

---

## Customization Tips

- Add new directories for homework, projects, or labs — just include a `pdf/` subfolder to enable rendering.
- Update `render.py` to include new features (e.g., templates, metadata support).
- Track versioned syllabi or planning documents inside `Class_Organization`.

---

## Example Markdown File

```markdown
<!-- command: render -->
<!-- command: grid -->
<!-- command: landscape -->

# Day 1: Introduction to Functions

## Objectives
- Understand domain and range
- Work with multiple representations
```

---

## Need Help?

If you're unsure how to modify the renderer, open an issue or check the inline comments in `render.py` for guidance.
