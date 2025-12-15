{
  stdenv,
  lib,
  binutils,
  cangjie-toolless,
  glibc,
  gccNGPackages_15,
  makeWrapper,
  buildFHSEnv,
}:

let
  fhsenv =
    (buildFHSEnv {
      name = "cangjie-env";
      targetPkgs =
        pkgs: with pkgs; [
          binutils
          glibc
          gccNGPackages_15.libgcc
        ];
    }).fhsenv;
in
stdenv.mkDerivation {
  pname = "cangjie-tools-wrapper";
  version = cangjie-toolless.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  postInstall = ''
    mkdir -p $out/bin
    ln -sf ${cangjie-toolless}/bin/cjc-frontend $out/bin/cjc-frontend
    makeWrapper ${cangjie-toolless}/bin/cjc $out/bin/cjc \
      --prefix PATH : "${fhsenv}/bin" \
      --add-flags "--sysroot ${fhsenv}"
  '';
}
