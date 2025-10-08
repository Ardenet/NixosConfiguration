{
  lib,
  config,
  ...
}: {
  # 自动导入当前目录下所有.nix文件（排除自身）
  imports = let
    filteredList = ["default.nix"];
    files = builtins.attrNames (builtins.readDir ./.);
    modules = builtins.filter (file: !((f: lib.any (pattern: lib.hasInfix pattern f) filteredList) file)) files;
  in
    map (f: ./. + "/${f}") modules;
}
