# AI-DLC skills for Claude Code

Five Claude Code skills that run work through **AI-DLC** (AI-Driven Development Life Cycle, AWS): the AI plans and asks questions, a human approves at gates, and only then does the AI build. Everything is written to `.aidlc/` in the project, so work survives across sessions.

| Skill | Role |
|---|---|
| `ai-dlc` | **Orchestrator.** Creates the intent, picks the profile/route, owns `state.md`/`audit.md`, hands off to the phase skills, runs verification gates, `status` / `resume` / `audit` |
| `ai-dlc-inception` | Ideation + Inception (mob elaboration) → writes `requirements.md`, `design.md`, `tasks.md` |
| `ai-dlc-codekb` | Builds the code knowledge base **with the user**: read-only scan, per-area walkthrough with interactive questions, human-validated `.aidlc/codekb/<repo>/`. Runs as stage 2.1 or standalone (`/ai-dlc codekb`) |
| `ai-dlc-construction` | Implements `tasks.md` Unit by Unit: per-Unit design, code + tests, build & test, CI |
| `ai-dlc-operations` | Pipeline, environments, deploy, observability, incident response, performance, feedback loop |

## Install

```sh
./install.sh              # symlinks into ~/.claude/skills/
./install.sh --project    # into ./.claude/skills (run inside the target repo)
./install.sh --copy       # copy instead of symlink
```

Restart Claude Code, then:

```
/ai-dlc Build a REST API for inventory management
/ai-dlc bugfix Fix the timeout on the export endpoint
/ai-dlc status | resume | audit | phase <name> | profile <name>
/ai-dlc codekb [init|update|area <x>|review]    # learn an existing codebase with you (do this first on brownfield)
/ai-dlc language                               # switch chat/files language (pt-BR / en-US)
/ai-dlc memory [add|review]                    # approved rules that shape future work
/ai-dlc-inception | /ai-dlc-construction | /ai-dlc-operations   # run a single phase on the open intent
```

## Workspace

```
.aidlc/
  <YYMMDD>-<label>/        # one folder per intent
    requirements.md        # what & why: intent, scope, FR/NFR, user stories
    design.md              # how: analysis, components, ADRs, Units, contracts, per-Unit design
    tasks.md               # do: approved verification command, bolts, checkbox tasks per Unit
    state.md  audit.md     # route/status and append-only decision log
    verification/  construction/  operations/  archive/
  codekb/<repo>/           # human-validated knowledge of the existing code (overview, architecture, conventions, …)
  memory/{project,team,org}.md  # approved rules; proposed at defined moments, never written silently
```

## Conventions

- **Language:** the first thing asked each session — pt-BR, en-US, or chat and files in different languages. File names, section headings, IDs and status keywords stay in English so cross-references keep working. Saved in `.aidlc/config.md` and `state.md`.
- **Interactive questions:** every question uses Claude's AskUserQuestion — selectable options (recommended first) plus a free-text "Other".
- **Mermaid diagrams** for components, Unit DAG, sequences, ER, state machines, pipelines and infra, shown at gates.
- **Memory** is proposed at: practices affirmed (2.2), codekb walkthroughs, repeated corrections / "always/never", phase retrospectives, Operations feedback (4.7), or `/ai-dlc memory`.

## Flow

`/ai-dlc` → profile + route confirmed → **Inception** (requirements → design → tasks, each stage gated) → verification gate → **Construction** (per Unit: design → code+tests → run approved verification command → checkpoint; failures always halt) → verification gate → **Operations** (author pipeline/IaC/runbooks; acting on real environments needs a fresh yes) → feedback seeds the next intent.

Profiles: enterprise, feature, mvp, classic, workshop, poc, express, bugfix, refactor, infra, security-patch, or custom.

## Layout of this repo

```
skills/<skill>/SKILL.md            # loaded on invocation
skills/<skill>/references/         # loaded on demand (shared protocols/templates/personas/profiles live in ai-dlc/references)
install.sh                         # symlink/copy the skills into ~/.claude/skills or a project
scripts/validate.sh                # structural checks (also run by CI)
```

## Relationship to upstream

A lightweight, Markdown-only distillation of the methodology and of [awslabs/aidlc-workflows](https://github.com/awslabs/aidlc-workflows), which ships a full engine (`aidlc` CLI, hooks, sensors, 14 agents). Without hooks, rigor depends on the model following the skill; for deterministic enforcement install the official engine (the orchestrator detects it and offers to defer).

Sources: [AWS DevOps Blog](https://aws.amazon.com/blogs/devops/ai-driven-development-life-cycle/), [AWS Builder Center](https://builder.aws.com/content/3KjWpM4sqd5f0zjUtE67OfUa7rk/ai-driven-development-life-cycle-ai-dlc-on-aws-a-new-approach-to-software-engineering), upstream docs.

## Disclaimer

The AI-DLC methodology originates from AWS; this project is an independent implementation and is not affiliated with or endorsed by AWS or Anthropic. Run `./scripts/validate.sh` before opening a PR.
