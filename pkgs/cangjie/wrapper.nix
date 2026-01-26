{
  stdenv,
  cangjie-unwrapped,
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
  pname = "cangjie";
  version = cangjie-unwrapped.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  postInstall = ''
    mkdir -p $out/bin
    ln -sf ${cangjie-unwrapped}/bin/cjc-frontend $out/bin/cjc-frontend
    makeWrapper ${cangjie-unwrapped}/bin/cjc $out/bin/cjc \
      --prefix PATH : "${fhsenv}/bin" \
      --add-flags "--sysroot ${fhsenv}"
  '';
}
