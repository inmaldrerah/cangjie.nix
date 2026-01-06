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
      cangjie-toolless-wrapped = pkgs.callPackage ./tools-wrapper.nix { inherit cangjie-toolless; };
      cangjie-tools = pkgs.callPackage ./tools.nix (
        { inherit cangjie-toolless cangjie-toolless-wrapped cangjie-stdx; } // args
      );
      cangjie-unwrapped = pkgs.stdenvNoCC.mkDerivation {
        pname = "cangjie-unwrapped";
        version = cjver;
        buildInputs = [
          cangjie-compiler
          cangjie-runtime
          cangjie-stdlib
          cangjie-tools
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
          cd ${cangjie-tools}
          find . -type d -exec mkdir -p "$out/tools/{}" \;
          find . \( -type f -o -type l \) -exec cp -P "{}" "$out/tools/{}" \;
          cd -
          mkdir -p $out/tools/bin
          cd $out/tools
          find bin -exec ln -s "../tools/{}" "$out/{}" \;
          cd -
          runHook postInstall
        '';
      };
      cangjie = pkgs.callPackage ./wrapper.nix { inherit cangjie-unwrapped cangjie-stdx; };
    in
    {
      "cangjie-${dotlessVer}-compiler" = cangjie-compiler;
      "cangjie-${dotlessVer}-runtime" = cangjie-runtime;
      "cangjie-${dotlessVer}-stdlib" = cangjie-stdlib;
      "cangjie-${dotlessVer}-toolless" = cangjie-toolless;
      "cangjie-${dotlessVer}-stdx" = cangjie-stdx;
      "cangjie-${dotlessVer}-tools" = cangjie-tools;
      "cangjie-${dotlessVer}-unwrapped" = cangjie-unwrapped;
      "cangjie-${dotlessVer}" = cangjie;
    };
  makeCangjiePkgs = argList: lib.mergeAttrsList (map makeCangjiePkg argList);
in
makeCangjiePkgs (pkgs.callPackage (import ./versions) { })
