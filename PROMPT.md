# Task

Implement ONE feature from `prd.json` using TDD, then stop.

## Pre-Flight Check

Before implementing any feature:

1. **Run existing tests** to verify the codebase is healthy:
   ```bash
   composer test
   ```
   - If tests fail, fix them FIRST before proceeding
   - This catches regressions from previous iterations

2. **Read supporting documentation** (if they exist):
   - `GOALS.md` - High-level project goals and architectural decisions
   - `progress.txt` - What was accomplished in previous iterations

## Feature Selection

Read `prd.json` and select the OPTIMAL feature to implement next:

### Selection Criteria (in priority order)

1. **Not blocked** - `"blocked": false` or has no unmet dependencies
2. **Foundation first** - Prefer infrastructure/migrations before business logic
3. **Unblocking power** - Prefer features that unblock multiple other features
4. **User-verifiable** - Features users can manually test catch PRD gaps early

### Selection Process

1. Filter to features where `"tested": false` AND `"blocked": false`
2. Check `depends_on` arrays - skip features with incomplete dependencies
3. Score remaining features by unblocking power (count how many features depend on each)
4. Select the highest-scoring unblocked feature
5. If tied, prefer foundation/infrastructure over business logic

## TDD Implementation Workflow

Follow Test-Driven Development strictly:

### TDD Done Right (No Cheating)

The goal of TDD is to build **real, working functionality** that a user could actually use. Do NOT:
- Write tests that pass without real implementation (e.g., returning hardcoded values)
- Mock your own application code (controllers, models, services) - test them for real
- Modify tests to make them easier to pass instead of fixing the implementation
- Write trivial tests that don't actually verify the acceptance criteria
- Skip testing edge cases or error handling described in the acceptance criteria

DO:
- Write tests that would fail if the feature didn't actually work
- Implement real business logic, database operations, and API endpoints
- Mock external dependencies (third-party APIs, payment gateways, email services) - these are appropriate to mock
- Ensure a user could manually verify the feature works after implementation

### 1. Red Phase - Write Failing Tests First

- Read the feature's `acceptance_criteria` carefully
- Write tests that verify EACH acceptance criterion
- Tests must exercise real functionality (HTTP requests, database queries, etc.)
- Run tests to confirm they FAIL (this validates your tests are meaningful)
- Do not write implementation code yet

### 2. Green Phase - Minimal Implementation

- Write the MINIMUM code needed to make tests pass
- "Minimal" means no unnecessary extras, NOT cutting corners on the actual feature
- Implement real controllers, models, migrations, and business logic
- Follow Laravel conventions and existing patterns in the codebase
- Run tests after each significant change
- Stop as soon as tests pass - resist the urge to add more

### 3. Refactor Phase - Clean Up While Green

- Improve code structure without changing behavior
- Run tests after each refactor to ensure they still pass
- Apply SOLID principles where appropriate
- Remove duplication if any emerged

### 4. Regression Check

- Run full test suite: `composer test`
- ALL tests must pass (not just the new ones)
- If regressions occur, fix them before proceeding

## Post-Implementation Tasks

After all tests pass:

### 1. Update Feature Status

In `prd.json`, update the completed feature:
```json
{
  "tested": true
}
```

### 2. Analyze Dependencies

Review remaining untested features in `prd.json`:
- For each feature with `depends_on` containing the completed feature's ID
- Check if ALL dependencies are now met (`"tested": true`)
- If all dependencies met, update: `"blocked": false`

### 3. Update Progress Log

Append to `progress.txt`:
- Feature ID and name completed
- What was implemented (brief summary)
- Test results (count: X passed)
- Any discoveries (new requirements, PRD gaps, blockers found)
- Which features are now unblocked (if any)

## Constraints

- Follow Laravel conventions and best practices
- Use existing patterns found in this codebase
- Write tests for ALL new functionality
- Do not break existing tests
- Only mark a feature as `"tested": true` after ALL its tests pass
- Features marked `"blocked": true` must NOT be selected

## Completion

**STOP** after implementing ONE feature successfully. Each feature should be implemented in a separate session to keep context focused.

The project is complete when all features in `prd.json` have `"tested": true`.

## If Stuck

After multiple failed attempts on a feature:

1. Document the specific blocker in `progress.txt`
2. Check if there's an alternative approach
3. Consider if dependencies are truly met
4. Simplify the implementation if needed
5. If blocked by external factors, mark the feature with a note and try the next unblocked feature
