{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.mySystem;

  basicConfig = {
    # Enable unfree software
    nixpkgs.config.allowUnfree = true;

    # Set time zone
    time.timeZone = "Asia/Shanghai";

    # Set Chinese locale
    i18n.defaultLocale = "zh_CN.UTF-8";

    # nix settings
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = lib.mkBefore [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
      trusted-users = [
        "@wheel"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs;
      [
        ripgrep
        fd
        fastfetch
        wget
      ]
      ++ lib.optionals cfg.useWSL [wl-clipboard];

    services.openssh = {
      enable = true;
    };

    # Enable appimage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };

  vmwareConfig = {
    # start vm-tools support
    virtualisation.vmware.guest.enable = true;
  };

  realMachineConfig = {
    # Use systemd-boot
    boot.loader.systemd-boot.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    i18n = {
      defaultLocale = "zh_CN.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";

        # config fcitx5
        fcitx5 = {
          # ignore user's configuration and user dict
          # ignoreUserConfig = true;
          waylandFrontend = true;
          addons = with pkgs; [
            kdePackages.fcitx5-qt
            fcitx5-gtk
            fcitx5-chinese-addons
            fcitx5-rime

            # fcitx5 theme
            fcitx5-rose-pine
          ];
          settings = {
            inputMethod = {
              "Groups/0" = {
                Name = "默认";
                "Default Layout" = "us";
                DefaultIM = "shuangpin";
              };
              "Groups/0/Items/0" = {
                Name = "keyboard-us";
              };
              "Groups/0/Items/1" = {
                Name = "shuangpin";
              };
              "Groups/1" = {
                Name = "Rime";
                "Default Layout" = "us";
                DefaultIM = "rime";
              };
              "Groups/1/Items/0" = {
                Name = "rime";
              };
              GroupOrder = {
                "0" = "Rime";
                "1" = "默认";
              };
            };
            globalOptions = {
              Hotkey = {
                EnumerateWithTriggerKeys = "True";
              };
              "Hotkey/TriggerKeys" = {
                "0" = "Super+space";
              };
              "Hotkey/EnumerateBackwardKeys" = {
                "0" = "Control+Shift+Shift_L";
              };
              "Hotkey/EnumerateGroupBackwardKeys" = {
                "0" = "Alt+Shift+Shift_L";
              };
              Behavior = {
                DefaultPageSize = 7;
                showInputMethodInformationWhenFocusIn = "True";
              };
            };
            addons = {
              piyin.globalSection = {
                shuangpinProfile = "Xiaohe";
              };
              rime.globalSection = {
                InputState = "No";
                SwitchInputMethodBehavior = "Commit raw input";
              };
              classicui.globalSection = {
                "Vertical Candidate List" = "True";
                Font = "Sans 10";
                PreferTextIcon = "True";
                Theme = "rose-pine-dawn";
                DarkTheme = "rose-pine";
                UseDarkTheme = "True";
              };
              clipboard.globalSection = {
                "Number of entries" = 10;
              };
              notifications.globalSection = {};
              notifications.sections.HiddenNotifications = {
                "0" = "enumerate-group";
              };
            };
          };
        };
      };
    };

    # Set font
    fonts = {
      packages = with pkgs; [
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        nerd-fonts.comic-shanns-mono
        nerd-fonts.symbols-only
        vista-fonts-chs
      ];
      fontconfig = {
        defaultFonts = {
          serif = [
            "DejaVu Serif"
            "Noto Serif CJK SC"
            "Symbols Nerd Font"
          ];
          sansSerif = [
            # "DejaVu Sans"
            "ComicShannsMono Nerd Font"
            "Noto Sans CJK SC"
            "Symbols Nerd Font"
          ];
          monospace = [
            "DejaVu Sans Mono"
            "Noto Sans Mono CJK"
            "Symbols Nerd Font Mono"
          ];
        };
      };
    };
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORMTHEME="gtk3";
      };
      systemPackages = with pkgs; [
        kitty
        fuzzel
        # mako
        # swaybg
        nautilus
        xwayland-satellite
        wechat
        wemeet
        chromium
        baobab
        obs-studio
        mission-center

        # gtk theme
        papirus-icon-theme
        bibata-cursors
      ];
    };
    # add ssh authorizedkeys for root
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjP9+JmLtoc1S5tCKOb+4l8liTRBCRpbykQCcKl5Vqp test@vmware.nixos"
    ];

    # add normal user
    users.users."${cfg.userName}" = {
      description = "Default User";
      isNormalUser = true;
      hashedPassword = "$y$j9T$i80BPPSQbFC86C4drF2oW.$7XC90HzGEm7oXIrGENA90cCZ0z6fRB8kAlYRLVkyjX1";
      extraGroups = [
        "wheel"
        "audio"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjP9+JmLtoc1S5tCKOb+4l8liTRBCRpbykQCcKl5Vqp test@vmware.nixos"
      ];
    };

    # disable legacy linux user mange
    users.mutableUsers = false;

    # Enable the X11 windowing system.
    # services.xserver.enable = true;

    # Configure keymap in X11
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
    security.rtkit.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    # Enable transh support for nautilus
    services.gvfs.enable = true;

    # Enable clipboard manager
    services.clipcat.enable = true;

    # Enable power manager
    services.upower.enable = true;

    # Enable niri
    programs.niri.enable = true;

    # Enable nautilus extension 'open with terminal'
    programs.nautilus-open-any-terminal.enable = true;

    # Enable nautilus extension for file preview
    services.gnome.sushi.enable = true;

    # Install and configure regreet
    programs.regreet = {
      enable = true;
      theme = {
        name = "Orchis";
        package = pkgs.orchis-theme;
      };
    };

    # configure greetd with niri and regreet
    services.greetd.settings.default_session = {
      command = with config.programs; let
        niri-regreet = pkgs.writeText "niri-regreet.kdl" ''
          spawn-at-startup "${lib.getExe pkgs.bash}" "-c" "${lib.getExe regreet.package};${lib.getExe niri.package} msg action quit -s"
          window-rule {
              match title="regreet"
              match app-id="regreet"
              open-fullscreen true
          }
          binds {
              Mod+Shift+Slash { show-hotkey-overlay; }
              Mod+Shift+E { quit; }
              Mod+Shift+Q { spawn "poweroff"; }
              Mod+Shift+R { spawn "reboot"; }
          }
          hotkey-overlay {
              skip-at-startup
          }'';
      in "${lib.getExe niri.package} -c ${niri-regreet}";
    };

    # Install waybar
    # programs.waybar.enable = true;

    # Set swaybg's systemd service
    # systemd.user.services.swaybg = {
    #   partOf = [
    #     "graphical-session.target"
    #   ];
    #   requisite = [
    #     "graphical-session.target"
    #   ];
    #   after = [
    #     "graphical-session.target"
    #   ];
    #   wantedBy = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = ''${lib.getExe pkgs.swaybg} -m fill -i "''${HOME}/Pictures/Wallpapers/AC_eager.jpeg"'';
    #     Restart = "on-failure";
    #   };
    # };

    # soteria polkit
    security.soteria.enable = true;

    # Install and configure chromium
    programs.chromium = {
      enable = true;
    };

    # Install firefox
    # programs.firefox.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # configure dconf
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true; # prevents overriding
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Orchis";
            cursor-theme = "Bibata-Modern-Ice";
            icon-theme = "Papirus";
          };
        };
      }
    ];
  };
in {
  imports = [../programs];

  options.mySystem = {
    useWSL = lib.mkEnableOption "Whether enable configurations about wsl and disable configurations about hardware";
    useVmware = lib.mkEnableOption "Whether enable vmware's related configurations";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "ardenet";
      description = "Some modules are configured for specific user";
    };
  };

  config = lib.mkMerge [
    basicConfig
    (lib.mkIf cfg.useVmware vmwareConfig)
    (lib.mkIf (!cfg.useWSL) realMachineConfig)
  ];
}
