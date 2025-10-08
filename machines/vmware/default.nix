{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # system-specific configuration
    ./hardware-configuration.nix
    ../system-general.nix
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "24.11";

  networking.hostName = "Centaurus"; # Define your hostname.

  mySystem.useVmware = true;
}
