{inputs, ...}: {
  imports = [inputs.noctalia.nixosModules.default];

  # Enable noctalia
  services.noctalia-shell.enable = true;
}
