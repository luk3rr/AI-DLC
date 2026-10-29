# Code knowledge base — file templates

All files: first line `# <Title> — <repo>`, then `Status: draft | human-reviewed (YYYY-MM-DD) · Confidence: high|medium|low`. Tags: `[src: path:line]` · `[user]` · `[inferred]`. Diagrams in Mermaid. Keep each file focused; link rather than duplicate.

## README.md (index + metadata)

```markdown
# Code KB — <repo>
- Repo path: <path>   Remote: <url or none>
- Analysed commit: <sha> (<date>)   Branch: <name>
- Depth: Minimal | Standard | Comprehensive   Scope: <dirs included / excluded>
- Last full pass: <date>   Last review with user: <date | never>
| File | Status | Confidence | Notes |
|---|---|---|---|
| overview.md | human-reviewed | high | |
```

## overview.md
Business purpose · users/personas · key capabilities · domain glossary (term → meaning → where in code) · system context diagram (`flowchart`: users, this system, external systems) · maturity/lifecycle (greenfield-ish, legacy, being migrated) · owners/contacts if the user shares them.

## architecture.md
Style (monolith, modular monolith, services, serverless…) · component diagram (`flowchart` with subgraphs per layer/service) · layer rules and dependency direction · cross-cutting concerns (auth, logging, error handling, config, i18n) · notable decisions and their reasons (`[user]` where known; otherwise "reason unknown" — never invent).

## code-structure.md
Directory map (annotated tree, depth ≤3) · entry points · module/package responsibilities · generated/vendored dirs to avoid · where to add a new feature of each kind (route, job, model, test).

## technology-stack.md
Languages + versions · frameworks · key libraries and what they're used for · build tool, package manager · runtime/infra services · notable dependencies (outdated, vulnerable, deprecated) with `[src: lockfile]`.

## data-model.md
Stores (DBs, caches, queues, buckets) · entities and relations (`erDiagram`) · migrations approach · ownership (shared tables with other systems) · retention/PII notes.

## api.md
External/internal interfaces: routes/endpoints/RPC/events (table: method, path/topic, handler `[src]`, auth, purpose) · schemas location · versioning · error model · consumed third-party APIs.

## interactions.md
3–6 key flows as `sequenceDiagram` (e.g. login, main write path, background job, external integration) with file refs per hop; failure/retry behaviour where known.

## conventions.md
Code style and lint config · naming · error handling patterns · testing approach (framework, layout, mocks, fixtures, coverage expectations) · branching/commit/PR/review rules · definition of done · "how we really do it" items stated by the user `[user]`. → candidates for `.aidlc/memory/`.

## operations.md
Commands: install, run, test (unit/integration/e2e), lint, type-check, build — each with the exact command and where it comes from `[src]` · environments and config/secrets *locations* (never values) · CI/CD (`flowchart LR` of the pipeline) · deploy/release process · observability (logs, metrics, alerts) · the **proposed verification command** for AI-DLC with rationale.

## quality-and-risks.md
Baseline: result of the existing test run (command, date, pass/fail counts, known failures — only if the user allowed running) · tech debt and hot spots (most-changed or most-complex files) · fragile/sensitive areas · dead or legacy code · security observations · gotchas ("don't touch X because Y" `[user]`) · **Open questions** (unresolved from the walkthrough).

## areas/<name>.md (optional deep dives)
Purpose · key files · flow diagram · invariants/rules · how to change it safely · tests.
