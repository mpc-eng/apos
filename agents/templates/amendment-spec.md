# Amendment Spec Template

> Used by [SPEC] agent in `amendment` mode. Amendment specs are scoped changes to existing features, not full rewrites.

## Structure

```markdown
# Amendment: <Parent Feature Name> (Amendment <N>)

**Parent Spec:** specs/<NNN>-<parent-slug>.md
**Amendment Number:** <N> (max 3 convergent / 2 divergent per feature)
**Sprint Retro Source:** Sprint <N> retro, approved <date>
**Status:** Draft
**Priority:** Inherited from parent (P0/P1/P2)

---

## Root Cause

<1-2 sentences from the Sprint Retro explaining why this amendment is needed, grounded in user feedback>

## Changes to Existing ACs

### Modified ACs

- [ ] AC-<NNN> (modified): <New testable statement>
  - **Was:** <Original AC text>
  - **Reason:** <Why the change is needed>
  - **Rationale:** <1-2 sentences from sprint feedback explaining the specific user behaviour that triggered this change and what the fix scope is>

### New ACs

- [ ] AC-<NNN>: <New testable statement>
  - **Reason:** <What user problem this addresses>
  - **Rationale:** <1-2 sentences from sprint feedback explaining WHY this change is needed, what specific user behaviour triggered it, and what the fix scope is — so the CODE agent understands the intent, not just the requirement>

### Removed ACs

- [ ] AC-<NNN> (removed): <Original AC text>
  - **Reason:** <Why removal improves the feature>

## Inherited ACs (unchanged)

All other ACs from the parent spec remain in force. The Code Agent must
not break any inherited AC while implementing this amendment. The Test
Agent must verify all inherited ACs still pass (regression check).

Inherited ACs: AC-001 through AC-<last unchanged AC>
(excluding any ACs listed as modified or removed above)

## Privacy & Capabilities Changes

<If the amendment changes required APIs or capabilities, list them here.
If no changes, state "No changes to parent spec's privacy & capabilities.">

## Design Notes

<Any UX/UI specifics for the amended interactions, referencing
DESIGN_BRIEF.md>
```

## Naming Convention

`specs/<NNN>-<parent-slug>-amend-<N>.md`

Examples:
- `specs/001-escalating-friction-amend-1.md`
- `specs/002-intent-based-unlock-amend-1.md`
- `specs/002-intent-based-unlock-amend-2.md`

## Rules

1. Maximum 3 AC changes per amendment (modified + added + removed combined)
2. Maximum 3 convergent amendments (different root causes) or 2 divergent amendments (same root cause) per parent feature
3. New AC numbers continue from the parent spec's last AC number
4. Inherited ACs must not be broken — the Review Agent verifies regression
5. Amendment specs do NOT include a Wow Moment Decision Tree — they inherit from the parent spec
6. Amendment specs do NOT include an Overview or User Stories section — the parent spec provides this context
