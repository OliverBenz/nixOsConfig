# nixOsConfig

NixOS + home-manager config for `oliverLpt` (Framework laptop) and `oliverPc`.
Everything declarative lives here; this README lists what is **not** (stateful, one-time steps).

## Daily use

```sh
sudo nixos-rebuild switch --flake .        # system (host picked by hostname)
home-manager switch --flake .#oliver       # user config, add -b backup if a file is in the way
nix flake update                           # update inputs, then rebuild both
sudo nixos-rebuild switch --rollback       # undo the last system switch
sudo nix-collect-garbage --delete-older-than 14d
sudo nixos-rebuild build-vm --flake .#<host>  # try a config in a VM
```

## New machine

1. Boot the NixOS installer. Keyboard: `loadkeys de`, Wi-Fi: `nmtui`. Install minimal.
   PC: format only the system NVMe, never the data disks (see `hosts/pc/storage.nix`).
2. Clone: `nix-shell -p git`, then `git clone https://github.com/<user>/nixOsConfig ~/Documents/dev/nixOsConfig`.
3. Replace `hosts/<host>/hardware-configuration.nix` with `/etc/nixos/hardware-configuration.nix`, commit.
4. `sudo nixos-rebuild switch --flake .#<host>`, then `home-manager switch --flake .#oliver -b backup`, reboot.
5. Do the one-time steps below.

## One-time steps per machine

- **SSH key:** `ssh-keygen -t ed25519 -f ~/.ssh/github`, add the `.pub` on GitHub (*Authentication key*) and Gitea.
  Then `git remote set-url origin git@github.com:<user>/nixOsConfig.git`.
- **Tailscale:** `sudo tailscale up` and log in. Needed for all `*.home` services (Gitea, Ollama, ...).
- **NordVPN:**
  ```sh
  nordvpn login --token <token>             # access token from the Nord Account website
  nordvpn set technology nordlynx
  nordvpn set autoconnect on
  nordvpn set killswitch on
  nordvpn set lan-discovery on
  nordvpn allowlist add subnet 100.64.0.0/10   # Tailscale, otherwise *.home breaks
  ```
- **Brave:** Sync (Settings → Sync → *I have a Sync Code*). Brave ignores the system CA store, so import
  `resources/caddy-root.crt` once: Settings → Privacy and security → Security → Manage certificates →
  Authorities → Import, tick *Trust this certificate for identifying websites*.
- **OneDrive:** run `onedrive --confdir ~/.config/onedrivePersonal` (and `onedriveUni`) once to authorize.
- **Wallpaper:** `$mod+Shift+w`, pick one, save. Restored on every login.

## Home server (PC)

`*.home` names resolve through Pi-hole on the PC (Tailscale DNS) to the PC; Caddy serves them with its
own CA (`tls internal`). Its root cert is in `resources/caddy-root.crt` and trusted system-wide.
It expires in 2036; then copy the new `/mnt/host/Caddy/caddy-root.crt` into `resources/`.

opencode uses the PC's Ollama via `https://ollama.home/v1`. New models: add them to `programs.opencode` in `home/home.nix`.

## Mathematica (currently disabled)

The installer must be in the store first: `nix-store --add-fixed sha256 Mathematica_<version>_BNDL_LINUX.sh`.
