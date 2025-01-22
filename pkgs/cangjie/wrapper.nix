{ stdenv, lib, binutils, cangjie-unwrapped, gcc-unwrapped, makeWrapper, buildFHSEnv }:

let
  fhsenv = (buildFHSEnv {
    name = "cangjie-env";
    targetPkgs = pkgs: with pkgs; [
      gcc-unwrapped
      llvmPackages.libcxxClang
    ];
  }).fhsenv;
in stdenv.mkDerivation {
  pname = "cangjie";
  version = cangjie-unwrapped.version;
  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  postInstall = ''
    mkdir -p $out/bin || true
    for file in ${cangjie-unwrapped}/bin/*; do
      if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ "$filename" != "cjc" ]; then
          ln -sf "$file" "$out/bin/$filename"
        fi
      fi
    done
    makeWrapper ${cangjie-unwrapped}/bin/cjc $out/bin/cjc \
      --prefix PATH : ${lib.makeBinPath [ binutils ]} \
      --add-flags "--sysroot ${fhsenv}" \
      --add-flags "-L ${fhsenv}/lib"
  '';
}
