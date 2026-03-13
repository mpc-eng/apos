# Contributing to APOS

Thanks for your interest in contributing to APOS! This document covers the process for contributing to this project.

## Developer Certificate of Origin (DCO)

This project uses the [Developer Certificate of Origin](https://developercertificate.org/) (DCO). All contributors must sign off on their commits to certify they have the right to submit the code under this project's license.

### How to sign off

Add a `Signed-off-by` line to every commit message:

```
Signed-off-by: Your Name <your.email@example.com>
```

You can do this automatically by committing with the `-s` flag:

```bash
git commit -s -m "Your commit message"
```

The sign-off must use your real name (not a pseudonym) and a valid email address.

### What the DCO means

By signing off, you certify that you wrote the contribution (or have the right to submit it) and that you're submitting it under the project's Apache 2.0 license. The full text is in the [DCO](DCO) file.

## What we accept

| Contribution type | Process |
|---|---|
| Bug fixes | Open a PR directly |
| Documentation improvements | Open a PR directly |
| New agent definitions | Open a Discussion first |
| Schema changes | Open a Discussion first |
| New pipeline stages | Open a Discussion first |
| Architecture changes | Open a Discussion first |

APOS has strong opinions about its pipeline architecture, agent patterns, and schema conventions. For anything beyond bug fixes and docs, **open a Discussion before writing code** — this prevents wasted effort and gives us a chance to align on approach.

## How to contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b my-feature`)
3. Make your changes
4. Commit with sign-off (`git commit -s -m "Add my feature"`)
5. Push to your fork (`git push origin my-feature`)
6. Open a Pull Request

## Code conventions

- Agent outputs are JSON validated against schemas in `agents/schemas/`
- All schemas use JSON Schema draft-07 (schema_version in `state.json`)
- Agent definitions live in `.claude/agents/` and follow the core + platform overlay pattern
- Slash commands live in `.claude/commands/`
- CLAUDE.md is routing and overview only — enforcement rules belong in agent definitions

## What makes a good PR

- Focused on a single change (don't bundle unrelated fixes)
- Includes a clear description of *why* the change is needed
- Doesn't break existing schema contracts
- Follows existing patterns rather than introducing new ones

## License

By contributing, you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE).
