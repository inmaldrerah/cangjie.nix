{ pkgs, ... }:
let
  lib = pkgs.lib;
  replaceDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch ) str;
  makeCangjiePkg = { cjver, ... }@args: let
    dotlessVer = replaceDots cjver;
  in rec {
    "cangjie-${dotlessVer}" = pkgs.callPackage ./cangjie.nix args;
  };
  makeCangjiePkgs = argList: lib.mergeAttrsList (map makeCangjiePkg argList);
  cangjiePkgs = makeCangjiePkgs [
    {
      cjver = "202507212144";
      cjsrcs = [
        (builtins.fetchGit {
          name = "cangjie-compiler";
          url = "ssh://git@gitcode.com/Cangjie/cangjie-compiler.git";
          ref = "release-cangjie-202507212144";
          rev = "623d6980f63fb8973a9de897c75be735f8f90918";
        })
        (builtins.fetchGit {
          name = "cangjie-runtime";
          url = "ssh://git@gitcode.com/Cangjie/cangjie-runtime.git";
          ref = "release-cangjie-202507212144";
          rev = "f48eec88592c09cd98d33d338b4de4ee0ba38b1b";
        })
        (builtins.fetchGit {
          name = "cangjie-tools";
          url = "ssh://git@gitcode.com/Cangjie/cangjie-tools.git";
          ref = "release-cangjie-202507212144";
          rev = "32f7d75c27a0837819cf22d6793ba7fec8804348";
        })
        (builtins.fetchGit {
          name = "stdx";
          url = "ssh://git@gitcode.com/Cangjie/stdx.git";
          ref = "release-cangjie-202507212144";
          rev = "3d6614a335de80d79fe711e7ede4a4ace2d6a655";
        })
        (pkgs.fetchgit {
          name = "flatbuffers";
          url = "https://gitee.com/mirrors_trending/flatbuffers.git";
          rev = "v24.3.25";
          hash = "sha256-uE9CQnhzVgOweYLhWPn2hvzXHyBbFiFVESJ1AEM3BmA=";
        })
        (builtins.fetchGit {
          name = "llvm-project";
          url = "https://gitee.com/openharmony/third_party_llvm-project.git";
          rev = "5c68a1cb123161b54b72ce90e7975d95a8eaf2a4";
          shallow = true;
        })
      ];
    }
  ];
in cangjiePkgs // {
    # cangjie = cangjiePkgs.cangjie-bin-1_0_0;
}
