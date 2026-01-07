---
description: Generate a fresh Product Requirements Document for a single feature sprint
allowed-tools: Read, Edit, Write
---

# Generate Single Feature Sprint PRD

Take the feature idea "$ARGUMENTS" and create a focused sprint plan by:

1. **Analyze the feature type** - Determine category (core, api, admin, authentication, notifications, payments, etc.)

2. **Generate comprehensive Laravel implementation steps** (as many as needed for the feature complexity):
   - Create models and migrations for the feature
   - Implement controllers and business logic
   - Add validation, middleware, and services as needed
   - Create views, forms, or API endpoints
   - Write comprehensive tests
   - Verify functionality works end-to-end
   - Include any additional steps specific to the feature

3. **Create a single feature entry** with this JSON structure:
   ```json
   [
     {
       "feature": "Feature Name (from arguments)",
       "category": "determined_category",
       "description": "Description of what this feature does",
       "tested": false,
       "steps": [
         "Step 1: Implementation action",
         "Step 2: Another implementation action",
         "Step N: As many steps as needed"
       ]
     }
   ]
   ```

4. **Replace prd.json entirely** with the new single-feature sprint plan (don't append, replace the whole file)

5. **Confirm the sprint** - Show the feature name, category, and total number of steps for this focused sprint

This creates a dedicated sprint focused on implementing one feature completely, replacing any previous PRD content to maintain focus.