{
  lib,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      bindkey -e
      WORDCHARS="$WORDCHARS//[\/:]/}"
    '';
  };
  programs.zsh.loginShellInit = lib.mkIf config.mySystem.useWSL ''
    ln -s /mnt/wslg/runtime-dir/wayland* $XDG_RUNTIME_DIR 2>/dev/null
    ln -s /mnt/wslg/runtime-dir/pulse $XDG_RUNTIME_DIR 2>/dev/null
  '';
}
