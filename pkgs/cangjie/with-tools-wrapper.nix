{
  stdenv,
  cangjie-all-unwrapped,
  cangjie-stdx,
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
  pname = "cangjie-with-tools";
  version = cangjie-all-unwrapped.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  postInstall = ''
    mkdir -p $out/bin
    for file in ${cangjie-all-unwrapped}/bin/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ $filename != "cjc" -a $filename != "cjpm" ]; then
          ln -sf "$file" "$out/bin/$filename"
        fi
      fi
    done
    makeWrapper ${cangjie-all-unwrapped}/bin/cjc $out/bin/cjc \
      --prefix PATH : "${fhsenv}/bin" \
      --add-flags "--sysroot ${fhsenv}"
    makeWrapper ${cangjie-all-unwrapped}/bin/cjpm $out/bin/cjpm \
      --set-default CANGJIE_STDX_PATH "${cangjie-stdx}/static/stdx"
  '';
}
