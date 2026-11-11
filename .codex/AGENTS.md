# Engineering instructions

## Required guidance

Apply this guidance to engineering work and follow explicit task instructions and applicable repository conventions. Read the required files before the relevant work; their standards apply equally to direct and delegated work. Paths below are under `~/.codex/instructions/`.

| Agent or activity | Read before work |
| --- | --- |
| Primary agent doing engineering work | `engineering.md`; `testing.md` before planning or performing verification; `security.md` before defining security criteria, implementing, or executing integration tests |
| Production and test writers | `engineering.md`, `security.md`, `testing.md`, `delegation.md` |
| Code-quality reviewer | `engineering.md`, `delegation.md`, and the primary agent's supplied security criteria |
| Security reviewer | `security.md`, `delegation.md`; `engineering.md` and `testing.md` as relevant |
| Reliability reviewer | `engineering.md`, `delegation.md`, and supplied security criteria |
| Test reviewer | `testing.md`, `delegation.md`, and supplied security criteria |
| Primary agent assigning subagents | `delegation.md` and the applicable explicitly authorized workflow |
| Findings, handoffs, or completion reports | Relevant section of `reporting.md` |

Detailed security requirements have one authoritative home in `~/.codex/instructions/security.md`. If required guidance is missing or unreadable, report the prerequisite, stop dependent work, and continue safe independent work. Do not claim affected security work, verification, or review is complete. Shared standards govern solo implementation and self-review; the primary agent need not load specialist role files when working alone. Self-review is not independent review.

## Delegation policy

- Work without subagents by default. Delegation is opt-in.
- Explicit invocation of `$review-subagents` authorizes relevant review subagents for the current task; explicit invocation of `$implementation-subagents` authorizes production and integration-test writers. Each skill authorizes its own category only, and both may be invoked together.
- Announce bounded assignments before dispatch. Invocation authorizes those assignments and necessary follow-ups within the current task without another approval. Material task expansion requires fresh authorization. Honor direct user requests authorizing bounded delegation under the same category and scope limits.
- `$run-spec-tdd` is a separate explicit-only workflow: invocation and spec approval do not authorize delegation. Obtain its separate cycle-level assignment approval and preserve its independent authorship and verification gates. Ordinary delegation skills cannot bypass those requirements.
- Only the primary agent orchestrates subagents. Missing roles, guidance, scope, or withdrawn authorization stop dependent delegation; follow `~/.codex/instructions/delegation.md` and continue independent work where possible.
- Delegation adds no permission to commit, push, publish, deploy, contact production systems, or perform destructive actions.

## Project abbreviations

Recognize these names case-insensitively:

| Abbreviation | Repository |
| ------------ | ---------- |
| RLS | `return-label-service` |
| FUS | `file-uploader-service` |
| DRS | `documents-read-service` |
| DIS | `documents-integration-service` |
| CSA | `composition-service-account` |
| CST | `composition-service-transactions` |
<!-- codebase-memory-mcp:start -->
For structural codebase exploration, use the installed `codebase-memory` skill.
<!-- codebase-memory-mcp:end -->
