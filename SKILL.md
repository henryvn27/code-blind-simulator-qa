---
name: code-blind-simulator-qa
description: Orchestrate independent black-box QA of an already-built iOS app with fresh-context subagents instructed to observe and operate only assigned simulators, without source, repository, test, issue, or prior-QA context. Use for code-blind simulator testing, fresh-eye product audits, independent smoke, exploratory, or visual QA, regression validation after UI or behavior changes, and requests to reduce implementation bias in iOS acceptance evidence.
license: MIT
---

# Code-Blind Simulator QA

The orchestrator knows the code; the tester does not.

Use runtime-only testers to discover what a user actually experiences. Keep repository inspection, building, diagnosis, fixes, and regression ownership with the orchestrator.

## Preserve the isolation boundary

Treat code blindness as behavioral isolation, not a security sandbox. Subagents can inherit powerful tools, so use a fresh context with no inherited turns, state the prohibitions explicitly, and reject any report that contains source-derived knowledge. When the harness exposes activity traces, invalidate any run that invoked filesystem, shell, Git, build, tracker, or source-search tools even if the final report omits that fact.

Never give a tester:

- a repository or worktree path;
- source, tests, diffs, build logs, issue trackers, acceptance reports, known bugs, likely root causes, or prior screenshots;
- implementation names, debug architecture, expected fixes, or another tester's findings;
- permission to use filesystem, shell, Git, build, tracker, or source-search tools.

Give a tester only:

- the product name and one bounded user-facing mission;
- one exact Simulator UDID and, when necessary, the bundle identifier;
- allowed simulator observation, accessibility, tap, type, swipe, screenshot, and lifecycle controls;
- the required evidence and report schema.

Read [tester-prompt.md](references/tester-prompt.md) before spawning testers and render one prompt per mission. Do not add private orchestrator context to the template.

Before sending a rendered prompt, verify that it has no unreplaced angle-bracket placeholders, contains exactly one assigned Simulator UDID, contains no repository or worktree path, contains no known-defect or proposed-fix language, and gives one bounded user-facing mission.

## Stage the app privately

Complete these steps in the orchestrator before spawning testers:

1. Inspect repository instructions, branch, status, product contract, and protected work.
2. Discover the real Xcode project, scheme, destinations, and bundle identifier.
3. Build the current source with the project's normal simulator path.
4. Create or select an exact simulator without disturbing another task's device.
5. Reset only task-owned simulators when a clean install is required; otherwise preserve their data.
6. Install and launch the app, then verify a real frame with a screenshot.
7. Connect the accessibility bridge when the active simulator tooling requires it.
8. Preflight the tester's permitted controls for Home, terminate or cold launch, background and foreground, appearance, text size, Reduce Motion, and screenshots. Assign only states that the permitted tool surface can actually reach; keep unavailable states in the orchestrator's validation lane and name the limitation.
9. Stage synthetic or non-sensitive accounts where practical. Keep credentials, personal notifications, and unrelated personal data out of tester screenshots.

The orchestrator may use repository and build tools. Testers may not.

## Assign non-overlapping missions

Prefer these independent lanes when the product supports them:

1. **First-run and recovery:** discoverability, onboarding, permission explanation, Not Now, denial, Settings recovery, unavailable capability, clean relaunch.
2. **Returning-user behavior:** primary journeys, preferences, cancellation, repeated navigation, persistence, relaunch, background and foreground.
3. **Visual and accessibility stress:** compact layout, light and dark appearance, large text, scrolling, safe areas, contrast, touch targets, VoiceOver semantics, Reduce Motion.

Do not disclose known defects or detailed acceptance criteria. Phrase each lane as a realistic user mission using only behavior the interface itself should communicate.

## Parallelize without cross-contamination

- Assign a distinct Simulator UDID to every concurrently running tester.
- Use fresh app containers when first-run state matters.
- Never let two agents control the same simulator concurrently.
- Match each mission to the capability preflight. Do not substitute guessed edge gestures for a missing Home, lifecycle, appearance, or accessibility-setting control.
- If only one simulator is available, run testers sequentially and have the orchestrator restore the required state between them.
- Do not reuse the agent that found a defect for the final blind regression pass.

## Require observation before action

Tell testers to inspect the accessibility hierarchy before every tap and refresh it after navigation, sheets, prompts, scrolling, backgrounding, or relaunch.

If accessibility output is empty or broken:

1. Take a fresh screenshot.
2. Interact only with the visible center of a clearly identifiable control.
3. Refresh the screenshot after every state change.
4. Mark semantic accessibility coverage unverified; do not infer labels from pixels.

Never accept guessed off-screen coordinates, stale frames, loading placeholders, or scripted assertions as black-box observation.

## Require a structured report

Every tester must return a report even when blocked or partial. Each finding must include:

- ID and severity: critical, high, medium, or low;
- journey and exact action sequence;
- visible state before the action;
- expected user-visible behavior derived only from the live interface and mission;
- actual observed behavior;
- reproducibility count;
- screenshot or simulator evidence;
- whether the issue blocks further coverage.

The report must end with:

- status: `PASS`, `FAIL`, `BLOCKED`, or `PARTIAL`;
- journeys or screens completed;
- findings;
- states not verified and exact reasons;
- confidence.

Reject reports that name files, implementation symbols, source root causes, test expectations, or fixes. Ask the same agent only to restate runtime observations without contaminated content; use a fresh agent if contamination affected exploration.

## Adjudicate findings as the orchestrator

For every candidate finding:

1. Reproduce it independently on a controlled simulator.
2. Distinguish product defect, expected platform behavior, test-environment limitation, and tester misunderstanding.
3. Map confirmed behavior to the product contract and source only after reproduction.
4. Implement the smallest durable fix without weakening validation or truthfulness.
5. Run focused automated checks and relevant regression checks.
6. Restage the app on a clean simulator.
7. Send a new source-blind tester a neutral user mission that covers the behavior without revealing the prior defect.
8. Accept completion only when automated checks and independent runtime evidence agree.

Do not edit code merely because a tester suggested a cause. Code-blind reports establish symptoms, not implementation truth.

## Keep evidence truthful

Capture and inspect visual proof after accepting a runtime result when screenshots or interaction evidence materially help the handoff.

Simulator QA cannot prove real sensors, camera input, physical haptics, device-only performance or energy, signing, provisioning, or distribution. Keep those gates explicitly unverified or externally blocked. Never turn simulator coverage into a physical-device completion claim.
