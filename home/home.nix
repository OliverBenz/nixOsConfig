{ pkgs, ... }:
{
  home.username = "oliver";
  home.homeDirectory = "/home/oliver";
  home.stateVersion = "23.11"; # Release of the first install, do not bump (see home-manager release notes).

  home.packages = with pkgs; [
    ripgrep
    fd
  ];

  home.file = {
    ".local/share/wallpapers".source = ../resources/wallpapers;

    # Desktop
    ".config/i3/config".source = dotfiles/i3Config;
    ".config/polybar/config.ini".source = dotfiles/polybar/config.ini;
    ".config/polybar/scripts/vpn-status.sh".source = dotfiles/polybar/scripts/vpn-status.sh;
    ".config/polybar/scripts/net-conn.sh".source = dotfiles/polybar/scripts/net-conn.sh;
    ".config/picom.conf".source = dotfiles/picom;

    # Vim
    ".vim/autoload/plug.vim".source = dotfiles/plug.vim;
    ".vimrc".source = dotfiles/vimrc;

    # Onedrive
    ".config/onedriveUni/config".source = dotfiles/onedriveUni;
    ".config/onedrivePersonal/config".source = dotfiles/onedrivePersonal;
    ".config/onedrive-launcher".source = dotfiles/onedrive-launcher;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    initLua = builtins.readFile dotfiles/nvim/init.lua;
    # Only on nvim's PATH, so they never shadow a project's toolchain.
    extraPackages = with pkgs; [
      tree-sitter
      clang-tools # clangd
      texlab
    ];
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
