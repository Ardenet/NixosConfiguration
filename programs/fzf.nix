{
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  environment.variables = {
    FZF_DEFAULT_OPTS = ''
      --color=fg:#f8f8f2,fg+:#f8f8f2,bg:#282a36,bg+:#44475a \
      --color=hl:#bd93f9,hl+:#50fa7b,info:#ffb86c,marker:#ff79c6 \
      --color=prompt:#50fa7b,spinner:#ffb86c,pointer:#ff79c6,header:#6272a4 \
      --color=border:#BD93F9,preview-bg:#1e1f25,label:#aeaeae,query:#ff5555 \
      --border='rounded' --preview-window='border-double' \
      --marker='◈' --pointer='❯' --separator='─' --scrollbar='│' --prompt='❯ ' \
      --layout='reverse' --height 50% \
      --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'\
    '';
  };
}
