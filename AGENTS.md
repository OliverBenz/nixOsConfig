# AGENTS.md — NixOS Flake Config

Hosts `oliverLpt` (Framework laptop) and `oliverPc` share `system/` and add `hosts/<host>/`.
Home-manager is standalone (`homeConfigurations.oliver`, `home/`), dotfiles in `home/dotfiles/` linked via `home.file`.

```bash
sudo nixos-rebuild switch --flake .#oliverLpt   # or .#oliverPc
home-manager switch --flake .#oliver
```

## Working here

- New files are invisible to the flake until `git add`ed.
- Check changes by evaluating only: `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`. Don't build or switch (slow, needs sudo); the user does that.
- The PC's current Manjaro setup is the target; older content in this repo is not authoritative.

## Rules

- **Keep it minimal.** Prefer existing packages/options/modules over custom scripts. No comments unless the context is non-obvious.
- **Cross-user/system things in `system/`** (services, drivers, fonts, firewall, VPN, rescue tools like vim/git). **Personal tools and dotfiles in `home/`.**
- **Hardware/driver config in `hosts/<host>/`**, everything else shared.
- **`pkgs-unstable`** only when stable nixpkgs lacks the package.
- **Never edit or share `hardware-configuration.nix`**; it is generated per machine. PC data disks live in `hosts/pc/storage.nix`.
- **Don't bump `stateVersion`** (system or home).
- **Never put secrets in the repo** (`/nix/store` is world-readable). SSH keys and the NordVPN login stay stateful on the machine.
- Firewall stays on. The SSH daemon stays off until explicitly requested.
