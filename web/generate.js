/**
 * kanam-skills static site generator.
 *
 * Reads ../skills/<skill>/SKILL.md, extracts frontmatter (name, description) and
 * generates a catalog page (index.html) plus one page per skill.
 *
 * No framework, no dependencies - plain Node. Output goes to web/public.
 */

const fs = require("fs");
const path = require("path");

const SKILLS_DIR = path.join(__dirname, "..", "skills");
const OUT_DIR = path.join(__dirname, "public");
const SRC_DIR = path.join(__dirname, "src");

const CATEGORIES = [
  { id: "engineering", label: "Engineering - SDLC", match: [
      "interview-me","idea-refine","spec-driven-development",
      "planning-and-task-breakdown","incremental-implementation",
      "test-driven-development","context-engineering","source-driven-development",
      "doubt-driven-development","frontend-ui-engineering","api-and-interface-design",
      "browser-testing-with-devtools","debugging-and-error-recovery",
      "code-review-and-quality","code-simplification","security-and-hardening",
      "performance-optimization","git-workflow-and-versioning","ci-cd-and-automation",
      "deprecation-and-migration","documentation-and-adrs",
      "observability-and-instrumentation","shipping-and-launch",
      "using-agent-skills","openspec",
  ]},
  { id: "openclaw", label: "OpenClaw infrastructure", match: [
      "session-lifecycle","knowledge-management","memory-agent",
      "background-execution","engineering-governance","git-changelog",
      "mcp-orchestrator",
  ]},
  { id: "stack", label: "Stack & tools", match: [
      "supabase-assistant","sql-insight","db-readonly","deepwiki",
  ]},
  { id: "specialized", label: "Specialized dev", match: [
      "i18n-expert","shortcuts-generator","support-response-writer",
      "tech-docs","github",
  ]},
  { id: "security", label: "Security & network", match: [
      "clawdstrike","network-scanner",
  ]},
  { id: "career", label: "Career & growth", match: [
      "mock-interview-drill","cv-tailor",
  ]},
  { id: "creative", label: "Content & creativity", match: [
      "copy-editing","narrative-content","brand-name-forge",
      "content-serializer","deslop","image-generation","curriculum-builder",
  ]},
  { id: "life", label: "Daily life & tools", match: [
      "adhd-assistant","adhd-daily-planner","apple-photos",
      "calorie-counter","mlx-stt","checkmate","godot-mcp",
  ]},
];

function readFrontmatter(skillDir) {
  const sk = path.join(skillDir, "SKILL.md");
  if (!fs.existsSync(sk)) return null;
  const raw = fs.readFileSync(sk, "utf8");
  const m = raw.match(/^---\n([\s\S]*?)\n---\n?/);
  if (!m) return { name: path.basename(skillDir), description: "" };
  const fm = {};
  for (const line of m[1].split("\n")) {
    const kv = line.match(/^([a-zA-Z_]+):\s*(.*)$/);
    if (kv) fm[kv[1]] = kv[2].replace(/^"|"$/g, "");
  }
  return {
    name: fm.name || path.basename(skillDir),
    description: fm.description || "",
  };
}

function esc(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function readSkills() {
  const skills = [];
  for (const entry of fs.readdirSync(SKILLS_DIR, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const dir = path.join(SKILLS_DIR, entry.name);
    if (!fs.existsSync(path.join(dir, "SKILL.md"))) continue;
    const fm = readFrontmatter(dir);
    if (!fm) continue;
    const category = CATEGORIES.find((c) => c.match.includes(fm.name))?.id || "other";
    skills.push({ ...fm, dir: entry.name, category });
  }
  skills.sort((a, b) => a.name.localeCompare(b.name));
  return skills;
}

function layout(body, title) {
  const css = fs.readFileSync(path.join(SRC_DIR, "style.css"), "utf8");
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<style>${css}</style>
</head>
<body>
${body}
</body>
</html>`;
}

function skillCard(s) {
  return `<a class="card" href="skills/${s.dir}.html">
  <h3>${esc(s.name)}</h3>
  <p>${esc(s.description.split(". ")[0])}.</p>
</a>`;
}

function buildIndex(skills) {
  const grouped = CATEGORIES.map((cat) => ({
    ...cat,
    items: skills.filter((s) => s.category === cat.id),
  })).filter((g) => g.items.length > 0);

  const sections = grouped.map((g) => `
  <section>
    <h2>${esc(g.label)} <span class="count">${g.items.length}</span></h2>
    <div class="grid">${g.items.map(skillCard).join("\n")}</div>
  </section>`).join("\n");

  const hero = `
  <header>
    <h1>kanam-skills</h1>
    <p class="tagline">Agent skills for the whole job - and the rest of your life.</p>
    <pre class="install">npx skills add gonzoblasco/kanam-skills</pre>
    <p class="sub">Engineering workflows, personal productivity, creative writing, and life admin - ${skills.length} skills in the open Agent Skills format.</p>
  </header>`;

  return layout(`${hero}<main>${sections}</main><footer>MIT licensed - <a href="https://github.com/gonzoblasco/kanam-skills">github.com/gonzoblasco/kanam-skills</a></footer>`, "kanam-skills - Agent skills");
}

function buildSkillPage(s, skills) {
  const sk = path.join(SKILLS_DIR, s.dir, "SKILL.md");
  const raw = fs.readFileSync(sk, "utf8");
  // strip frontmatter
  const body = raw.replace(/^---\n[\s\S]*?\n---\n?/, "");

  const related = skills
    .filter((x) => x.category === s.category && x.name !== s.name)
    .slice(0, 4)
    .map((x) => `<a class="chip" href="${x.dir}.html">${esc(x.name)}</a>`)
    .join("");

  const html = `
  <header>
    <a class="back" href="../index.html">&larr; catalog</a>
    <h1>${esc(s.name)}</h1>
    <p class="tagline">${esc(s.description)}</p>
  </header>
  <main class="skill">
    <article><pre class="skill-body">${esc(body)}</pre></article>
    ${related ? `<section><h3>Related</h3><div class="chips">${related}</div></section>` : ""}
  </main>
  <footer>MIT licensed - kanam-skills</footer>`;

  return layout(html, `${s.name} - kanam-skills`);
}

function main() {
  const skills = readSkills();
  fs.mkdirSync(path.join(OUT_DIR, "skills"), { recursive: true });

  fs.writeFileSync(path.join(OUT_DIR, "index.html"), buildIndex(skills));
  for (const s of skills) {
    fs.writeFileSync(path.join(OUT_DIR, "skills", `${s.dir}.html`), buildSkillPage(s, skills));
  }

  console.log(`Generated ${skills.length} skill pages + index.html`);
}

main();
