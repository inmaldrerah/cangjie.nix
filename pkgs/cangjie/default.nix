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
      cangjie-unwrapped = pkgs.stdenvNoCC.mkDerivation {
        pname = "cangjie-unwrapped";
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
      cangjie-stdx = pkgs.callPackage ./stdx.nix ({ inherit cangjie-unwrapped; } // args);
      cangjie = pkgs.callPackage ./wrapper.nix { inherit cangjie-unwrapped; };
      cangjie-tools = pkgs.callPackage ./tools.nix (
        { inherit cangjie cangjie-unwrapped cangjie-stdx; } // args
      );
      cangjie-all-unwrapped = pkgs.stdenvNoCC.mkDerivation {
        pname = "cangjie-with-tools-unwrapped";
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
      cangjie-all = pkgs.callPackage ./with-tools-wrapper.nix {
        inherit cangjie-all-unwrapped cangjie-stdx;
      };
    in
    {
      "cangjiePackages-${dotlessVer}" = {
        compiler = cangjie-compiler;
        runtime = cangjie-runtime;
        stdlib = cangjie-stdlib;
        stdx = cangjie-stdx;
        tools = cangjie-tools;
        cangjie-unwrapped = cangjie-unwrapped;
        cangjie = cangjie;
        cangjie-all-unwrapped = cangjie-all-unwrapped;
        cangjie-all = cangjie-all;
      };
      "cangjie-${dotlessVer}-unwrapped" = cangjie-unwrapped;
      "cangjie-${dotlessVer}" = cangjie;
      "cangjie-all-${dotlessVer}-unwrapped" = cangjie-all-unwrapped;
      "cangjie-all-${dotlessVer}" = cangjie-all;
      "cangjie-tools-${dotlessVer}" = cangjie-tools;
    };
  makeCangjiePkgs =
    {
      versions,
      defaultVersion,
      aliases,
      ...
    }:
    let
      merged = lib.mergeAttrsList (map makeCangjiePkg versions);
      dotlessDefault = replaceDots defaultVersion;
      defaultPackages = merged."cangjiePackages-${dotlessDefault}";
    in
    merged
    // (lib.mergeAttrsList (
      lib.mapAttrsToList (
        aliasVer: origVer:
        let
          dotlessAlias = replaceDots aliasVer;
          dotlessOrig = replaceDots origVer;
          origPackages = merged."cangjiePackages-${dotlessOrig}";
        in
        {
          "cangjiePackages-${dotlessAlias}" = origPackages;
          "cangjie-${dotlessAlias}-unwrapped" = origPackages.cangjie-unwrapped;
          "cangjie-${dotlessAlias}" = origPackages.cangjie;
          "cangjie-all${dotlessAlias}-unwrapped" = origPackages.cangjie-all-unwrapped;
          "cangjie-all${dotlessAlias}" = origPackages.cangjie-all;
          "cangjie-tools${dotlessAlias}" = origPackages.tools;
        }
      ) aliases
    ))
    // {
      cangjiePackages = defaultPackages;
      inherit (defaultPackages)
        cangjie-unwrapped
        cangjie
        cangjie-all-unwrapped
        cangjie-all
        ;
    };
in
makeCangjiePkgs {
  versions = (pkgs.callPackage (import ./versions) { });
  defaultVersion = "1.0.5";
  aliases = {
    "1.1.0" = "1.1.0-alpha.20260105020002";
    "1.1.0-alpha" = "1.1.0-alpha.20260105020002";
  };
}
