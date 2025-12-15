{ pkgs, ... }:
let
  lib = pkgs.lib;
  replaceDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch) str;
  makeCangjiePkg =
    { cjver, ... }@args:
    let
      dotlessVer = replaceDots cjver;
      cangjie-compiler = pkgs.callPackage ./compiler.nix args;
      cangjie-runtime = pkgs.callPackage ./runtime.nix ({ inherit cangjie-compiler; } // args);
      cangjie-stdlib = pkgs.callPackage ./stdlib.nix (
        { inherit cangjie-compiler cangjie-runtime; } // args
      );
      cangjie-toolless = pkgs.stdenvNoCC.mkDerivation {
        pname = "cangjie-toolless";
        version = cjver;
        buildInputs = [
          cangjie-compiler
          cangjie-runtime
          cangjie-stdlib
        ];
        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cd ${cangjie-compiler}
          find . -type d -exec mkdir -p "$out/{}" \;
          find . \( -type f -o -type l \) -exec cp -P "{}" "$out/{}" \;
          cd -
          cd ${cangjie-runtime}/common/linux_release_*/lib
          find . -type d -exec mkdir -p "$out/lib/{}" \;
          find . \( -type f -o -type l \) -exec cp -P "{}" "$out/lib/{}" \;
          cd -
          cd ${cangjie-runtime}/common/linux_release_*/runtime
          find . -type d -exec mkdir -p "$out/runtime/{}" \;
          find . \( -type f -o -type l \) -exec cp -P "{}" "$out/runtime/{}" \;
          cd -
          cd ${cangjie-stdlib}
          find . -type d -exec mkdir -p "$out/{}" \;
          find . \( -type f -o -type l \) -exec cp -P "{}" "$out/{}" \;
          cd -
          runHook postInstall
        '';
      };
      cangjie-stdx = pkgs.callPackage ./stdx.nix ({ inherit cangjie-toolless; } // args);
      cangjie-toolless-wrapped = pkgs.callPackage ./wrapper.nix { inherit cangjie-toolless; };
      cangjie-tools = pkgs.callPackage ./tools.nix (
        { inherit cangjie-toolless cangjie-toolless-wrapped cangjie-stdx; } // args
      );
      cangjie = pkgs.callPackage ./wrapper.nix { inherit cangjie-toolless cangjie-tools; };
    in
    rec {
      "cangjie-${dotlessVer}-compiler" = cangjie-compiler;
      "cangjie-${dotlessVer}-runtime" = cangjie-runtime;
      "cangjie-${dotlessVer}-stdlib" = cangjie-stdlib;
      "cangjie-${dotlessVer}-toolless" = cangjie-toolless;
      "cangjie-${dotlessVer}-stdx" = cangjie-stdx;
      "cangjie-${dotlessVer}-tools" = cangjie-tools;
      "cangjie-${dotlessVer}" = cangjie;
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
        (pkgs.fetchgit {
          name = "flatbuffers-release";
          url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
          rev = "OpenHarmony-v6.0-Release";
          hash = "sha256-Z8xXh2ZkVpnLjCRNCfHyUTmxobjq/wS/OORaDZUqayI=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "pcre2";
          url = "https://gitee.com/openharmony/third_party_pcre2.git";
          rev = "OpenHarmony-v6.0-Release";
          hash = "sha256-PE16Hg9YLPZ+VEbyccbxA+NkXSGKOAraf0joXygEYoQ=";
          leaveDotGit = true;
        })
        (pkgs.fetchgit {
          name = "zlib";
          url = "https://gitee.com/openharmony/third_party_zlib.git";
          rev = "OpenHarmony-v6.0-Release";
          hash = "sha256-wDh2WYc4cFRBUntUVsxeBVBbCOxORnUBTX2ncLNpWSg=";
          leaveDotGit = true;
        })
      ];
    }
  ];
in
cangjiePkgs
