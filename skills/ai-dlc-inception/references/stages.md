# Inception stage catalogue (Ideation 1.x + Inception 2.x)

Format: **N.N Name** — lead persona (support) · condition · reads → writes `file § section`. Depth scaling: Minimal = a short paragraph/table per section; Standard = full; Comprehensive = alternatives, risks, compliance mapping, reviewer pass.

Every section ends with `### Assumptions & open questions`.

## Ideation (1.x) — validate the initiative

**1.1 Intent Capture & Framing** — product (architect) · when Ideation in route
- Reads: `requirements.md § Original request`. Writes: `requirements.md § 1.1 Intent & stakeholders`.
- Steps: restate the intent in business terms; ask problem, users, success measures, constraints, deadlines, non-goals; stakeholder map (decider / affected / consulted); list assumptions.
- Check: success criteria measurable; every stakeholder has a role.

**1.2 Market Research** — product · conditional (enterprise/feature; skip if internal/obvious)
- Writes `requirements.md § 1.2` — competitive analysis, build-vs-buy. WebSearch only with the human's OK; cite URLs.

**1.3 Feasibility & Constraints** — architect (aws-platform, compliance) · conditional
- Writes `requirements.md § 1.3` — feasibility assessment, constraint register (budget, tech, regulation), RAID log (Risks/Assumptions/Issues/Dependencies), go/no-go recommendation.

**1.4 Scope Definition** — product (delivery) · when Ideation in route
- Writes `requirements.md § 1.4` — in/out of scope, MVP boundary, prioritized intent backlog.

**1.5 Team Formation** — delivery · conditional
- Writes `requirements.md § 1.5` — team assessment, skill gaps, who joins Mob Elaboration / Mob Construction.

**1.6 Rough Mockups** — design (product) · conditional: UI present
- Writes `design.md § 1.6` — wireframes (ASCII/Mermaid), user flows.

**1.7 Approval & Handoff** — delivery (product) · when Ideation in route
- Writes `requirements.md § 1.7 Initiative brief` + decision log (also in `audit.md`). Then `verification/phase-check-ideation.md`.

## Inception (2.x) — mob elaboration

**2.1 Reverse Engineering** — delegated to the `ai-dlc-codekb` skill (collaborative with the user) · conditional: **brownfield only**
- Runs `ai-dlc-codekb` → `.aidlc/codekb/<repo>/` (overview, architecture, code-structure, technology-stack, data-model, api, interactions, conventions, operations, quality-and-risks; Minimal = code-structure, technology-stack, conventions). You then write the `design.md § 2.1` summary with a Mermaid architecture diagram pointing to it.
- The skill does the read-only scan, drafts per area, and asks the user to confirm/correct each area; reuse the kb when its recorded commit is current (update only the delta). Baseline test result recorded in `quality-and-risks.md`.

**2.2 Practices Discovery** — pipeline-deploy (quality, developer, devsecops) · conditional (standard+ profiles, esp. brownfield)
- Writes `design.md § 2.2 Team practices` — branching, review, testing, CI, conventions, with evidence (file paths).
- Steps: draft from repo evidence; independent checks by support personas (subagents if collaborators on); short interview to resolve gaps. Only practices the human **affirms** are promoted to `.aidlc/memory/team.md` / `project.md`.

**2.3 Requirements Analysis** — product · always
- Reads: 1.x sections, codekb (brownfield), team practices. Writes `requirements.md § 2.3`.
- Steps: FR-n and NFR-n each with rationale, acceptance criteria, priority (MoSCoW), source tag; constraints, out-of-scope, glossary. Ask about users, data, integrations, error handling, scale, security, compliance, accessibility.
- Check: each requirement testable; IDs unique; questions all answered.

**2.4 User Stories** — product (design, developer, quality as mob) · conditional: user-facing features
- Writes `requirements.md § 2.4` — US-n "As a / I want / so that" + Given/When/Then, FR links, personas.
- Mob: lead drafts; design (UX states), developer (feasibility), quality (test angle) each add notes; the lead merges.
- Check: INVEST; FR ↔ story coverage both ways.

**2.5 Refined Mockups** — design (product) · conditional: UI
- Writes `design.md § 2.5` — hi-fi descriptions or HTML/SVG, interaction spec, states, accessibility notes.

**2.6 Domain Design** — architect (aws-platform, design) · per plan
- Writes `design.md § 2.6` — components/bounded contexts (responsibility, interfaces, data ownership) and ADR-n for each significant decision (context, decision, alternatives, consequences).
- Check: simplest design meeting the NFRs; each ADR links requirements.

**2.7 Units Generation** — architect (delivery) · always when Inception-full
- Writes `design.md § 2.7` — UNIT-n (purpose, covered stories/FRs, scope, interfaces, Definition of Done), dependency DAG with topological order, story→unit map.
- Check: one owner Unit per story/FR; DAG acyclic; each Unit independently verifiable. Also mirror the Unit table into `state.md`.

**2.8 Contract Design** — architect (aws-platform) · conditional: cross-Unit or external interfaces
- Writes `design.md § 2.8` — API/event/data schemas (OpenAPI / JSON Schema snippets), versioning, error model.

**2.9 Delivery Planning** — delivery (architect) · always when Inception-full
- Writes `tasks.md § 2.9 Delivery plan` and `## Tasks`.
- Steps: break each Unit into small tasks (≤~1h, observable done-state, linked IDs, named test); group Units into bolts with Definition of Done and a confidence hypothesis; sequence by the DAG and risk; map external dependencies; propose the **verification command** from the repo scan and get explicit approval (or defer with reason); decide walking skeleton; capture team allocation if collaborators.
- Then `verification/phase-check-inception.md` (orchestrator does it when invoked from `/ai-dlc`).

## Stage self-check (all)

- Required content present; no `TODO`/`TBD`/placeholders.
- IDs referenced exist; upstream items covered both ways (no orphans).
- Claims carry source tags; no contradiction with earlier approved sections (if unavoidable, say so and ask).
- Questions all answered; assumptions listed.
