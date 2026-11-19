# OpenCode configuration adapted from Codex

Prepared for the installed OpenCode **v2.2.5**. This directory is a staged global configuration: its contents belong directly in `~/.config/opencode/`.

## Contents

- `AGENTS.md`: global engineering guidance, project abbreviations, opt-in delegation policy, PR workflow, and OpenCode runtime instructions.
- `instructions/`: all five shared engineering, testing, security, delegation, and reporting references.
- `agents/`: all ten custom Codex roles converted from TOML to OpenCode Markdown agents.
- `skills/`: all seven personal workflow skills from `~/.codex/skills`, plus `fix-node-dependabot-vulnerabilities`, `prompt-master`, and `redcare-returns-analyst` from `~/.agents/skills`. Supporting scripts, references, dependency manifests, and existing tests are included. External skill symlinks were materialized as ordinary files.
- `commands/`: ten matching slash commands that load their skills in the primary `build` session.
- `opencode.json`: default model, reasoning variants, and the local codebase-memory MCP connection.
- `migration-manifest.json`: source-to-destination inventory.

All installed instruction and workflow paths use `~/.config/opencode`. Source paths in the migration manifest intentionally identify their original locations.

## Install

The existing OpenCode configuration has not been changed. Back it up and compare any existing customizations before copying:

```sh
mkdir -p ~/.config/opencode
cp -R ~/.config/opencode ~/.config/opencode.backup-$(date +%Y%m%d-%H%M%S)
cp -R /Users/mariano.custiel/.codex/opencode-adapted/. ~/.config/opencode/
```

Copying merges directories and overwrites matching files. It retains other existing files, including plugins and any `opencode.jsonc`; compare those for conflicting settings. Start a new OpenCode session after installing.

## Use

```text
/write-spec describe the requested change
/review-spec path/to/spec.md
/run-spec-tdd path/to/approved-spec.md
/implementation-subagents implement the agreed change
/review-subagents review the current changes
/github-pr-feedback-checker https://github.com/owner/repository/pull/123
```

The commands load skills rather than immediately launching agents. `/review-spec` checks correctness, ambiguity, atomicity, and test derivability. The PR feedback workflow loads it automatically for specs added or modified by the PR and explicitly referenced governing specs, before applying fixes or deciding approval; material findings or incomplete required spec review withhold approval under the existing publication rules. Review and implementation commands authorize only their respective bounded role categories. `/run-spec-tdd` still requires its separate cycle-level assignment approval. The explicit-only delegation workflows and prompt-master are marked `disable-model-invocation: true`; load them by command or explicit user request. Other skills remain discoverable automatically.

## Adaptations and prerequisites

- **Models:** the default is `openai/gpt-6.1-sol#medium`, preserving the Codex model and effort. The seven writer/reviewer roles that specified high effort use `openai/gpt-6.1-sol#high`. The three graph roles inherit the parent model. Both variants are configured explicitly. Authenticate the OpenAI provider in OpenCode; Codex credentials are not copied. Model access still depends on the connected account.
- **Agent format:** OpenCode V2 uses plural `agents/`, `commands/`, `agents` configuration, and ordered `permissions` rules. These files do not target the V1 format.
- **Role permissions:** every custom child denies further delegation. Reviewers deny editing and unrelated tools; shell checks require permission and remain subject to the original role restrictions. Graph agents deny shell and editing, with explicit read-only MCP tool allowlists matching their Codex profiles. Environment-file approval rules are retained. These are tool controls, not an OS sandbox; reviewer shell access does not enforce filesystem read-only behavior.
- **MCP:** the existing executable `/Users/mariano.custiel/.local/bin/codebase-memory-mcp` is referenced, not copied. OpenCode inherits the launching process environment, including `CBM_CACHE_DIR` and `CBM_RUNTIME_DIR` if set. Graph roles share that server and enforce their original tool subsets through per-agent permissions; separate per-agent server processes and CLI profiles are not reproduced. Missing MCP access remains a prerequisite to report, never successful verification.
- **Background work:** OpenCode uses `subagent` and returned `sessionID` values for assignments and follow-ups. The global instructions explain its notifications and prohibit inventing Codex wait, interrupt, or capacity-release tools. If a required lifecycle control is unavailable, the workflow must report the limitation and stop dependent dispatch.
- **Skill scripts:** install their normal dependencies when using them. The Dependabot skill retains its package files; the returns skill retains its Python scripts and runtime checks. The bundled Dependabot validator now checks its OpenCode command instead of Codex UI metadata. Neither GitHub nor the returns API was contacted during adaptation. API credentials are not bundled.
- **Excluded platform components:** Codex-managed `.system` skills, cached marketplace/plugin skills, the empty runtime skill directory, disabled ChatGPT computer-use MCP, credentials, session history, approval history, and desktop settings are not portable and are not copied. OpenCode needs its own integrations for capabilities supplied by those plugins. This bundle covers your custom agents, personal skills, and shared policy files; it does not claim to reproduce every Codex desktop feature.

## Documentation

The conversion follows the official [OpenCode agents](https://opencode.ai/docs/agents/), [skills](https://opencode.ai/docs/skills/), [commands](https://opencode.ai/docs/commands/), [instructions](https://opencode.ai/docs/instructions/), [permissions](https://opencode.ai/docs/permissions/), [models](https://opencode.ai/docs/models/), and [MCP](https://opencode.ai/docs/mcp-servers/) documentation. The source skill structure follows the [OpenAI skill format](https://developers.openai.com/plugins/build/skills).

## Verification performed

- OpenCode v2.2.5 loaded all ten custom agents from this staged configuration using an isolated temporary config root and `opencode debug agents --standalone`. Their descriptions, model variants, delegation denials, edit restrictions, environment-file approvals, and graph tool allowlists were checked against the intended conversion.
- All 30 agent, skill, and command YAML frontmatter documents parsed successfully. All ten skill/command pairs and installed configuration references resolve within this bundle.
- The adapted Dependabot skill validator passed using the source skill's existing local dependencies. Copied skill scripts were not run against GitHub or internal APIs.
- Primary-agent self-review only. No independent subagent review, model inference, live MCP functionality check, or full workflow execution was performed. OpenCode's global default model and agent files load successfully; provider authentication and model access still need an authenticated session.
