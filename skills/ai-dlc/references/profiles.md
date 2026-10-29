# Workflow profiles (scopes)

A profile = **stage route + depth + test strategy + ceremony**. Propose one from the user's words; confirm; allow override. Stage numbers refer to the stage catalogues in the phase skills (`ai-dlc-inception`, `-construction`, `-operations`). Initialization (0.1–0.3) always runs first and is automatic. A listed stage may still self-skip when its condition fails (e.g. 2.1 only if brownfield; 2.5/1.6 only if UI).

## Chooser

| Profile | Best for | Depth / Tests | Route (after Initialization) |
|---|---|---|---|
| `enterprise` | Regulated / high-assurance, full traceability | Comprehensive / Comprehensive | all 1.1–1.7, 2.1–2.9, 3.1–3.7, 4.1–4.7 (30). Collaborators (support personas) ON |
| `feature` | Production feature, complete lifecycle | Standard / Standard | same 30 stages as enterprise, collaborators off |
| `mvp` | First real product increment, no Operation | Standard / Standard | 1.1, 1.3, 1.4, 1.6; 2.1–2.9; 3.1–3.7 (20) |
| `classic` | V1-style: Inception + Construction ending at Build & Test (default if unsure and the work is non-trivial) | Standard / Standard | 2.1–2.9; 3.1–3.6 (15) |
| `workshop` | Facilitated training / group delivery | Standard / Minimal | 2.1–2.9; 3.1–3.7; 4.1–4.7 (23) |
| `poc` | Test feasibility with the smallest implementation | Minimal / Minimal | 1.1; 2.1; 2.3; 3.5; 3.6 (5) |
| `express` | Lightest requirements→code→test path | Minimal / Minimal | 2.1; 2.3; 3.5; 3.6; 4.1; 4.3; 4.4 (7) |
| `bugfix` | Known defect: focused fix + regression test | Minimal / Minimal | 2.1; 2.3; 3.5; 3.6; 4.1; 4.3 (6) |
| `refactor` | Improve code, same behavior | Minimal / Minimal | 2.1; 2.3; 3.1; 3.5; 3.6; 4.1; 4.3 (7) |
| `infra` | Environments, IaC, deployment foundations, cost | Standard / Standard | 2.2; 2.3; 3.2; 3.3; 3.4; 3.7; 4.1–4.4 (10) |
| `security-patch` | CVE / focused vulnerability response | Minimal / Minimal | 2.1; 2.3; 3.2; 3.5; 3.6; 4.1; 4.3 (7) |
| *custom* | Nothing fits | user-chosen | compose from the catalogue; show the route and get confirmation |

Counts exclude Initialization. 2.1 appears in a route but runs only for brownfield.

## Selection heuristics

- "Fix the timeout/bug/regression in X" → `bugfix`. "CVE-…", "vulnerability", "dependency patch" → `security-patch`.
- "Clean up / restructure / migrate without changing behavior" → `refactor`.
- "Terraform / CDK / pipeline / environments / cost" → `infra`.
- "Try / spike / prototype / is it feasible" → `poc`.
- "Quick endpoint / small script / just build X" with clear scope → `express`.
- "Build product/feature with stories, multiple components" → `feature` (production) or `mvp` (no ops).
- Compliance, audit, regulated data, many stakeholders → `enterprise`.
- Training/facilitated session → `workshop`.
- Ambiguous → propose `classic` or `feature` and say why; offer the lighter alternative.

## Depth levels

| Depth | Artifact detail |
|---|---|
| **Minimal** | Short artifacts (a page or less), only decisions that matter, few questions (≤5 per stage), no optional sections |
| **Standard** | Full required sections, questions for every real ambiguity, traceability IDs |
| **Comprehensive** | Alternatives considered, risk register, compliance mapping, NFR detail, ADRs for every significant decision, reviewer pass on each stage |

## Test strategy levels

| Level | Expectation |
|---|---|
| **Minimal** | Regression/smoke test covering the change; the approved verification command passes |
| **Standard** | Unit tests per component + integration tests for Unit boundaries + acceptance checks per user story |
| **Comprehensive** | Standard + NFR validation (performance, security, resilience), negative/failure cases, traceability matrix requirement→test |

## Ceremony switches (override per intent, record in state)

`collaborators` (support personas join stages), `reviewers` (read-only review subagent per stage), `plan_approval` (approve each Unit's code plan), `summary_confirmation`, `walking_skeleton`, `autonomy` (gated|autonomous), `iteration` (unit-major serial | stage-major | swarm).
Defaults: enterprise = collaborators+reviewers on; everything else lean. Turning a switch off removes only the ceremony it names — never the human approval gates.
