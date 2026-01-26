# dotfiles

## Setup (macOS)

### Install Nix


```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

### Apply (nix-darwin + home-manager)

```sh
./bin/switch.sh
```

If you prefer running the command manually, keep `--impure` so env vars are read:

```sh
USERNAME="username" HOSTNAME="hostname" \
  nix --extra-experimental-features "nix-command flakes" \
  run github:LnL7/nix-darwin -- switch --flake github:omihirofumi/dotfiles#${HOSTNAME} --impure
```
