{config, ...}: {
  virtualisation.docker.enable = true;
  users.users."${config.mySystem.userName}".extraGroups = ["docker"];
}
