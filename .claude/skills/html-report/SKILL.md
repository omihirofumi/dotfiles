---
name: html-report
description: Publish the results of the current work (an analysis, investigation, code review, experiment, research, or completed task) as a polished HTML report on a private claude.ai Artifact page and return the link. Use when the user asks for an HTML report, a report page, a shareable write-up, or a "results page". Not for editable documents people will keep editing as text.
argument-hint: "[what the report should cover]"
---

# HTML Report

Turn what this session produced into a report a reader can grasp in a minute and trust, then publish it as a private claude.ai Artifact.

## 1. Collect the content from the session

Draw only from what actually happened in this conversation and its tool results. If `$ARGUMENTS` narrows the scope, follow that. Gather:

- **Goal**: what was asked.
- **Conclusion**: the answer or outcome, in one or two sentences.
- **Findings**: the key results, each with its supporting evidence (numbers, file paths with line numbers, command output, sources).
- **Verification**: how the results were checked, and what passed or failed.
- **Method**: the approach taken, briefly.
- **Limitations and open questions**: what was not checked, assumptions that still hold the conclusion up, and next steps.

Do not fill gaps with plausible-sounding content. Mark anything unverified as unverified, because a report reads as authoritative and readers will act on it.

## 2. Structure it for the reader

Lead with the conclusion, then findings, then evidence and method. A reader who stops after the first screen should still leave with the right answer. Use tables for comparisons, short code blocks for exact commands or snippets, and a diagram only when it shows a real mechanism. Show before/after comparisons side by side.

## 3. Build and publish with the Artifact tool

- Start with `Artifact` `action: "quickstart"`, `intent: "other"`, and follow the design guidance it returns (it covers the page contract: title, theming, dark mode, phone width, allowed CDNs).
- Write one self-contained `.html` file in the scratchpad directory, then publish it with a short `icon` such as `report` and a one-sentence `description`.
- If a report for the same work was already published in this session, republish the same file path so the link stays the same.
- If the results contain material the user treated as sensitive (credentials, customer data, unreleased internal figures), write the file but ask before publishing, and say what would be exposed.

## 4. Reply

Give the link, a two- or three-line summary of the conclusion, and anything the reader should know that the page does not make obvious.
