---
name: ai-dlc-construction
description: AI-DLC Construction phase — implements the approved plan in .aidlc/<intent>/tasks.md Unit by Unit ("mob construction"): per-Unit functional/NFR/infrastructure design, code generation with tests, build-and-test, CI. Verified by the human-approved verification command; failures always halt. Normally invoked by the ai-dlc orchestrator; also use directly via /ai-dlc-construction to build, resume, retry or redo a Unit of an existing intent.
argument-hint: "[intent=.aidlc/<id>] [unit=UNIT-n] [stages=3.5,3.6]"
---

# AI-DLC · Construction

Purpose: turn the approved `requirements.md` + `design.md` + `tasks.md` into working, tested software, one Unit of work at a time. Shared protocols are in `${CLAUDE_SKILL_DIR}/../ai-dlc/references/` (`protocols.md`, `templates.md`, `personas.md`); the stage catalogue is `references/stages.md` here.

## Entry checks (refuse to start if any fails — report which)

0. **Language** — apply the chat/files language from `state.md`/`.aidlc/config.md`. If none is set and this is the first AI-DLC skill of the session (direct invocation), ask first per `protocols.md` §Language.
1. Intent folder resolved (`intent=` or the single open `.aidlc/*/state.md`); none → tell the user to run `/ai-dlc`.
2. Inception stages in the route are `[x]`/`[S]`; `tasks.md` has Units in DAG order with tasks; `design.md § 2.7` exists. Otherwise offer `/ai-dlc-inception`.
3. **Verification command** present in `tasks.md`/`state.md` and approved by the human. `deferred` → ask now (propose from the repo scan: test/build/lint); the human's explicit approval of that question is what sets it. Never invent or silently change it; a change needs a new approval.
4. Working tree check: note uncommitted changes (`git status`); don't start on top of unrelated modifications without telling the user. Do not commit unless asked.

## Order of work

- **Unit-major, serial (default):** for each Unit in DAG order run the Unit's applicable design stages (3.1–3.4 per the route) then 3.5 Code Generation, verify, checkpoint; next Unit. Then 3.6 Build & Test and 3.7 CI **once** for the whole solution.
- **Walking skeleton (default on for new multi-Unit source work):** the first Unit is the smallest end-to-end slice. Build it, run the *real* verification command, and get explicit human approval of the verified skeleton before any later Unit.
- **Stage-major / swarm:** only on explicit user request (see `protocols.md` §Parallelism).

## Per-Unit procedure

1. **Design stages (3.1–3.4)** as the route includes: append `### UNIT-n — <Functional design | NFR requirements | NFR design | Infrastructure design>` to `design.md § 3.x`. Same stage loop as Inception: ask (interactively, AskUserQuestion with options + Other) → write → self-check → gate. Tables need a blank line before the header row (`protocols.md` §Markdown tables). Include Mermaid diagrams in the Unit design: `sequenceDiagram` for flows, `erDiagram`/`classDiagram` for entities, `stateDiagram-v2` for lifecycles, `flowchart` for rules and infra topology (`protocols.md` §Diagrams). At Minimal depth fold them into a short per-Unit design note, still gated.
2. **Code plan (3.5a)** — list files to create/modify, tests to add, task IDs covered, and anything outside the Unit's scope you would need. Get **Plan Approval** (unless `plan_approval=off`). Cross-Unit changes → ask, don't just do.
3. **Implement (3.5b)** — task by task from `tasks.md`: tests with the code, repo conventions from `design.md § 2.2` and existing patterns, small diffs, no unrelated edits. Tick `- [x] T-n.m` as each task is truly done; add `files:` actually touched.
4. **Verify (3.5c)** — run the approved verification command. Show the command, exit code and relevant output. Green → write the Unit summary in `tasks.md` (files changed, how to run, result with date, deviations) and set the Unit `verified` in `tasks.md` and `state.md`. Red → **Failure protocol**.
5. **Checkpoint** — ask **Approve / Request changes** for the verified Unit (skipped automatically only under an explicit "Continue automatically" grant). Log `UNIT_VERIFIED`.

After the first verified Unit, offer once: **Review each checkpoint** (default) / **Continue automatically**. Automatic mode waives only ordinary Unit checkpoints — never plan approval, verification-command approval, skeleton approval, or failures.

## Failure protocol (always halts — even in automatic mode)

Show real failing output → diagnose → bounded fixes (≤3 attempts, only within the Unit) → still red: ask **retry / skip (mark `[S]`, warn dependents) / abort**. If the root cause is an upstream artifact (wrong requirement or design), loop back: reopen that Inception/Construction section for the affected Unit(s), keep files, re-gate. Never report green without a passing run; never weaken or delete tests to pass.

## 3.6 Build and Test and 3.7 CI (once, after all Units)

Run the full command(s); write `construction/build-and-test.md` (results, coverage vs the test strategy, requirement→test matrix, security notes, failures) and, if in route, create CI config in the repo plus `construction/ci-pipeline.md` (gates, caching, triggers). Test strategy: Minimal = approved command passes + regression for the change; Standard = unit + integration at Unit boundaries + story acceptance checks; Comprehensive = + NFR validation and failure/negative cases.

## Memory

When the user corrects the same kind of thing twice, says "always/never…", or a Request-changes reveals a general preference, propose a memory entry right then (`protocols.md` §Memory). At phase exit ask the retrospective question.

## Exit

All Construction stages `[x]`/`[S]` and every Unit `verified` or `[S]` with reason → return to the orchestrator (verification gate `phase-check-construction.md`: unit → code → tests → results, NFR coverage; written by you if invoked directly). Report a short summary: Units verified, tasks done/total, deviations, open risks. Hand off to Operations only if the route has it; **no deploy or environment change happens in this phase.**
