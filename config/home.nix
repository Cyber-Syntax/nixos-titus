{pkgs, ...}: let
  username = "cyber-syntax";
in {
  imports = [
    ./packages
  ];

  fonts.fontconfig.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";

    packages = with pkgs; [
      keepassxc
      playerctl
      gammastep
      telegram-desktop
      freetube
      nuclear
      backintime
      ungoogled-chromium
      tutanota-desktop
      xournalpp
      calibre
      #gnome.seahorse # if nixos didn't install via gnome.keyring.enabled... setting.
      syncthing
      vim
      wget
      neofetch
      neovim
      #clang-tools_9
      dunst
      efibootmgr
      #eww
      feh
      #swaybg # if you use wayland, wallpaper setter - also dependencie for my script
      flameshot
      flatpak
      firefox
      fontconfig
      freetype
      fuse-common
      gcc
      gimp
      git
      gnome.gnome-keyring
      gnumake
      gparted
      gnugrep
      grub2
      kitty
      libverto
      luarocks
      lxappearance
      nfs-utils
      ninja
      openssl
      os-prober
      nerdfonts
      pavucontrol
      picom
      polkit_gnome
      python3Full
      python.pkgs.pip
      qemu
      #ripgrep # ripgrep = 
      rofi
      sxhkd # simple x hotkey daemon e
      #swaycons
      terminus-nerdfont
      tldr # man page driven from community
      trash-cli # for easy file deletion
      unzip
      virt-manager
      xclip
      xdg-desktop-portal-gtk
      xfce.thunar
      xorg.libX11
      xorg.libX11.dev
      xorg.libxcb
      xorg.libXft
      xorg.libXinerama
      xorg.xinit
      xorg.xinput
      zoxide # for easy directory navigation
    ];
  };
}
