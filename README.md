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
