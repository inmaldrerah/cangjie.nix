{
  stdenv,
  lib,
  binutils,
  cangjie-unwrapped,
  cangjie-stdx,
  gccNGPackages_15,
  glibc,
  makeWrapper,
  buildFHSEnv,
}:

let
  fhsenv =
    (buildFHSEnv {
      name = "cangjie-env";
      targetPkgs =
        pkgs: with pkgs; [
          glibc
          binutils
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
    for file in ${cangjie-unwrapped}/bin/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ $filename != "cjc" -a $filename != "cjpm" ]; then
          ln -sf "$file" "$out/bin/$filename"
        fi
      fi
    done
    makeWrapper ${cangjie-unwrapped}/bin/cjc $out/bin/cjc \
      --prefix PATH : "${fhsenv}/bin" \
      --add-flags "--sysroot ${fhsenv}"
    makeWrapper ${cangjie-unwrapped}/bin/cjpm $out/bin/cjpm \
      --set-default CANGJIE_STDX_PATH "${cangjie-stdx}/static/stdx"
  '';
}
