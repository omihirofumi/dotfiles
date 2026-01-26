# dotfiles

## Setup (macOS)

### Install Nix


```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

### Apply (nix-darwin + home-manager)

```sh
export USERNAME="username"
export HOSTNAME="hostname"
USERNAME=${USERNAME} HOSTNAME=${HOSTNAME} \
  nix --extra-experimental-features "nix-command flakes" \
  run github:LnL7/nix-darwin -- switch --flake github:omihirofumi/dotfiles#${HOSTNAME}
```
