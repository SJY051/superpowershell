# Reusable Skill Categories for Windows-Friendly Agents

If your agent framework supports reusable skills, prompts, playbooks, or recipes, Windows is a strong case for using them.

## Useful Categories

### Debugging discipline

Capture a repeatable debugging flow that forces:

- symptom collection
- reproduction
- evidence gathering
- root-cause tracing before changes

### Verification discipline

Capture the rule that work is not “done” until the relevant command, test, or observable result has actually been checked.

### Review checkpoints

Define when to pause for review, what scope to review, and how to frame the findings.

### Bounded delegation

If subagents exist, define when they are allowed, what output they should return, and what judgment must stay in the main thread.

### Documentation and browser extraction

Windows-heavy environments often benefit from reusable instructions for:

- extracting clean web content
- documenting shell differences clearly
- turning local quirks into stable written guidance

## Why Skills Matter On Windows

Windows usually benefits from more explicit operational memory because:

- command semantics differ from POSIX shells
- aliases may hide PowerShell-specific behavior
- installation paths vary more
- startup noise and shell-profile side effects are more common

Reusable skills help agents keep these local truths stable instead of rediscovering them every session.
