{
  # 自动导入当前目录下所有.nix文件（排除自身）
  imports = let
    files = builtins.attrNames (builtins.readDir ./.);
    modules = builtins.filter (f: f != "default.nix") files;
  in
    map (f: ./. + "/${f}") modules;
}
