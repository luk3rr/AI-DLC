# Construction stage catalogue (3.x)

Per Unit unless noted. Sections append to `design.md` under `## 3.x …` with a `### UNIT-n` sub-heading; code and tests live in the repo; progress lives in `tasks.md`.

**3.1 Functional Design** — architect (developer) · conditional per route
- Writes `design.md § 3.1 / UNIT-n`: entities, business rules, behaviours and flows, error cases, logical design.
- Check: every covered story's acceptance criteria maps to a behaviour; rules are testable.

**3.2 NFR Requirements** — architect (devsecops, compliance, quality) · conditional
- Writes `design.md § 3.2 / UNIT-n`: performance, security, scalability, reliability, observability, accessibility targets, each measurable with a verification method. Must reference the global NFR-n IDs and add Unit-level ones as NFR-n.m.

**3.3 NFR Design** — architect (aws-platform) · conditional
- Writes `design.md § 3.3 / UNIT-n`: mechanisms satisfying each NFR (caching, retries/idempotency, authZ model, partitioning, limits).

**3.4 Infrastructure Design** — aws-platform (devsecops, compliance) · conditional
- Writes `design.md § 3.4 / UNIT-n`: resources, IaC layout, networking, least-privilege IAM, cost estimate. **Design only — no provisioning.** Use the project's real cloud/IaC tooling (not necessarily AWS).

**3.5 Code Generation** — developer · always
- Reads: Unit section in `design.md`, tasks in `tasks.md`, team practices, codekb.
- Writes: source + tests in the repo; ticks tasks; Unit summary in `tasks.md`.
- Sub-steps: 3.5a code plan + Plan Approval → 3.5b implementation → 3.5c verification → checkpoint (see SKILL.md).
- Checks: every task has its test; no files outside Unit scope (or an approved exception); no secrets, debug leftovers or placeholder code; lint/type-check as the repo does.

**3.6 Build and Test** — quality (devsecops) · always · once
- Writes `construction/build-and-test.md`: commands run + exit codes, results summary, coverage against the strategy, requirement→test matrix (every FR/NFR has ≥1 passing test or a recorded gap), dependency/security scan notes if tooling exists, known failures.
- Adds integration / e2e tests when the strategy demands.

**3.7 CI Pipeline** — pipeline-deploy · conditional · once
- Creates CI config in the repo (e.g. `.github/workflows/*.yml`) running the verification command and quality gates; writes `construction/ci-pipeline.md` (triggers, gates, caching, required checks). Do not push or enable it remotely without the user's go-ahead.

## Unit checklist before "verified"

- [ ] Plan approved · [ ] all tasks ticked with files · [ ] tests added and passing via the approved command (exit 0, shown) · [ ] acceptance criteria of covered stories demonstrably met · [ ] design.md updated if implementation deviated (deviation noted in the Unit summary) · [ ] audit entries written.
