/**
 * kanam-skills static site generator.
 *
 * Reads ../skills/<skill>/SKILL.md, extracts frontmatter (name, description,
 * tags) and generates a catalog page (index.html) plus one rendered page per
 * skill. Markdown is converted to semantic HTML with a small dependency-free
 * renderer (fences, headings, lists, tables, blockquotes, inline styles).
 *
 * No framework, no dependencies - plain Node. Output goes to web/public.
 */

const fs = require("fs");
const path = require("path");

const SKILLS_DIR = path.join(__dirname, "..", "skills");
const OUT_DIR = path.join(__dirname, "public");
const SRC_DIR = path.join(__dirname, "src");

const CATEGORIES = [
  { id: "engineering", label: "Ingeniería - ciclo SDLC", match: [
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
  { id: "openclaw", label: "Infraestructura OpenClaw", match: [
      "session-lifecycle","knowledge-management","memory-agent",
      "background-execution","engineering-governance","git-changelog",
      "mcp-orchestrator",
  ]},
  { id: "stack", label: "Stack y herramientas", match: [
      "supabase-assistant","sql-insight","db-readonly","deepwiki",
  ]},
  { id: "specialized", label: "Desarrollo especializado", match: [
      "i18n-expert","shortcuts-generator","support-response-writer",
      "tech-docs","github",
  ]},
  { id: "security", label: "Seguridad y red", match: [
      "clawdstrike","network-scanner",
  ]},
  { id: "career", label: "Carrera y crecimiento", match: [
      "mock-interview-drill","cv-tailor",
  ]},
  { id: "creative", label: "Contenido y creatividad", match: [
      "copy-editing","narrative-content","brand-name-forge",
      "content-serializer","deslop","image-generation","curriculum-builder",
  ]},
  { id: "life", label: "Vida diaria y herramientas", match: [
      "adhd-assistant","apple-photos",
      "calorie-counter","mlx-stt","checkmate","godot-mcp",
  ]},
];

function readFrontmatter(skillDir) {
  const sk = path.join(skillDir, "SKILL.md");
  if (!fs.existsSync(sk)) return null;
  const raw = fs.readFileSync(sk, "utf8");
  const m = raw.match(/^---\n([\s\S]*?)\n---\n?/);
  if (!m) return { name: path.basename(skillDir), description: "", tags: [] };
  const fm = {};
  for (const line of m[1].split("\n")) {
    const kv = line.match(/^([a-zA-Z_]+):\s*(.*)$/);
    if (kv) fm[kv[1]] = kv[2].replace(/^"|"$/g, "");
  }
  let tags = [];
  try { tags = JSON.parse(fm.tags || "[]"); } catch (e) { tags = []; }
  if (!Array.isArray(tags)) tags = [];
  return {
    name: fm.name || path.basename(skillDir),
    description: fm.description || "",
    tags,
  };
}

function esc(s) {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;").replace(/'/g, "&#39;");
}

function slugify(s) {
  return s.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "") || "sec";
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

/* ---------- Inline markdown ---------- */

function renderInline(text) {
  let out = esc(text);
  // code spans first
  out = out.replace(/`([^`]+)`/g, (_, c) => `<code>${c}</code>`);
  // bold
  out = out.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  // italic
  out = out.replace(/(^|[^*])\*([^*\n]+)\*(?!\*)/g, "$1<em>$2</em>");
  // links [text](url)
  out = out.replace(/\[([^\]]+)\]\(([^)]+)\)/g, (_, t, u) => {
    const href = u.startsWith("http") ? u : `#`;
    return `<a href="${href}" target="${u.startsWith("http") ? "_blank" : "_self"}" rel="noopener">${t}</a>`;
  });
  return out;
}

/* ---------- Block markdown ---------- */

function renderMarkdown(md) {
  const lines = md.split("\n");
  let html = "";
  let i = 0;

  while (i < lines.length) {
    const line = lines[i];

    // fenced code block
    if (/^```/.test(line)) {
      const lang = line.replace(/^```/, "").trim();
      let code = [];
      i++;
      while (i < lines.length && !/^```/.test(lines[i])) {
        code.push(lines[i]);
        i++;
      }
      i++; // skip closing fence
      html += `<div class="md-code"><div class="md-code-head">${lang ? esc(lang) : "code"}</div><pre><code>${esc(code.join("\n"))}</code></pre></div>`;
      continue;
    }

    // heading
    const h = line.match(/^(#{1,4})\s+(.*)$/);
    if (h) {
      const level = h[1].length;
      const text = h[2];
      const id = slugify(text);
      html += `<h${level} id="${id}">${renderInline(text)}</h${level}>`;
      i++;
      continue;
    }

    // horizontal rule
    if (/^---+$/.test(line.trim())) {
      html += "<hr>";
      i++;
      continue;
    }

    // table: detect header row + separator row
    if (i + 1 < lines.length && /\|/.test(line) && /^\s*\|?[\s:|-]+\|?\s*$/.test(lines[i + 1]) && lines[i + 1].includes("-")) {
      const header = line.split("|").map((c) => c.trim()).filter((c, idx, arr) => !(idx === 0 && c === "") && !(idx === arr.length - 1 && c === ""));
      i += 2;
      let rows = [];
      while (i < lines.length && /\|/.test(lines[i]) && lines[i].trim() !== "") {
        rows.push(lines[i].split("|").map((c) => c.trim()).filter((c, idx, arr) => !(idx === 0 && c === "") && !(idx === arr.length - 1 && c === "")));
        i++;
      }
      html += `<div class="md-table-wrap"><table><thead><tr>${header.map((c) => `<th>${renderInline(c)}</th>`).join("")}</tr></thead><tbody>${rows.map((r) => `<tr>${r.map((c) => `<td>${renderInline(c)}</td>`).join("")}</tr>`).join("")}</tbody></table></div>`;
      continue;
    }

    // blockquote
    if (/^>\s?/.test(line)) {
      let quote = [];
      while (i < lines.length && /^>\s?/.test(lines[i])) {
        quote.push(lines[i].replace(/^>\s?/, ""));
        i++;
      }
      html += `<blockquote>${renderInline(quote.join(" "))}</blockquote>`;
      continue;
    }

    // unordered list
    if (/^\s*[-*+]\s+/.test(line)) {
      let items = [];
      while (i < lines.length && /^\s*[-*+]\s+/.test(lines[i])) {
        items.push(lines[i].replace(/^\s*[-*+]\s+/, ""));
        i++;
      }
      // checkbox detection
      const hasCheckbox = items.some((it) => /^\[[ xX]\]/.test(it));
      if (hasCheckbox) {
        html += `<ul class="md-check">${items.map((it) => {
          const cb = it.match(/^\[([ xX])\]\s*(.*)$/);
          if (cb) {
            const checked = cb[1].toLowerCase() === "x";
            return `<li class="${checked ? "done" : ""}"><span class="box">${checked ? "✓" : ""}</span> ${renderInline(cb[2])}</li>`;
          }
          return `<li>${renderInline(it)}</li>`;
        }).join("")}</ul>`;
      } else {
        html += `<ul>${items.map((it) => `<li>${renderInline(it)}</li>`).join("")}</ul>`;
      }
      continue;
    }

    // ordered list
    if (/^\s*\d+[.)]\s+/.test(line)) {
      let items = [];
      while (i < lines.length && /^\s*\d+[.)]\s+/.test(lines[i])) {
        items.push(lines[i].replace(/^\s*\d+[.)]\s+/, ""));
        i++;
      }
      html += `<ol>${items.map((it) => `<li>${renderInline(it)}</li>`).join("")}</ol>`;
      continue;
    }

    // blank line
    if (line.trim() === "") {
      i++;
      continue;
    }

    // paragraph (collect until blank or block start)
    let para = [];
    while (i < lines.length && lines[i].trim() !== "" && !/^```/.test(lines[i]) && !/^#{1,4}\s/.test(lines[i]) && !/^\s*[-*+]\s+/.test(lines[i]) && !/^\s*\d+[.)]\s+/.test(lines[i]) && !/^>\s?/.test(lines[i])) {
      para.push(lines[i]);
      i++;
    }
    html += `<p>${renderInline(para.join(" "))}</p>`;
  }

  return html;
}

/* ---------- Layout ---------- */

function layout(body, title, extraCss) {
  const css = fs.readFileSync(path.join(SRC_DIR, "style.css"), "utf8");
  return `<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<meta name="description" content="${esc(title)}">
<style>${css}</style>
</head>
<body>
${body}
</body>
</html>`;
}

const CATEGORY_LABEL = Object.fromEntries(CATEGORIES.map((c) => [c.id, c.label]));

/* ---------- Index page ---------- */

function skillCard(s) {
  const cat = CATEGORY_LABEL[s.category] || "Otros";
  const tags = (s.tags || []).slice(0, 3);
  return `<a class="card" href="skills/${s.dir}.html" data-name="${esc(s.name)}" data-cat="${s.category}">
  <span class="card-cat">${esc(cat)}</span>
  <h3>${esc(s.name)}</h3>
  <p>${esc(s.description)}</p>
  ${tags.length ? `<div class="card-tags">${tags.map((t) => `<span>${esc(t)}</span>`).join("")}</div>` : ""}
</a>`;
}

function buildIndex(skills) {
  const grouped = CATEGORIES.map((cat) => ({
    ...cat,
    items: skills.filter((s) => s.category === cat.id),
  })).filter((g) => g.items.length > 0);

  const filters = CATEGORIES.filter((c) => skills.some((s) => s.category === c.id))
    .map((c) => `<button class="filter" data-filter="${c.id}">${esc(c.label)}</button>`).join("");

  const sections = grouped.map((g) => `
  <section data-section="${g.id}">
    <h2>${esc(g.label)} <span class="count">${g.items.length}</span></h2>
    <div class="grid">${g.items.map(skillCard).join("\n")}</div>
  </section>`).join("\n");

  const hero = `
  <header class="hero">
    <h1>kanam-skills</h1>
    <p class="tagline">Skills de agente para todo el trabajo - y el resto de tu vida.</p>
    <pre class="install">npx skills add gonzoblasco/kanam-skills</pre>
    <p class="sub">Workflows de ingeniería, productividad personal, escritura creativa y gestión de vida - ${skills.length} skills en el formato abierto Agent Skills.</p>
  </header>
  <div class="toolbar">
    <input id="search" type="search" placeholder="Buscar skill..." autocomplete="off">
    <div class="filters">${filters}</div>
  </div>`;

  const script = `
<script>
(function () {
  var search = document.getElementById("search");
  var filters = document.querySelectorAll(".filter");
  var cards = document.querySelectorAll(".card");
  var sections = document.querySelectorAll("[data-section]");
  var activeFilter = "all";

  function apply() {
    var q = (search.value || "").toLowerCase().trim();
    var visible = {};
    cards.forEach(function (card) {
      var name = card.getAttribute("data-name").toLowerCase();
      var cat = card.getAttribute("data-cat");
      var matchesQ = !q || name.indexOf(q) !== -1;
      var matchesF = activeFilter === "all" || cat === activeFilter;
      var show = matchesQ && matchesF;
      card.style.display = show ? "" : "none";
      if (show) visible[cat] = true;
    });
    sections.forEach(function (sec) {
      var id = sec.getAttribute("data-section");
      var any = visible[id];
      sec.style.display = (activeFilter === "all" || any) ? "" : "none";
    });
  }

  search.addEventListener("input", apply);
  filters.forEach(function (btn) {
    btn.addEventListener("click", function () {
      filters.forEach(function (b) { b.classList.remove("active"); });
      btn.classList.add("active");
      activeFilter = btn.getAttribute("data-filter");
      apply();
    });
  });
})();
</script>`;

  return layout(`${hero}<main>${sections}</main><footer>Licencia MIT - <a href="https://github.com/gonzoblasco/kanam-skills">github.com/gonzoblasco/kanam-skills</a></footer>${script}`, "kanam-skills - Skills de agente");
}

/* ---------- Skill page ---------- */

function buildToc(html) {
  const heads = [...html.matchAll(/<h([23]) id="([^"]+)">([\s\S]*?)<\/h\1>/g)].slice(0, 12);
  if (heads.length < 2) return "";
  return `<nav class="toc"><h4>Contenido</h4><ul>${heads.map((h) => `<li class="h${h[1]}"><a href="#${h[2]}">${h[3].replace(/<[^>]+>/g, "")}</a></li>`).join("")}</ul></nav>`;
}

function buildSkillPage(s, skills) {
  const sk = path.join(SKILLS_DIR, s.dir, "SKILL.md");
  const raw = fs.readFileSync(sk, "utf8");
  const body = raw.replace(/^---\n[\s\S]*?\n---\n?/, "");
  const rendered = renderMarkdown(body);
  const toc = buildToc(rendered);
  const cat = CATEGORY_LABEL[s.category] || "Otros";
  const tags = s.tags || [];

  const related = skills
    .filter((x) => x.category === s.category && x.name !== s.name)
    .slice(0, 4)
    .map((x) => `<a class="chip" href="${x.dir}.html">${esc(x.name)}</a>`)
    .join("");

  const html = `
  <header class="skill-hero">
    <a class="back" href="../index.html">&larr; catálogo</a>
    <div class="skill-meta">
      <span class="cat-badge">${esc(cat)}</span>
      ${tags.map((t) => `<span class="tag">${esc(t)}</span>`).join("")}
    </div>
    <h1>${esc(s.name)}</h1>
    <p class="tagline">${esc(s.description)}</p>
  </header>
  <div class="skill-layout">
    ${toc ? `<aside class="toc-wrap">${toc}</aside>` : ""}
    <main class="skill">
      <article class="md-body">${rendered}</article>
      ${related ? `<section class="related"><h3>Relacionadas</h3><div class="chips">${related}</div></section>` : ""}
    </main>
  </div>
  <footer>Licencia MIT - kanam-skills</footer>`;

  return layout(html, `${s.name} - kanam-skills`);
}

/* ---------- Main ---------- */

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
