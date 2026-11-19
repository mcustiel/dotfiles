---
description: "Load and follow the review-spec workflow"
agent: "build"
subagent: false
---

Explicitly invoke the `review-spec` skill for the following request. Load it with the `skill` tool before acting, using `~/.config/opencode/skills/review-spec/SKILL.md` as the source if direct file reading is required. Follow all scope, authorization, and approval gates in that skill.

$ARGUMENTS
