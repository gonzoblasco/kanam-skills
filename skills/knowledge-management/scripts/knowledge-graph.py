#!/usr/bin/env python3
"""knowledge-graph.py — Generate knowledge graph from project documents.

Usage:
  python3 knowledge-graph.py [--output <file>]

Scans project documents and generates a knowledge graph showing
relationships between documents, decisions, and changes.
"""

import sys
import re
from pathlib import Path
from datetime import datetime


def scan_documents(project_dir: str) -> dict:
    """Scan project documents and extract relationships."""
    docs = {}
    project_path = Path(project_dir)

    # Known document types
    doc_types = {
        "BRIEF.md": "vision",
        "STATUS.md": "state",
        "HANDOFF.md": "session",
        "CHANGELOG.md": "changes",
        "ROADMAP.md": "planning",
        "TRACKER.md": "tasks",
        "ARCHITECTURE.md": "architecture",
    }

    for doc_name, doc_type in doc_types.items():
        doc_path = project_path / doc_name
        if doc_path.exists():
            content = doc_path.read_text()
            docs[doc_name] = {
                "type": doc_type,
                "exists": True,
                "size": len(content),
                "modified": datetime.fromtimestamp(doc_path.stat().st_mtime).isoformat(),
                "refs": extract_references(content),
            }

    # ADRs
    adr_dir = project_path / "docs" / "adr"
    if adr_dir.exists():
        for adr_file in sorted(adr_dir.glob("*.md")):
            content = adr_file.read_text()
            docs[adr_file.name] = {
                "type": "adr",
                "exists": True,
                "size": len(content),
                "modified": datetime.fromtimestamp(adr_file.stat().st_mtime).isoformat(),
                "refs": extract_references(content),
            }

    return docs


def extract_references(content: str) -> list[str]:
    """Extract markdown links and references from content."""
    refs = []
    # Local file links
    refs.extend(re.findall(r"\(\.\./([^)]+)\)", content))
    # GitHub issue/PR references
    refs.extend(re.findall(r"#(\d+)", content))
    # ADR references
    refs.extend(re.findall(r"ADR-\d+", content))
    return refs


def generate_graph(docs: dict) -> str:
    """Generate knowledge graph in Mermaid format."""
    graph = ["```mermaid", "graph LR"]

    for doc_name, info in docs.items():
        # Node
        safe_name = doc_name.replace(".", "_").replace("-", "_")
        graph.append(f"    {safe_name}[\"{doc_name}\"]")

        # Connections
        for ref in info["refs"]:
            ref_safe = ref.replace(".", "_").replace("-", "_").replace("/", "_")
            graph.append(f"    {safe_name} --> {ref_safe}")

    graph.append("```")
    return "\n".join(graph)


def main():
    project_dir = "."
    output_file = "KNOWLEDGE_GRAPH.md"

    args = sys.argv[1:]
    while args:
        if args[0] == "--output" and len(args) > 1:
            output_file = args[1]
            args = args[2:]
        else:
            args = args[1:]

    docs = scan_documents(project_dir)

    if not docs:
        print("⚠️  No project documents found")
        return

    graph = generate_graph(docs)

    report = f"""# Knowledge Graph

**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M')}
**Documents found:** {len(docs)}

## Document Map

| Document | Type | Size | References |
|----------|------|------|------------|
"""

    for doc_name, info in sorted(docs.items()):
        refs = ", ".join(info["refs"][:5]) if info["refs"] else "—"
        report += f"| {doc_name} | {info['type']} | {info['size']}B | {refs} |\n"

    report += f"\n## Graph\n\n{graph}\n"

    Path(output_file).write_text(report)
    print(f"✅ Knowledge graph generated: {output_file}")


if __name__ == "__main__":
    main()
