# Operations stage catalogue (4.x)

Files under `.aidlc/<id>/operations/`; configs/IaC in the repo. All stages are conditional on the profile; each ends with a gate. Mark each step *authored* vs *executed* in the file.

**4.1 Deployment Pipeline** — pipeline-deploy · `deployment-pipeline.md`
- CD config (in repo), deployment strategy (rolling / blue-green / canary + rationale), promotion gates (verification command, smoke tests), approvals, **rollback runbook** (triggers, exact steps, data/migration considerations), whether auto-rollback is pre-authorized.

**4.2 Environment Provisioning** — aws-platform (devsecops, compliance) · `environments.md`
- Environment inventory (dev/stage/prod: accounts, regions, networks), IaC in repo, plan/diff output, least-privilege IAM review, cost estimate, validation checklist. Applying IaC = acting (fresh approval, show plan first).

**4.3 Deployment Execution** — pipeline-deploy (developer) · `deployment-log.md`
- Pre-flight (version, commit, artifact, target, rollback ready) → approval → deploy → smoke tests → health checks → record results. Stops on any failed check.

**4.4 Observability Setup** — operations · `observability.md`
- SLIs/SLOs derived from NFRs, dashboards and alarms as code, log/trace/metric conventions, alert routing and severity, on-call expectations.

**4.5 Incident Response** — operations · `incident-response.md`
- Runbooks per failure mode from design.md risks, incident process and roles, escalation matrix, post-incident review template.

**4.6 Performance Validation** — quality · `performance-validation.md`
- Load/soak test plan from NFR targets, results against thresholds (NFR validation matrix), bottlenecks. Running tests against shared/prod systems = acting.

**4.7 Feedback & Optimization** — operations (aws-platform) · `feedback.md`
- SLO report, cost analysis, incidents, user feedback → prioritized findings and candidate intents. Terminal gate: **Approve** (complete) or **Start new cycle** (→ `/ai-dlc`).

## Checks (all)

- Every NFR has an SLO/alarm or a validation result, or a recorded gap.
- Rollback exists before any production action; every executed step has evidence (command, output, time).
- No secrets in files; environment-specific values referenced by name.
