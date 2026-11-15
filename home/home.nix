{ lib, pkgs, pkgs-unstable, ... }:
{
  home.username = "oliver";
  home.homeDirectory = "/home/oliver";
  home.stateVersion = "23.11"; # Release of the first install, do not bump (see home-manager release notes).

  home.packages = with pkgs; [
    ripgrep
    fd
    protonmail-desktop
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  home.file = {
    ".local/share/wallpapers".source = ../resources/wallpapers;

    # Desktop
    ".config/i3/config".source = dotfiles/i3Config;
    ".config/polybar/config.ini".source = dotfiles/polybar/config.ini;
    ".config/polybar/scripts/vpn-status.sh".source = dotfiles/polybar/scripts/vpn-status.sh;
    ".config/picom.conf".source = dotfiles/picom;

    # Vim
    ".vim/autoload/plug.vim".source = dotfiles/plug.vim;
    ".vimrc".source = dotfiles/vimrc;

    # Onedrive
    ".config/onedriveUni/config".source = dotfiles/onedriveUni;
    ".config/onedrivePersonal/config".source = dotfiles/onedrivePersonal;
    ".config/onedrive-launcher".source = dotfiles/onedrive-launcher;
  };

  # Terminal: kitty draws the window, bash runs inside, starship draws the prompt.
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    settings = {
      background_opacity = "0.9";
      window_padding_width = 4;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };

  programs.bash = {
    enable = true;
    historySize = 10000;
    historyControl = [ "ignoredups" "erasedups" ];
    shellAliases.grep = "grep --color=auto";
  };

  programs.starship.enable = true;

  # ls with icons and git status.
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
  };

  # Loads a project's dev shell on cd: put `use flake` in its .envrc, then `direnv allow`.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    initLua = builtins.readFile dotfiles/nvim/init.lua;
    # Only on nvim's PATH, so they never shadow a project's toolchain.
    extraPackages = with pkgs; [
      tree-sitter
      clang-tools # clangd
      texlab
    ];
  };

  # Merged into Zed's writable settings on each switch; values here win.
  programs.zed-editor = {
    enable = true;
    extensions = [ "catppuccin" "html" "latex" "neocmake" "nix" "powershell" ];
    userSettings = builtins.fromJSON (builtins.readFile dotfiles/zed/settings.json);
    userDebug = builtins.fromJSON (builtins.readFile dotfiles/zed/debug.json);
  };

  # Models run on the PC's Ollama, reached through Caddy (see README).
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode; # stable lags far behind
    settings = {
      model = "ollama/qwen3.6-35b-64k";
      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (PC)";
        options.baseURL = "https://ollama.home/v1";
        models = lib.genAttrs [
          "qwen3-coder-30b-32k"
          "qwen3-coder-30b-48k"
          "qwen3-8b-32k"
          "qwen3.6-35b-64k"
          "qwen3.6-35b-256k"
        ] (name: { inherit name; });
      };
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".AddKeysToAgent = "yes";
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/github";
        IdentitiesOnly = "yes";
      };
      "gitea.home" = {
        Port = 222;
        User = "git";
      };
    };
  };
  services.ssh-agent.enable = true;

  programs.home-manager.enable = true;
}
