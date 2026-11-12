---
name: be-ambitious
description: Upgrade a task or prompt along altitude, depth, and range, get approval, then run the upgraded version. Invoke manually with /be-ambitious <task> in Claude Code or $be-ambitious <task> in Codex.
disable-model-invocation: true
argument-hint: "<task or prompt you are about to give>"
---

# Be Ambitious

Take the task the user passed when invoking this skill. If none was given, ask for it.

## 1. Ground

Inspect the actual context with a few cheap tool calls: the repo, files, data, and available tools. Base every upgrade on what you find.

## 2. Analyze

### Altitude

- Ask "what should happen after this is done?" and "what is the goal behind the goal?" Repeat until you reach the outcome the user actually wants.
- Restate the task at that level. Example: "fix this crash" becomes "keep the app crash-free".
- Name the access the model needs to check its own progress (data, logs, tests, tools). If it is missing, list what the user must provide.

### Depth

Answer these and fold the answers into the prompt:

1. What would a top expert in the field do here that the request did not ask for?
2. What raw material would they start from (raw data, source code, logs, primary sources)?
3. Which professional methods and tools of the field would they use?
4. What independent evidence would confirm the result (tests, re-derivation from raw data, a separate reviewer agent, a measurable metric)? Do not use self-assessment as verification.

Also:

- Set specific, hard, measurable success criteria.
- Plan tests of the key assumptions against raw data.
- Look for blind spots and early-warning signals in the data.

### Range

- Restate the task as verbs without its domain nouns. Example: a quarterly review is "getting busy people to believe a story about cause and effect". List other fields that are good at those verbs and what to borrow from each.
- Define a small team of roles (for example analyst, editor, domain specialist, red team). Each role does that role's actual work; the red team actually tries to break the conclusion. Do not role-play voices.

## 3. Propose and wait

Show:

- **Original task**, as given.
- **Findings per axis**: a few bullets each, specific to this task.
- **Upgraded prompt**: ready to run, with outcome, raw inputs, methods, success criteria, verification step, and roles.
- **Cost and requirements**: extra time, tokens, access, and data needed from the user.
- **Why each change matters**: one line per change.

Every addition must change what gets done or how it is verified. If the task is small and already well aimed, say so and propose only the one or two upgrades that matter.

Stop and wait for explicit approval. The user may approve, edit, or scale back an axis.

## 4. Execute

- Run the approved prompt. Use subagents for independent roles if the agent supports them.
- Run the verification step and keep its output. Report failed checks as failed.

## 5. Reply

Report concisely:

- Conclusion first.
- Findings with evidence (numbers, file paths with line numbers, command output, sources).
- Verification performed and its result.
- What remains unverified or open.
