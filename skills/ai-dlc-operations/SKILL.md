---
name: ai-dlc-operations
description: AI-DLC Operations phase — deployment pipeline, environment provisioning, deployment execution, observability, incident response, performance validation, and the feedback loop that seeds the next cycle. Produces plans, IaC, runbooks and reports under .aidlc/<intent>/operations/; executing anything against real environments needs fresh explicit approval. Normally invoked by the ai-dlc orchestrator; also use directly via /ai-dlc-operations on an existing intent after Construction.
argument-hint: "[intent=.aidlc/<id>] [stages=4.1,4.3]"
---

# AI-DLC · Operations

Purpose: take verified construction output to production safely and close the loop with operational feedback. AI applies accumulated context (requirements, NFRs, design, infra design, build results) to infrastructure-as-code, deployment and operations — with humans overseeing infrastructure changes, permissions and rollback. Shared protocols: `${CLAUDE_SKILL_DIR}/../ai-dlc/references/` (`protocols.md`, `templates.md`, `personas.md`). Stage catalogue: `references/stages.md`.

## Entry checks

0. **Language** — apply the chat/files language from `state.md`/`.aidlc/config.md`. If none is set and this is the first AI-DLC skill of the session (direct invocation), ask first per `protocols.md` §Language.
1. Intent resolved; route contains 4.x stages (profiles `mvp`, `poc`, `classic` have none → say so and stop).
2. Construction is complete: Units `verified`, `construction/build-and-test.md` exists and passes (or the user explicitly accepts the recorded gaps — log it).
3. Read `requirements.md` NFRs, `design.md § 3.2–3.4` (NFR/infra design), and the CI config; list the target environments and cloud/tooling from the repo and answers — never assume AWS.

## Stage loop

Same loop as the other phases (plan → ask → write → self-check → gate → record; see `protocols.md`), writing files into `.aidlc/<id>/operations/` and IaC/pipeline config into the repo. Questions go through AskUserQuestion with options + Other (`protocols.md` §Asking the user). Use Mermaid diagrams for pipelines and promotion/rollback paths (`flowchart LR`), environment/network topology (`flowchart` with subgraphs), and escalation flows. Depth Minimal: one short page per stage.

## Safety model — the key difference of this phase

Separate **authoring** from **acting**:

| Authoring (allowed after normal gate) | Acting (needs a fresh, explicit yes at that moment) |
|---|---|
| Write pipeline definitions, IaC, dashboards-as-code, alarm definitions, runbooks, load-test scripts; `terraform plan`/`cdk diff`/`--dry-run`/lint/validate | `apply`/`deploy`/`push`/`publish`, creating or changing cloud resources, IAM changes, DNS/traffic shifts, database migrations on shared data, load tests against shared or production systems, paging/alerting real people |

Before any acting step state: the exact command, target environment/account/region, version/commit, expected changes (show the plan/diff), blast radius, and rollback. Approval for one action does not cover the next. Production targets additionally require the rollback runbook (4.1) to exist first. Never run destructive operations (destroy, force-push, drop) without the user naming them. Use the user's existing credentials/profile; never write secrets into files; if access fails, stop and report.

## Failure handling

Failed deploy/smoke/health check → stop, show real output, run the rollback runbook only with approval (unless the user pre-authorized auto-rollback in 4.1 — log it), then diagnose. Log `FAILURE_HALT` with the evidence.

## 4.7 and the feedback loop

4.7 turns evidence (SLO report, cost, incidents, user feedback, performance results) into `operations/feedback.md` with prioritized findings. At its gate offer: **Approve (complete)** or **Start new cycle** — if the latter, draft a candidate intent from the findings and hand it to `/ai-dlc` (new `.aidlc/<id>/`), citing this intent's folder as origin.

## Memory

4.7 (and any incident) is the main source of team/org-level lessons: propose entries per `protocols.md` §Memory (cost, SLO, deployment and security learnings) and ask the phase retrospective question.

## Exit

All 4.x stages `[x]`/`[S]` → return to the orchestrator, which finalizes `state.md` (`COMPLETE`). Directly invoked: update `state.md` yourself and summarize what was authored vs what was actually executed, with evidence.
