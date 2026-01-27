---
description: Generate a fresh Product Requirements Document for a single feature sprint
allowed-tools: Read, Edit, Write
---

# Generate Single Feature Sprint PRD

Take the feature idea "$ARGUMENTS" and break it down into small, focused features. Each feature will be implemented completely in a single iteration by Ralph.

Create the sprint plan by:

1. **Analyze the feature type** - Determine category (core, api, admin, authentication, notifications, payments, etc.)

2. **Break down into small features**:
   - **Goal**: Every feature should be **S** (Small) - single model/endpoint, completable in one iteration
   - **M** (Medium) is acceptable ONLY when a feature is truly atomic and cannot be split further
   - **L** (Large) or bigger: ALWAYS break these down into multiple S features with dependencies
   - Ask yourself: "Can this be split into smaller pieces that each deliver testable value?"

3. **Identify dependencies**:
   - Does this feature require other features to exist first?
   - What foundation must be in place (migrations, models, etc.)?
   - Create separate features for dependencies if needed

4. **Write acceptance criteria** - Specific, testable requirements:
   - Each criterion should be verifiable with a test
   - Use precise language ("User can...", "System returns...", "API responds with...")
   - Avoid vague criteria ("works well", "is fast")

5. **Generate comprehensive Laravel implementation steps** (as many as needed for the feature complexity):
   - Create models and migrations for the feature
   - Implement controllers and business logic
   - Add validation, middleware, and services as needed
   - Create views, forms, or API endpoints
   - Write comprehensive tests
   - Verify functionality works end-to-end
   - Include any additional steps specific to the feature

6. **Create a single feature entry** with this JSON structure:
   ```json
   [
     {
       "id": "FEAT-001",
       "feature": "Feature Name (from arguments)",
       "category": "determined_category",
       "description": "Description of what this feature does",
       "tested": false,
       "blocked": false,
       "depends_on": [],
       "acceptance_criteria": [
         "User can perform specific action",
         "System validates input correctly",
         "API returns expected response format"
       ],
       "size": "S",
       "steps": [
         "Step 1: Implementation action",
         "Step 2: Another implementation action",
         "Step N: As many steps as needed"
       ]
     }
   ]
   ```

   **If the feature has dependencies**, create multiple entries:
   ```json
   [
     {
       "id": "FEAT-001",
       "feature": "Foundation Feature",
       "blocked": false,
       "depends_on": [],
       ...
     },
     {
       "id": "FEAT-002",
       "feature": "Main Feature",
       "blocked": true,
       "depends_on": ["FEAT-001"],
       ...
     }
   ]
   ```

7. **Replace prd.json entirely** with the new single-feature sprint plan (don't append, replace the whole file)

8. **Confirm the sprint** - Show:
   - Total features generated
   - Feature IDs, names, and sizes
   - Dependency graph (if any)
   - Which features are immediately workable (not blocked)

## Guidelines for Good PRDs

- **One feature per iteration**: Each feature must be completable in a single Ralph iteration
- **Small by default**: Target S (small) for every feature; use M only when truly atomic
- **Break it down**: If a feature feels large, split it into smaller features with dependencies
- **Atomic features**: Each feature should deliver standalone, testable value
- **Clear dependencies**: If A requires B, make it explicit
- **Testable criteria**: Every acceptance criterion maps to a test
- **Foundation first**: Infrastructure features should have no dependencies

This creates a sprint plan that Ralph works through one feature at a time, implementing each completely before moving to the next.
