# Renderer: Markdown-to-PDF Tool for Handouts

This tool makes it easy for teachers to convert Markdown-based handouts into polished PDF files using Pandoc. It supports optional layout commands embedded directly in Markdown and only rebuilds PDFs when needed.

---

## 📁 Folder Structure

The `render.py` script should live inside a `tools/` subdirectory, while your handouts are organized in sibling directories such as:

```
/MyCourse
├── Week01
│   ├── HW1.md
│   └── pdf/
├── Week02
│   ├── Notes.md
│   └── pdf/
├── ExamReview
│   ├── ReviewSheet.md
│   └── pdf/
└── tools
    ├── render.py
    └── grid-header.tex
```

Each handout directory should contain:

- One or more `.md` files
- A pre-existing `pdf/` subfolder for generated output (**this tool will not create the folder automatically**)

The `tools/` directory contains:

- `render.py` — the rendering script
- `grid-header.tex` — optional background template for the `grid` command

---

## 🔍 How It Works

1. The script scans **recursively** starting from the directory above `tools/`.
2. It finds all folders that contain a `pdf/` subfolder.
3. It scans those folders for `.md` files.
4. A file is rendered to PDF *only if it contains the command*:

   ```markdown
   <!-- command: render -->
   ```

5. **Rebuild logic:**  
   - If no PDF exists → build it  
   - If the `.md` file is newer than the `.pdf` → rebuild it  
   - Otherwise → skip (up-to-date)

6. PDFs are written into the existing `pdf/` subfolder.

---

## 🧠 Supported Commands

Add commands as HTML comments in the `.md` file:

| Command                           | Description |
|----------------------------------|--------------|
| `<!-- command: render -->`       | **Required**: file will be converted to a PDF |
| `<!-- command: grid -->`         | Adds a grid background (requires `grid-header.tex`) |
| `<!-- command: landscape -->`    | Renders PDF in landscape orientation |

Commands may be combined.

---

## 🧱 `grid-header.tex`

If using the `grid` command, ensure that `grid-header.tex` is located next to `render.py`:

```
tools/grid-header.tex
```

The script uses an absolute path to include it reliably.

---

## 🖼️ Images

Include images in Markdown using relative paths, for example:

```markdown
![Diagram](images/plot.png)
```

Images are supported as long as the paths are valid relative to the `.md` file.  
Pandoc’s `--resource-path` flag is used to ensure correct inclusion.

---

## ▶️ Running the Script

From the **top-level course directory**, run:

```bash
python tools/render.py
```

### Optional Flags

| Flag | Description |
|------|--------------|
| `--dry-run` | Show what would be built, but do not run Pandoc |
| `--no-color` | Disable colored output (useful in CI or logs) |
| `--home PATH` | Override the default directory to scan |

**Examples:**

Dry run only (no files built):

```bash
python tools/render.py --dry-run
```

Run without color:

```bash
python tools/render.py --no-color
```

Render a different course folder:

```bash
python tools/render.py --home ../Algebra2
```

---

## ✅ Requirements

- Python 3.8+
- [Pandoc](https://pandoc.org/)
- A LaTeX engine such as `pdflatex`
- Optional: `grid-header.tex` for grid-style handouts

---

## ✨ Example Markdown File

```markdown
<!-- command: render -->
<!-- command: landscape -->
<!-- command: grid -->

# Homework 5

Here are some problems for today.

1. Let $f(x) = 3x + 2$. Find $f^{-1}(x)$.
```

---

## 📝 Notes

- The script never auto-creates `pdf/` directories — create them yourself in any folder you wish to render.
- Skipped vs. built files are clearly reported, with an end-of-run summary.
- The script does **not** change the working directory, which preserves image paths.
- You can extend the tool by adding new commands in the `process_file()` method.
