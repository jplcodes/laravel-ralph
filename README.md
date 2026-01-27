# Laravel Ralph Template

A template for using the [Ralph Wiggum technique](https://ghuntley.com/ralph/) for AI-assisted Laravel development with [Claude Code](https://claude.com/claude-code).

## What is Ralph?

Ralph is an iterative AI development methodology created by Geoffrey Huntley. It repeatedly runs an AI coding agent with the same prompt, allowing the agent to see its previous work and iteratively improve until tests pass.

The technique is named after Ralph Wiggum from The Simpsons—embodying persistent iteration despite setbacks.

## Files

| File | Purpose |
|------|---------|
| `ralph.sh` | Autonomous loop - runs until all features pass tests |
| `ralph_once.sh` | Single iteration - for human-in-the-loop workflow |
| `PROMPT.md` | Instructions for Claude on how to work through the PRD |
| `prd.json` | Define your features here with dependencies and acceptance criteria |
| `progress.txt` | Iteration log - tracks what was accomplished |
| `GOALS.md` | (Optional) High-level project goals and architectural decisions |

## Key Features

### Strategic Feature Selection

Ralph doesn't just pick the next untested feature—it analyzes all features and selects the optimal one based on:

1. **Dependencies resolved** - Blocked features are skipped
2. **Foundation first** - Infrastructure before business logic
3. **Unblocking power** - Prefer features that unblock multiple others
4. **User-verifiable** - Prioritize features users can manually test

### Test-Driven Development (TDD)

Every feature follows the TDD workflow:

1. **Red** - Write failing tests first based on acceptance criteria
2. **Green** - Implement minimal code to pass tests
3. **Refactor** - Clean up while keeping tests green
4. **Regression check** - Run full test suite

### Dependency Management

Features can declare dependencies on other features:

```json
{
  "id": "FEAT-002",
  "depends_on": ["FEAT-001"],
  "blocked": true
}
```

When FEAT-001 completes, Ralph automatically unblocks FEAT-002.

## PRD Schema

Use the `/prd` command or manually create features with this structure:

```json
[
  {
    "id": "FEAT-001",
    "feature": "User Registration",
    "category": "auth",
    "description": "Allow users to create accounts",
    "tested": false,
    "blocked": false,
    "depends_on": [],
    "acceptance_criteria": [
      "User can submit registration form with email and password",
      "System validates email format and password strength",
      "User receives confirmation email after registration",
      "Duplicate emails are rejected with appropriate error"
    ],
    "size": "M",
    "steps": [
      "Create User model and migration",
      "Implement registration controller",
      "Add validation rules",
      "Set up email verification",
      "Write feature tests"
    ]
  }
]
```

### Schema Fields

| Field | Required | Description |
|-------|----------|-------------|
| `id` | Yes | Unique identifier (e.g., "FEAT-001") for dependency tracking |
| `feature` | Yes | Feature name |
| `category` | Yes | Category (core, api, auth, admin, etc.) |
| `description` | Yes | What the feature does |
| `tested` | Yes | Set to `true` when tests pass |
| `blocked` | Yes | Set to `true` if dependencies aren't met |
| `depends_on` | Yes | Array of feature IDs this depends on |
| `acceptance_criteria` | Yes | Testable requirements (maps to tests) |
| `size` | Yes | S (target) or M (only if atomic); L+ should be broken down |
| `steps` | Yes | Implementation steps |

### Feature Sizes

| Size | Description | Recommendation |
|------|-------------|----------------|
| S | Single model/endpoint | **Target size** - break features down to this |
| M | Multiple related changes | Only when truly atomic and can't be split |
| L+ | Larger features | **Always break into smaller S features** |

## Designing Your PRD

Use the built-in `/prd` command to generate sprint plans:

```bash
# Generate a sprint plan for any feature idea
/prd user authentication system
/prd payment processing with Stripe
/prd admin dashboard for content management
```

The `/prd` command will:
- Analyze your feature idea and identify dependencies
- Break down into small (S) features wherever possible
- Generate testable acceptance criteria
- Create proper dependency relationships
- Replace `prd.json` with the new sprint plan

## Quick Start

1. **Define your features** using the `/prd` command or manually in `prd.json`

2. **(Optional) Create GOALS.md** for high-level context:

```markdown
# Project Goals

## Vision
Brief description of what the project aims to achieve.

## Architectural Decisions
- Database: PostgreSQL with Redis caching
- API: RESTful with Laravel Resources
- Auth: Laravel Sanctum for API tokens
```

3. **Run the loop:**

```bash
# Autonomous mode - runs until complete
./ralph.sh

# Or single iteration - review between runs
./ralph_once.sh
```

4. **Monitor progress** in `progress.txt` and watch `prd.json` as features get marked `"tested": true`.

## How It Works

Each iteration:

1. **Pre-flight check** - Run existing tests to catch regressions
2. **Feature selection** - Analyze dependencies, select optimal unblocked feature
3. **TDD implementation** - Write tests first, then implement
4. **Verification** - Run full test suite
5. **Status update** - Mark feature tested, unblock dependent features
6. **Progress log** - Append summary to `progress.txt`
7. **Stop** - One feature per iteration keeps context focused

## Options

```bash
# Run with defaults (50 iterations)
./ralph.sh

# Set max iterations
./ralph.sh -n 100
./ralph.sh --max-iterations 100

# Show help
./ralph.sh --help

# Single iteration (human-in-the-loop)
./ralph_once.sh
```

## When to Use Each Mode

**`ralph.sh` (autonomous)** - Best for:
- Well-defined features with clear acceptance criteria
- Greenfield development you can walk away from
- Tasks with strong test coverage

**`ralph_once.sh` (human-in-the-loop)** - Best for:
- Complex features requiring human judgment
- When you want to review changes between iterations
- Debugging or fine-tuning the approach

## Tips

- Write specific, testable acceptance criteria
- Break features down to S (small) size; use M only when atomic
- Use dependencies to ensure proper build order
- Review `progress.txt` if Claude gets stuck
- Check `GOALS.md` for architectural guidance during ambiguous decisions

## Requirements

- [Claude Code CLI](https://claude.com/claude-code)
- Laravel project with `composer test` defined in `composer.json`

Example `composer.json` scripts section:

```json
{
  "scripts": {
    "test": "php artisan test"
  }
}
```

## References

- [Original Ralph technique](https://ghuntley.com/ralph/)
- [Claude Code Ralph Wiggum plugin](https://github.com/anthropics/claude-code/blob/main/plugins/ralph-wiggum/README.md)
