{
  lib,
  starshipConfig,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = lib.importTOML starshipConfig;
  };
}
