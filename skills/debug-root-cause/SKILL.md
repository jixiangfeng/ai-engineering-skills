---
name: debug-root-cause
description: >-
  Read-first root-cause debugging workflow for errors, failing tests, startup failures, API bugs, regressions, or unexpected runtime behavior. Produces Chinese reproduction, evidence, hypothesis, trace, root cause, fix options, verification, and optional handoff to software-delivery-pipeline.
---

# Debug Root Cause

Use this skill when the user asks to investigate an error, failing test, startup failure, runtime exception, bad API behavior, regression, or confusing system behavior.

## Core Rules

- Debugging starts read-first and evidence-first. Do not patch code until root cause and fix direction are confirmed or the user explicitly asks for immediate repair.
- Reproduce before explaining when practical. If reproduction is blocked, record the blocker and use available evidence.
- Do not guess fixes from symptoms. Trace data/control flow back to the source.
- Separate environment failures, existing failures, test bugs, product-code bugs, and unclear behavior.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, error text, API names, and quoted user text.
- If a fix is needed, create `review-to-delivery-handoff.md` for `software-delivery-pipeline` rather than silently expanding into implementation.

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if the result may hand off to implementation
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task


## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create artifacts under `<project-root>/workflow/debug/<YYYY-MM-DD>-<slug>/`.

Required files:
1. `01-debug-scope.md`
2. `02-debug-reproduction.md`
3. `03-debug-evidence.md`
4. `04-debug-hypotheses.md`
5. `05-debug-root-cause.md`
6. `06-debug-fix-options.md`
7. `07-debug-verification-plan.md`
8. `08-debug-summary.md`
9. `review-to-delivery-handoff.md` (optional, when implementation is needed)

Use templates in `assets/debug-templates/`.

## Workflow

1. Define the failing behavior and scope.
2. Reproduce or document why reproduction is blocked.
3. Collect exact evidence: commands, logs, stack traces, code paths, configs, data.
4. Generate hypotheses and eliminate them with evidence.
5. State root cause with confidence and source evidence.
6. Propose fix options and tradeoffs.
7. Define verification plan.
8. Ask the human to confirm fix direction before implementation, or hand off to `software-delivery-pipeline`.

## Handoff

`review-to-delivery-handoff.md` must include root cause, selected fix option, affected files, scope lock, verification requirements, risks, and unresolved questions.
