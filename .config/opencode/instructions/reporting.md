# Engineering reporting

Use these shared reporting conventions alongside the applicable AGENTS.md and
role instructions. Read only the section relevant to the current report.
They do not change assignment scope, ownership, approvals, security requirements, execution permissions, readiness gates, or review criteria.
Keep role-specific evidence requirements and required readiness/no-findings
statements from the role instructions. Apply the relevant section only.

## Review findings

Keep findings concise while preserving the evidence needed to assess them.
Report each distinct issue once; omit routine checklist results, raw logs,
and tool-call narration. If no actionable findings exist, use the role's
no-findings statement and a brief scope/verification/limitations summary.
Lead with actionable findings, ordered by severity:
[P0] critical immediate action; [P1] high priority; [P2] normal priority;
[P3] low priority. Use the role's impact and evidence criteria to assign priority.

For each finding, provide a concise title and exact file/line reference, followed
by the role-specific explanation, evidence, impact, remedy, and verification.
For diff reviews, anchor findings to changed lines when possible.
End with scope, checks actually run, results, and material limitations, including
the reviewed state. Do not claim unperformed checks or independent review when
the primary agent performed self-review.

## Writer handoffs

For staged feature work, include the branch/PR map and stage-specific readiness from `~/.config/opencode/instructions/vertical-slices.md`: fork point, current comparison base/head, owned changes, expected acceptance red, stage unit/static results, and pending assembly/parent checks. Keep the acceptance-test review separate from production-stage reviews.

Keep readiness, completion, and failure handoffs concise. Reference files and
evidence instead of repeating the assignment, raw logs, or tool-call history.
Preserve required readiness details, material failures, uncertainty, unresolved
decisions, and limitations. Include the role's required fields and statements;
readiness does not establish integration execution or combined feature completion.

## Completion reports

- Report resulting behavior, relevant checks and results, review status, material findings, and unresolved limitations. For staged feature work, include skipped-stage reasons, branch/PR review and merge status, initial acceptance red, and available assembly evidence. At the implementation handoff, confirm component PRs remain open targeting the parent and report colleague reviews, the user's manual merges, and actual parent verification as pending where applicable. Distinguish temporary assembly results from actual parent verification and readiness for main; require final assembled-parent green evidence only after manual assembly, before readiness for main.
- Distinguish passed, failed, and unperformed checks. Never claim verification or review that did not occur.
- Keep reporting concise and proportional to the change. Lead with the outcome and material findings; omit repeated handoffs, raw logs, and routine checklist narration. Surface material security gaps and decisions requiring user or platform input.

