---
name: ai-dlc-inception
description: AI-DLC Inception phase (includes Ideation) — turns a business intent into approved requirements, design and a task plan via "mob elaboration": the AI drafts and asks, the human validates. Writes .aidlc/<intent>/requirements.md, design.md and tasks.md. Normally invoked by the ai-dlc orchestrator; also use directly via /ai-dlc-inception to run or redo Inception stages (intent capture, feasibility, scope, reverse engineering, requirements, user stories, domain design, units of work, contracts, delivery planning) on an existing intent.
argument-hint: "[intent=.aidlc/<id>] [stages=1.1,2.3,…]"
---

# AI-DLC · Inception

Purpose: turn business **intent** into requirements, design, units of work and an executable task plan that Construction can implement without guessing. Output lands in the three plan files of the intent folder `.aidlc/<YYMMDD>-<label>/`:

- `requirements.md` — what & why
- `design.md` — how (components, ADRs, Units, contracts)
- `tasks.md` — verification command, bolts, ordered tasks

Shared protocols live in the orchestrator skill: `${CLAUDE_SKILL_DIR}/../ai-dlc/references/` — read `protocols.md` (questions, gates, reviewers, brownfield) and `templates.md` (file skeletons, which stage writes where) before the first stage, and `personas.md` when adopting a persona. Stage catalogue: `references/stages.md` (this skill).

## Entry

0. **Language** — apply the chat/files language from `state.md`/`.aidlc/config.md`. If none is set and this is the first AI-DLC skill of the session (direct invocation), ask first per `protocols.md` §Language.
1. Resolve the intent folder from `$ARGUMENTS` (`intent=`), else the single open `.aidlc/*/state.md` with unfinished Inception stages. None → tell the user to run `/ai-dlc <request>` (it creates the intent, profile and route) and stop.
2. Read `state.md` (route, depth, switches, brownfield flag) and the existing plan files. Stages to run: `stages=` argument, else all pending Inception/Ideation stages in the route, in numeric order.
3. Load team knowledge if present: `CLAUDE.md`, `docs/`, ADRs, `.aidlc/memory/*.md`, `.aidlc/codekb/`.

## Stage loop (per stage)

1. **Plan** — read the stage in `references/stages.md`; note what it consumes (earlier sections of the three files). Missing input: producer stage outside the route → proceed from what exists and say so; skipped/unfinished producer → raise as a gap.
2. **Ask** — interactively, per `protocols.md` §Asking the user: AskUserQuestion with 2–4 options (recommended first; the tool adds a free-text "Other"), options derived from the request/repo/memory rather than generic ones. Intent capture (1.1) especially: propose candidate readings of the request and goals as options. Use the questions file only for large questionnaires (>8). Do not draft past unanswered questions; unavoidable gaps become `ASSUMPTION` lines. Depth caps the number of questions (Minimal ≤5).
3. **Write** the stage's section into the target file (`## <N.N> <Stage name>`), with source tags (`[src: Q3]`, `[src: path]`, `[src: FR-2]`, `[mem: M-n]`) and stable IDs. Add **Mermaid diagrams** (`protocols.md` §Diagrams) wherever they clarify (tables follow `protocols.md` §Markdown tables — blank line before the header row): system context/components (2.6), user flows and screens (1.6, 2.5), Unit dependency DAG (2.7), interaction sequences and contracts (2.8), entity relations, task/bolt sequencing (2.9).
4. **Self-check** — the stage checklist plus the traceability rules below; reviewer subagent for complex stages (Standard+; always at Comprehensive), max 2 repair iterations.
5. **Gate** — ≤10-line summary and AskUserQuestion **Approve / Request changes / Pause**. Only the human's actual reply counts.
6. **Record** — tick the stage in `state.md`, append audit events, then continue. On *Request changes*: revise the section, log it, ask again.

## Traceability rules (checked at the Inception→Construction verification gate)

- Every FR/NFR is testable and has a unique ID; no solution-speak in requirements.
- Every FR is covered by ≥1 story (when stories are in the route) and every story links to ≥1 FR.
- Every story/FR is owned by exactly one Unit; the Unit DAG is acyclic.
- Every Unit has ≥1 task in `tasks.md`; every task names the FR/US it serves and its test.
- Every NFR appears in a Unit's Definition of Done or a Construction NFR stage.

## Brownfield

Run 2.1 Reverse Engineering first by invoking `Skill(ai-dlc-codekb, "init repo=<path>")` (or `update` if a kb exists but is stale; skip if current for `git HEAD`). It scans read-only and **walks the user through each area to confirm and enrich it**; then you write the `design.md § 2.1` summary (with an architecture diagram) and run the stage gate. Record the baseline: run the existing test command once and note pre-existing failures. Prefer extending existing patterns; record deviations as ADRs.

## 2.9 Delivery planning — handoff contract to Construction

`tasks.md` must contain, before Inception can close: (1) the **verification command** proposed from the repo scan and explicitly approved by the human (or `deferred` + reason), recorded also in `state.md`; (2) Units in dependency order with checkbox tasks; (3) bolts with Definition of Done; (4) the walking-skeleton choice (first Unit = smallest end-to-end slice, default on for new multi-Unit source work).

## Exit

All Inception stages `[x]`/`[S]` → return control to the orchestrator (it runs the verification gate and hands off to Construction). If invoked directly, write `verification/phase-check-inception.md` yourself per `protocols.md` §Verification gate, then tell the user to continue with `/ai-dlc` or `/ai-dlc-construction`. Before exiting, run the phase retrospective question ("anything from Inception worth remembering?") and propose memory entries per `protocols.md` §Memory — practices affirmed in 2.2 are promoted there. Nothing in Inception writes application code or runs deployments.
