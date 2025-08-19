# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./programs
  ];

  wsl.enable = true;
  wsl.defaultUser = "ardenet";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";

  # Set time zone
  time.timeZone = "Asia/Shanghai";

  # Set Chinese locale
  i18n.defaultLocale = "zh_CN.UTF-8";

  # Open the flakes feature
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = lib.mkBefore [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    trusted-users = [
      "@wheel"
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    ripgrep
    wl-clipboard
    fd
    fastfetch
    wget
  ];

  services.openssh = {
    enable = true;
  };

  security.sudo.extraConfig = ''
    Defaults env_keep += "WSL2_GUI_APPS_ENABLED WSLPATH WSL_DISTRO_NAME WSL_INTEROP WSLENV TERM_PROGRAM TERM_PROGRAM_VERSION"
    Defaults env_keep += "WAYLAND_DISPLAY PULSE_SERVER XDG_RUNTIME_DIR HOSTTYPE EDITOR PAGER"
  '';
}
