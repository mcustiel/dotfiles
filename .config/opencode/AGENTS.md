# Engineering instructions

## Required guidance

Apply this guidance to engineering work and follow explicit task instructions and applicable repository conventions. Read the required files before the relevant work; their standards apply equally to direct and delegated work. Paths below are under `~/.config/opencode/instructions/`.

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

Detailed security requirements have one authoritative home in `~/.config/opencode/instructions/security.md`. If required guidance is missing or unreadable, report the prerequisite, stop dependent work, and continue safe independent work. Do not claim affected security work, verification, or review is complete. Shared standards govern solo implementation and self-review; the primary agent need not load specialist role files when working alone. Self-review is not independent review.

## Repository conventions

Follow the inspect, match, or ask requirements in `instructions/engineering.md` for production code, unit tests, and integration tests. Inspect representative existing files before writing; obtain explicit user approval before departing from established patterns, even for small improvements. These requirements apply equally to direct and delegated work.

## Delegation policy

- Work without subagents by default. Delegation is opt-in.
- Explicit invocation of `/review-subagents` authorizes relevant review subagents for the current task; explicit invocation of `/implementation-subagents` authorizes production and integration-test writers. Each skill authorizes its own category only, and both may be invoked together.
- Announce bounded assignments before dispatch. Invocation authorizes those assignments and necessary follow-ups within the current task without another approval. Material task expansion requires fresh authorization. Honor direct user requests authorizing bounded delegation under the same category and scope limits.
- `/run-spec-tdd` is a separate explicit-only workflow: invocation and spec approval do not authorize delegation. Obtain its separate cycle-level assignment approval and preserve its independent authorship and verification gates. Ordinary delegation skills cannot bypass those requirements.
- Only the primary agent orchestrates subagents. Missing roles, guidance, scope, or withdrawn authorization stop dependent delegation; follow `~/.config/opencode/instructions/delegation.md` and continue independent work where possible.
- Delegation adds no permission to commit, push, publish, deploy, contact production systems, or perform destructive actions.

## Pull request workflow

- When the user asks the agent to create a pull request, the agent must invoke the `github-pr-feedback-checker` skill on the created pull request after creation.

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
| PCS | `product-complaints-service` |

<!-- codebase-memory-mcp:start -->
For structural codebase exploration, use the installed `codebase-memory` skill.
<!-- codebase-memory-mcp:end -->

## OpenCode runtime

- This configuration is installed at `~/.config/opencode`; expand `~` to the user's home directory when a tool needs an absolute path.
- Load workflows using OpenCode's `skill` tool. Slash commands such as `/review-subagents`, `/implementation-subagents`, and `/run-spec-tdd` are explicit workflow invocations. Merely discovering or migrating a skill does not invoke it or authorize delegation.
- Delegate only when authorized above. Use `subagent` with the configured agent ID, a short `description`, and a self-contained `prompt`. Retain its returned `sessionID`; continue that child by passing the same ID with a follow-up prompt. Do not use Codex collaboration tool names.
- Child sessions run in the background and send a completion/idle notification after each round. Do not report an independent gate complete before its actual result arrives. Do not assume an interrupt, release, or wait tool exists: use a supported session-control API if available. If required cancellation or capacity control is unavailable, stop dispatch, report the limitation, and do not claim the child was stopped.
- Subagents must never launch further subagents. Configured child permissions deny this; the primary agent owns orchestration and integration execution.
- For structural exploration, use the configured `codebase-memory-mcp` tools. Call `list_projects`/`index_status`; when no matching project exists, index only the intended repository before structural queries. Do not index the global configuration directory simply to inspect Markdown or configuration files.
- Use native `read`, `glob`, `grep`, `shell`, `websearch`, and `webfetch` tools as available. Discover MCP tools from OpenCode's tool catalog; do not assume Codex tool namespaces, connectors, desktop APIs, or plugin sessions exist.
- OpenCode permissions govern tools and are not an operating-system sandbox. Follow shared role and security restrictions even when the host permits an operation.
