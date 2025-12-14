{ pkgs, ... }:
let
  lib = pkgs.lib;
  replaceDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch) str;
  makeCangjiePkg =
    { cjver, ... }@args:
    let
      dotlessVer = replaceDots cjver;
    in
    rec {
      "cangjie-${dotlessVer}" = pkgs.callPackage ./cangjie.nix args;
    };
  makeCangjiePkgs = argList: lib.mergeAttrsList (map makeCangjiePkg argList);
  cangjiePkgs = makeCangjiePkgs [
    {
      cjver = "1.0.5";
      cjsrcs = [
        (pkgs.fetchgit {
          name = "cangjie_compiler";
          url = "https://gitcode.com/Cangjie/cangjie_compiler.git";
          rev = "v1.0.5";
          hash = "sha256-3YlHhuOtzkpI+M009YesssRxX0EKs2rhdGqjsqfKgGQ=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "cangjie_runtime";
          url = "https://gitcode.com/Cangjie/cangjie_runtime.git";
          rev = "v1.0.5";
          hash = "sha256-019QfcWPJm+8g8fy5W1VxnAMlnEj6Hqbh/uN33Ipz/E=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "cangjie_tools";
          url = "https://gitcode.com/Cangjie/cangjie_tools.git";
          rev = "v1.0.5";
          hash = "sha256-y3/HA6xb5UbzvtTIJqX4vzgcyyxRU5hchLCdZhK09hg=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "cangjie_stdx";
          url = "https://gitcode.com/Cangjie/cangjie_stdx.git";
          rev = "v1.0.5";
          hash = "sha256-GPBMMomCELCBruwsI06OHeJgA7nCd54Z9GlKRMh54wk=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "flatbuffers";
          url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
          rev = "741ee53d0dbd826f0a35de2a4b0a2d096d95fc69";
          hash = "sha256-vsssRW6aSRcL83vhH1QjLUXfAV3b6D6CSSC7htH6RrI=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "llvm-project";
          url = "https://gitee.com/openharmony/third_party_llvm-project.git";
          rev = "5c68a1cb123161b54b72ce90e7975d95a8eaf2a4";
          hash = "sha256-A8y23IWvE7uKdbWyp/7217kRviD/IUEORUimm7fd38Q=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "libboundscheck";
          url = "https://gitee.com/openharmony/third_party_bounds_checking_function.git";
          rev = "OpenHarmony-v6.0-Release";
          hash = "sha256-JptEX6TD44i5aSmvb5wO9gK/umzuLQkyNosmVi631p0=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "libxml2";
          url = "https://gitcode.com/openharmony/third_party_libxml2.git";
          rev = "OpenHarmony-v6.0-Release";
          hash = "sha256-7T25HC25eSPtSs+K4h8Lnh9tdkTfwQHWRepXVOF1Dtw=";
          leaveDotGit = true;
        })
      ];
    }
  ];
in
cangjiePkgs
// {
  # cangjie = cangjiePkgs.cangjie-bin-1_0_0;
}
