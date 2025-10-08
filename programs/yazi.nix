{inputs, ...}: {
  programs.yazi = {
    enable = true;
    settings = {
      yazi = {
        mgr = {
          sort_by = "size";
          show_hidden = true;
          linemode = "size";
          scrolloff = 3;
        };
        preview = {
          wrap = "yes";
          tab_size = 4;
        };
      };
      theme = {
        flavor = {
          dark = "dracula";
          light = "dracula";
        };
      };
    };
    flavors = {
      "dracula.yazi" = with inputs; "${yaziFlavors}/dracula.yazi";
    };
  };
}
