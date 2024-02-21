{pkgs, user, ...}: {
  
  imports = [
    ./hardware-configuration.nix
  ];

  documentation.nixos.enable = false;

  nix = {
    settings = {
      warn-dirty = false;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  boot = {
    kernelParams = ["nohibernate"];
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["ntfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        enable = true;
        useOSProber = true;
        timeoutStyle = "menu";
      };
      timeout = 300;
    };
    # @tcp_bbr is a kernel module that provides a new congestion control algorithm
    kernelModules = ["tcp_bbr"];
    kernel.sysctl = { 
      # Enable BBR
      "net.ipv4.tcp_congestion_control" = "bbr";
      # fq is the default queue discipline
      "net.core.default_qdisc" = "fq";
      # Increase the maximum number of memory pages that can be locked into memory
      "net.core.wmem_max" = 1073741824; # 1GB
      "net.core.rmem_max" = 1073741824; # 1GB
      # Increase the default and maximum sizes of the receive and send buffers
      "net.ipv4.tcp_rmem" = "4096 87380 1073741824"; # 4KB min, 87KB default, 1GB max
      "net.ipv4.tcp_wmem" = "4096 87380 1073741824"; # 4KB min, 87KB default, 1GB max
    };
  };

  networking = {
    hostName = "nixos-studio";
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    keyMap = "trq"; # or tr 
    useXkbConfig = true;
  };

  services = {
    flatpak.enable = true;
    dbus.enable = true;
    picom.enable = true;

    xserver = {
      enable = true;
      #windowManager.dwm.enable = true;
      windowManager.qtile.enable = true;
      layout = "tr";

      displayManager = {
        lightdm.enable = true;
        setupCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary --rate 143.97 --mode 2560x1440 --rotate normal \
       --output HDMI-0 --rate 59.79 --mode 1366x768 --rotate normal --right-of DP-2 \
       --output DP-0 --mode 1920x1080 --pos 0x0 --rate 60 --rotate normal --left-of DP-2 \
        '';
        autoLogin = {
          enable = true;
          user = "cyber-syntax";
        };
      };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
     #dwm = prev.dwm.overrideAttrs (old: {src = /home/${user}/CTT-Nix/system/dwm-titus;}); #FIX ME: Update with path to your dwm folder
     qtile = prev.qtile.overrideAttrs (old: {src = /home/${user}/qtile;});
     #Path to the qtile configuration file. If null, $XDG_CONFIG_HOME/qtile/config.py will be used.
    })
  ];

  users.users.cyber-syntax = {
    isNormalUser = true;
    description = "cyber-syntax";
    extraGroups = [
      "flatpak"
      "disk"
      "qemu"
      "kvm"
      "libvirtd"
      "sshd"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "root"
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override {fonts = ["Meslo"];})
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  virtualisation.libvirtd.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  system.stateVersion = "23.11";
}
