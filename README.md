# dotfiles

## Setup (macOS)

### Install mise

Install `mise` yourself before bootstrapping this repository.

```sh
curl https://mise.run | sh
```

### Bootstrap (mise)

Use mise bootstrap from this repository for Homebrew formulae/casks,
dotfiles, tools, and user-level macOS defaults:

```sh
mise trust
mise bootstrap --yes --force-dotfiles --skip packages,tools,task
mise bootstrap --yes
```

To inspect the changes first:

```sh
mise bootstrap --dry-run
```

## Shared agent rules

Edit `.config/agents/AGENTS.md` to update user-level rules for both Codex and
Claude. Bootstrap links `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` to this
same file. Repository-level `AGENTS.md` and `CLAUDE.md` remain separate.

The old source paths remain as compatibility symlinks, so existing home
directory links also pick up the shared rules. Files under `.claude/rules/`
are empty migration placeholders for older links; their rules are now in
the shared file.
