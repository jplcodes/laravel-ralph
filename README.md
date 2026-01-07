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
| `prd.json` | Define your features here with acceptance criteria |
| `progress.txt` | Iteration log - tracks what was accomplished |

## Designing Your PRD

You can use Claude to help develop `prd.json`. Describe your project at a high level and let Claude break it down into sprint tasks. This positions you as the project designer while AI handles the detailed breakdown.

```bash
# Example: Ask Claude to generate your PRD
claude "I want to build a user authentication system with registration,
login, password reset, and email verification. Break this down into
features for prd.json with clear acceptance criteria."
```

Review and refine the generated PRD, then let Ralph execute it.

## Quick Start

1. **Define your features** in `prd.json` (or generate with Claude):

```json
[
  {
    "feature": "User Registration",
    "category": "auth",
    "description": "Allow users to create accounts",
    "tested": false,
    "steps": [
      "User submits registration form",
      "System validates input and creates user",
      "User receives confirmation email"
    ]
  }
]
```

2. **Run the loop:**

```bash
# Autonomous mode - runs until complete
./ralph.sh

# Or single iteration - review between runs
./ralph_once.sh
```

3. **Monitor progress** in `progress.txt` and watch `prd.json` as features get marked `"tested": true`.

## How It Works

Each iteration:

1. Claude reads `prd.json` to find untested features
2. Claude reads `progress.txt` to see previous work
3. Claude implements the next feature with tests
4. `composer test` runs to validate
5. If tests pass, Claude marks the feature as `"tested": true`
6. Claude appends a summary to `progress.txt`
7. Loop continues until all features are tested or max iterations reached

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

- Write clear, specific acceptance criteria in `prd.json`
- Break large features into smaller, testable pieces
- Review `progress.txt` if Claude gets stuck to understand what's been tried
- Ensure `composer test` is configured in your `composer.json`

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
