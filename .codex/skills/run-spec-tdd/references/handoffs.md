# Assignments and execution evidence

Use compact chat records; do not add a repository progress file by default.

## Cycle approval proposal

Identify the approved spec revision and slices. List proposed agents, owned files/responsibilities, exclusions, stage, completion condition, and benefit. Include mandatory preimplementation test review and any justified postimplementation review. Ask for affirmative approval once for this bounded cycle. Preserve earlier authorization; obtain fresh approval only for additions or expansion. A pending proposal does not authorize its work.

## Assignment

- Approved spec revision/digest, slice and criterion IDs, applicable contracts and security criteria.
- One bounded objective; owned files/responsibilities and explicit exclusions; one owner per shared file.
- Relevant paths/interfaces and evidence rather than repeated exploration.
- Intended checks, permitted execution, readiness requirements, and completion condition.
- Explicit comparison base, included changes (including relevant staged and untracked files), and stable reviewed state for reviews; no default review diff.
- Required shared guidance paths and role-specific reading requirements. Read the relevant section of `~/.codex/instructions/reporting.md` before reporting.
- You are not alone in the checkout: preserve others' work, coordinate scope changes through the primary agent, and do not delegate, commit, push, or publish.

Integration writer: author tests/fixtures/stubs only; report `tests ready; execution pending`. Never start app, integration infrastructure, or integration suites.

Unit writer: author supporting isolated unit tests before or during implementation as interfaces become clear; run only inspected unit/static commands. Report actual passing/failing/blocked coverage; unit readiness and unit red are not preimplementation gates. Applicable unit tests must pass before completion. No business implementation or integration execution.

Production writer: implement production only after applicable red/verification and review gates. Run relevant unit/static checks; do not edit tests, snapshots, or spec. Report readiness for primary-agent integration execution.

Test reviewer: before implementation, assess integration acceptance coverage, expectations, test independence/discovery, integration red evidence, and justified technical applicability. Include unit tests already available without requiring unit readiness or unit red. Review supporting unit tests added or changed afterward before slice completion. Read-only review, including new files explicitly; no integration execution. Report actionable findings or limitations.

## Chat checkpoint

Record only what is needed to resume and assess the result:

- Spec path, approved revision/digest, and actual approval evidence; delegation approval and bounded scope.
- Slice/criterion IDs, stage, owners/agent IDs, unresolved decisions and next action.
- Source revision, included working-tree changes and untracked assets; artifact identity/configuration as applicable. Without Git, use a scoped file manifest/content digests.
- Exact executed command and working directory, outcome, discovered tests, and concise safe failure evidence. Identify expected failing assertions separately from environment/compiler/discovery errors.
- Criterion → test/check → red-to-green, unmet-to-met, baseline preserved, already satisfied, or not applicable with reason. Record evidence links when available; never expose secrets or unnecessary personal data.
- Reviewed state, findings/disposition, and invalidated checks requiring rerun.

Readiness from an author is not test execution. A failing exit code alone does not establish red, and a successful exit code alone does not establish criterion coverage.
