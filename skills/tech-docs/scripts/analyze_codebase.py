#!/usr/bin/env python3
"""analyze_codebase.py - Analyze codebase and generate architecture diagrams.

Usage:
  python3 analyze_codebase.py /path/to/project
  python3 analyze_codebase.py /path/to/project --type architecture
  python3 analyze_codebase.py /path/to/project --format svg

Uses AST parsing to map import dependencies for Python, JS/TS, Go, and Java.
Outputs Mermaid (.mmd) files for architecture, flowchart, and org chart diagrams.
"""

import sys
import os
import re
import json
from pathlib import Path
from collections import defaultdict


# ─── Language Detectors ────────────────────────────────────────────

def detect_language(filepath: Path) -> str | None:
    ext = filepath.suffix.lower()
    mapping = {
        ".py": "python",
        ".js": "javascript",
        ".jsx": "javascript",
        ".ts": "typescript",
        ".tsx": "typescript",
        ".go": "go",
        ".java": "java",
    }
    return mapping.get(ext)


def parse_imports_python(content: str) -> list[str]:
    imports = []
    # import X
    for m in re.finditer(r"^import\s+(\w+)", content, re.MULTILINE):
        imports.append(m.group(1))
    # from X import Y
    for m in re.finditer(r"^from\s+(\w+(?:\.\w+)*)\s+import", content, re.MULTILINE):
        imports.append(m.group(1))
    return imports


def parse_imports_jsts(content: str) -> list[str]:
    imports = []
    # import X from '...'
    for m in re.finditer(r"import\s+(?:\w+\s*,\s*)?\{?[^}]*\}?\s+from\s+['\"]([^'\"]+)['\"]", content):
        imports.append(m.group(1))
    # require('...')
    for m in re.finditer(r"require\s*\(\s*['\"]([^'\"]+)['\"]", content):
        imports.append(m.group(1))
    return imports


def parse_imports_go(content: str) -> list[str]:
    imports = []
    for m in re.finditer(r'import\s+\(([^)]+)\)', content, re.DOTALL):
        block = m.group(1)
        for im in re.finditer(r'["]([^"]+)["]', block):
            imports.append(im.group(1))
    for m in re.finditer(r'import\s+["]([^"]+)["]', content):
        imports.append(m.group(1))
    return imports


def parse_imports_java(content: str) -> list[str]:
    imports = []
    for m in re.finditer(r"^import\s+([\w.]+)", content, re.MULTILINE):
        imports.append(m.group(1))
    return imports


PARSERS = {
    "python": parse_imports_python,
    "javascript": parse_imports_jsts,
    "typescript": parse_imports_jsts,
    "go": parse_imports_go,
    "java": parse_imports_java,
}


# ─── Scanning ───────────────────────────────────────────────────────

IGNORE_DIRS = {"node_modules", ".git", "__pycache__", "venv", ".venv", "dist", "build", ".next", "target"}


def scan_project(project_dir: str, max_files: int = 500, max_depth: int = 4) -> dict:
    """Scan project and extract file structure and dependencies."""
    project_path = Path(project_dir)
    files = []
    dependencies = defaultdict(list)
    dir_structure = defaultdict(list)

    for root, dirs, filenames in os.walk(project_path):
        # Skip ignored dirs
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS and not d.startswith(".")]

        if len(files) >= max_files:
            break

        rel_root = Path(root).relative_to(project_path)
        depth = len(rel_root.parts)

        for filename in filenames:
            filepath = Path(root) / filename
            lang = detect_language(filepath)

            if not lang:
                continue

            rel_path = filepath.relative_to(project_path)
            files.append(rel_path)

            # Track directory structure
            if depth <= max_depth:
                dir_structure[str(rel_root)].append(filename)

            # Parse imports
            try:
                content = filepath.read_text(encoding="utf-8", errors="ignore")
                parser = PARSERS.get(lang)
                if parser:
                    imports = parser(content)
                    for imp in imports:
                        dependencies[str(rel_path)].append(imp)
            except Exception:
                continue

    return {
        "files": files,
        "dependencies": dict(dependencies),
        "dir_structure": dict(dir_structure),
    }


# ─── Diagram Generation ─────────────────────────────────────────────

def generate_architecture_diagram(data: dict) -> str:
    """Generate module-level architecture diagram."""
    deps = data["dependencies"]
    modules = defaultdict(set)

    for filepath, imports in deps.items():
        module = Path(filepath).parts[0] if Path(filepath).parts else "root"
        for imp in imports:
            modules[module].add(imp.split(".")[0])

    lines = ["graph TD"]
    for module, imported in modules.items():
        safe_module = module.replace("-", "_").replace(".", "_")
        for imp in imported:
            safe_imp = imp.replace("-", "_").replace(".", "_")
            lines.append(f"    {safe_module}[{module}] --> {safe_imp}[{imp}]")

    return "\n".join(lines)


def generate_flowchart(data: dict) -> str:
    """Generate file-level import flowchart."""
    deps = data["dependencies"]
    lines = ["graph LR"]

    for filepath, imports in deps.items():
        safe_file = Path(filepath).stem.replace("-", "_").replace(".", "_")
        for imp in imports[:5]:  # Limit to 5 per file
            safe_imp = imp.replace("-", "_").replace(".", "_").replace("/", "_")
            lines.append(f"    {safe_file}[{Path(filepath).name}] --> {safe_imp}[{imp.split('/')[-1]}]")

    return "\n".join(lines)


def generate_org_chart(data: dict, max_depth: int = 4) -> str:
    """Generate directory/file hierarchy org chart."""
    lines = ["graph TD"]
    structure = data["dir_structure"]

    for dirpath, filenames in structure.items():
        depth = len(Path(dirpath).parts) if dirpath != "." else 0
        if depth > max_depth:
            continue

        safe_dir = dirpath.replace("/", "_").replace("-", "_").replace(".", "_") or "root"
        lines.append(f"    {safe_dir}[\"{dirpath if dirpath != '.' else '/'}\"]")

        for filename in filenames:
            safe_file = f"{safe_dir}_{Path(filename).stem}".replace("-", "_").replace(".", "_")
            lines.append(f"    {safe_file}[\"{filename}\"]")
            lines.append(f"    {safe_dir} --> {safe_file}")

    return "\n".join(lines)


# ─── Main ───────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    project_dir = sys.argv[1]
    diagram_type = "all"
    output_dir = "."
    output_format = "mermaid"
    max_files = 500
    max_depth = 4
    output_json = False

    args = sys.argv[2:]
    while args:
        if args[0] == "--type" and len(args) > 1:
            diagram_type = args[1]
            args = args[2:]
        elif args[0] == "--output" and len(args) > 1:
            output_dir = args[1]
            args = args[2:]
        elif args[0] == "--format" and len(args) > 1:
            output_format = args[1]
            args = args[2:]
        elif args[0] == "--max-files" and len(args) > 1:
            max_files = int(args[1])
            args = args[2:]
        elif args[0] == "--max-depth" and len(args) > 1:
            max_depth = int(args[1])
            args = args[2:]
        elif args[0] == "--json":
            output_json = True
            args = args[1:]
        else:
            args = args[1:]

    if not os.path.isdir(project_dir):
        print(f"❌ Directory not found: {project_dir}")
        sys.exit(1)

    print(f"🔍 Scanning: {project_dir}")
    data = scan_project(project_dir, max_files, max_depth)
    print(f"   Files found: {len(data['files'])}")

    if output_json:
        print(json.dumps(data, indent=2, default=str))
        return

    os.makedirs(output_dir, exist_ok=True)

    types_to_generate = ["architecture", "flowchart", "org"] if diagram_type == "all" else [diagram_type]

    for dtype in types_to_generate:
        if dtype == "architecture":
            content = generate_architecture_diagram(data)
        elif dtype == "flowchart":
            content = generate_flowchart(data)
        elif dtype == "org":
            content = generate_org_chart(data, max_depth)
        else:
            continue

        output_file = Path(output_dir) / f"{dtype}.mmd"
        output_file.write_text(content)
        print(f"   ✅ {dtype}.mmd generated")

    print(f"\n✅ Analysis complete. Diagrams in: {output_dir}")


if __name__ == "__main__":
    main()
