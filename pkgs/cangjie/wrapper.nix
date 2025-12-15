{
  stdenv,
  lib,
  binutils,
  cangjie-toolless,
  cangjie-tools ? null,
  gccNGPackages_15,
  glibc,
  llvmPackages,
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
          gccNGPackages_15.gcc-unwrapped
          gccNGPackages_15.libatomic
          gccNGPackages_15.libgcc
          gccNGPackages_15.libssp
          gccNGPackages_15.libstdcxx
          llvmPackages.libcxxClang
        ];
    }).fhsenv;
in
stdenv.mkDerivation {
  pname = "cangjie";
  version = cangjie-toolless.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  postInstall = ''
    mkdir -p $out/bin || true
  ''
  + (
    if cangjie-tools != null then
      ''
        for file in ${cangjie-tools}/bin/*; do
          if [ -f "$file" ]; then
            filename=$(basename "$file")
            ln -sf "$file" "$out/bin/$filename"
          fi
        done
      ''
    else
      ""
  )
  + ''
    makeWrapper ${cangjie-toolless}/bin/cjc $out/bin/cjc \
      --prefix PATH : "${fhsenv}/bin" \
      --add-flags "--sysroot ${fhsenv}"
  '';
}
