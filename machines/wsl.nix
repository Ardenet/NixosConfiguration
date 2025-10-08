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
    ./system-general.nix
  ];

  mySystem.useWSL = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";

  security.sudo.extraConfig = ''
    Defaults env_keep += "WSL2_GUI_APPS_ENABLED WSLPATH WSL_DISTRO_NAME WSL_INTEROP WSLENV TERM_PROGRAM TERM_PROGRAM_VERSION"
    Defaults env_keep += "WAYLAND_DISPLAY PULSE_SERVER XDG_RUNTIME_DIR HOSTTYPE EDITOR PAGER"
  '';
}
