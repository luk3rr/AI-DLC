# AI-DLC methodology reference

Sources: AWS DevOps Blog "AI-Driven Development Life Cycle", AWS Builder Center articles, and the open-source `awslabs/aidlc-workflows` repository (v2: 5 phases, 33 stages, 14 agents, 11 scopes).

## Core ideas

- **AI is a central collaborator, not an autocomplete.** AI proposes plans, artifacts, and questions; executes approved tasks.
- **Humans keep decision rights.** People hold business context, validate requirements, review technical decisions, approve changes.
- **Shared understanding before implementation.** Nothing is built until the team agrees on what is being built.
- **Persistent, compounding context.** Requirements, decisions, plans, and test results are repo artifacts; each phase enriches the next.
- **Proportional rigor.** Depth (Minimal / Standard / Comprehensive) scales with risk and complexity.
- **Speed is not the goal.** The goal is a tested, maintainable, deployable solution — not more generated code.
- **Small mob, broad agents.** A few broadly capable personas that each span several stages beat many narrow specialists (fewer hand-offs, less lost context).

## The AI-driven loop

`plan → clarify (questions) → human validates → execute → record`. Applied to every stage. Questions are the main mechanism for preventing wrong assumptions; approval gates are the main mechanism for keeping humans in control.

## Original three phases (AWS)

| Phase | Purpose | Ritual |
|---|---|---|
| **Inception** | Turn business **Intent** into requirements, stories, and **Units of work** | **Mob Elaboration** — the whole team validates the AI's questions and proposals together |
| **Construction** | Turn validated context into domain/logical design, code, tests | **Mob Construction** — team resolves technical/architectural decisions in real time |
| **Operations** | Deploy, observe, improve; IaC and deployment managed with accumulated context | Human oversight of infra changes, permissions, rollback; feedback feeds next cycle |

## Upstream v2 refinement (5 phases)

0. **Initialization** — workspace scaffold, detection, state init (automatic).
1. **Ideation** — validate the initiative: intent, research, feasibility, scope, team, rough mockups, approval.
2. **Inception** — reverse engineering (brownfield), practices, requirements, stories, mockups, domain design, units, contracts, delivery plan.
3. **Construction** — per Unit: functional design, NFRs, NFR design, infra design, code; then build/test and CI once.
4. **Operation** — deploy pipeline, environments, deploy, observability, incident response, performance validation, feedback.

Verification gates sit at Ideation→Inception, Inception→Construction, Construction→Operation. A feedback loop returns from Operation 4.7 to Ideation 1.1.

## Terminology (Agile → AI-DLC)

| Agile | AI-DLC | Notes |
|---|---|---|
| Project / initiative request | **Intent** | The business goal captured verbatim; one record dir per intent |
| Epic | **Unit of Work** | Cohesive, independently buildable slice; forms a dependency DAG |
| Sprint | **Bolt** | Short, intense delivery slice (hours/days) over one or more Units with a Definition of Done |
| Sprint planning / refinement | **Mob Elaboration** | AI drafts, team validates in one shared session |
| Pairing / implementation | **Mob Construction** | Real-time resolution of technical decisions |
| Definition of Done | **Verification gate / checkpoint** | Evidence-backed (verification command exit 0) |
| Backlog | **Intent backlog / bolt plan** | |

Other terms: **Scope / workflow profile** (the route + depth + test strategy), **Depth** (Minimal/Standard/Comprehensive artifact detail), **Approval gate** (human decision over completed work), **Walking skeleton** (first Unit as smallest working integrated slice), **Brownfield/Greenfield**, **Sensor** (automated check on artifact quality: required sections, traceability, upstream coverage, claim sources), **Learnings / rules** (behavioral rules distilled from past corrections and stored in memory).

## Why it differs from "just prompting"

Plain AI-assisted coding is human-driven with AI assisting selected tasks. AI-DLC inverts initiative: the AI drives the plan and asks the questions; humans validate. This front-loads clarification (cheap) to avoid rework (expensive), and leaves an audit trail of who decided what.
