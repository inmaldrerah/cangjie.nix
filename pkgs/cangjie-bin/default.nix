{ lib, requireFile, callPackage }:
let
  replaceDots = str: lib.stringAsChars (ch: if ch == "." then "_" else ch) str;
  makeCangjiePkg =
    { cjver, ... }@args:
    let
      unwrapped = callPackage ./unwrapped.nix args;
      dotlessVer = replaceDots cjver;
    in
    {
      "cangjie-bin-${dotlessVer}-unwrapped" = unwrapped;
      "cangjie-bin-${dotlessVer}" = callPackage ./wrapper.nix { cangjie-unwrapped = unwrapped; };
    };
  makeCangjiePkgs = argList: lib.mergeAttrsList (map makeCangjiePkg argList);
  releases = [
    {
      cjver = "1.0.0";
      hash = "sha256-iJTmOhgbwFNK8kJjtEnC2NTZ37Fv8ScLeTSZ/gbObc8=";
    }
    {
      cjver = "1.0.1";
      hash = "sha256-sARu92vrXfmlFeWzf3AOiPKyBBP92zaUwtarSGBJej8=";
    }
    {
      cjver = "1.0.3";
      hash = "sha256-DxMS0zcIO0nl7OwlVNNZUa9Kq4jHEs5gYknP1588MPY=";
    }
    {
      cjver = "1.0.4";
      hash = "sha256-ZR2U97sL40nC08b1vkVokYfCcDqb26DI3hFzY6GmfYw=";
    }
    {
      cjver = "1.0.5";
      hash = "sha256-usrYTfjgKBxTlbq0xA5IHj6mzHEu7VyVOQOw1WGhRWI=";
    }
    {
      cjver = "1.1.0";
      hash = "sha256-XOfoyFI6rZz1ll+Bgknho58QeIljrvfFhSaXo6yWQGA=";
    }
  ];
  cangjiePkgs = makeCangjiePkgs (map (r: {
    inherit (r) cjver;
    cjpkg = requireFile {
      name = "cangjie-sdk-linux-x64-${r.cjver}.tar.gz";
      url = "https://cangjie-lang.cn/download/${r.cjver}";
      inherit (r) hash;
    };
  }) releases ++ [
    {
      cjver = "0.53.13";
      cjpkg = requireFile {
        name = "Cangjie-0.53.13-linux_x64.tar.gz";
        url = "https://cangjie-lang.cn/download/0.53.13";
        hash = "sha256-s8AIfbJgBfYxZ2f9fMv8QPchz9LQkvlL85piHH2R+7s=";
      };
    }
    {
      cjver = "0.53.18";
      cjpkg = requireFile {
        name = "Cangjie-0.53.18-linux_x64.tar.gz";
        url = "https://cangjie-lang.cn/download/0.53.18";
        hash = "sha256-ip72s7pcWGlqHiP6uP9dyj5ryLrPKgqJS7pClsVMjbE=";
      };
    }
    {
      cjver = "0.55.3";
      cjpkg = ./Cangjie-0.55.3-linux_x64.tar.gz;
    }
    {
      cjver = "0.56.4";
      cjpkg = ./Cangjie-0.56.4-linux_x64.tar.gz;
    }
    { cjver = "0.58.3"; }
    { cjver = "0.59.6"; }
    { cjver = "0.60.4-0518"; }
    {
      cjver = "1.1.0-alpha.20260123";
      cjpkg = ./nightly/20260123/cangjie-sdk-linux-x64-1.1.0-alpha.20260123020001.tar.gz;
    }
    {
      cjver = "1.1.0-alpha.20260123-sanitizer";
      cjpkg = ./nightly/20260123/cangjie-sdk-linux-x64-1.1.0-alpha.20260123020001-sanitizer.tar.gz;
    }
  ]);
in
cangjiePkgs
// {
  cangjie-bin-unwrapped = cangjiePkgs.cangjie-bin-1_0_0-unwrapped;
  cangjie-bin = cangjiePkgs.cangjie-bin-1_0_0;
}
