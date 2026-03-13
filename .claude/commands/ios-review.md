Run the IOS-REVIEW spec gate.

Read the agent definition at `.claude/agents/ios-review-agent.md` and follow its instructions exactly.

Find all spec files in `specs/` (up to 5 in batch mode) and review each for:
1. AC Testability — rewrite untestable ACs with xctest_assertion_type
2. Privacy Manifest — detect required-reason APIs, check PrivacyInfo.xcprivacy
3. Entitlement Flags — verify capability declarations
4. HIG Flags — flag Human Interface Guideline deviations

Write output to `approvals/pending/ios-review-output.json` validated against `agents/schemas/ios-review-output.schema.json`.
