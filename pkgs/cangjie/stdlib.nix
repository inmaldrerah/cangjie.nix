{
  cjver,
  cjsrcs,
  pkgs,
  lib,
  libedit,
  libxcrypt,
  openssl,
  ncurses6,
  cangjie-compiler,
  cangjie-runtime,
  patchFlatbuffers ? (cjver < "1.1"),
  patchLibASTCopy ? (cjver >= "1.1"),
  ...
}:
let
  stdFolder = if cjver < "1.1" then "std" else "stdlib";
  flatbuffersFolder = if patchFlatbuffers then "flatbuffers-release" else "flatbuffers";
in
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie-stdlib";
  version = cjver;
  srcs = builtins.filter (
    x:
    builtins.elem x.name [
      "cangjie_runtime"
      flatbuffersFolder
      "libboundscheck"
      "pcre2"
    ]
  ) cjsrcs;
  sourceRoot = ".";
  buildInputs = [
    libedit
    libxcrypt
    openssl
    ncurses6
    cangjie-compiler
  ];
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    python3
    git
  ];
  postPatch =
    (lib.optionalString patchFlatbuffers ''
      git -C flatbuffers-release apply --whitespace=fix ../cangjie_runtime/${stdFolder}/third_party/flatbufferPatch.diff
      rm -r flatbuffers-release/.git
    '')
    + (lib.optionalString patchLibASTCopy ''
      sed -i '/COMMAND[[:space:]]\+''${TARGET_AR}[[:space:]]\+q[[:space:]]\+''${AST_FFI_LIB}/i\
        COMMAND chmod u+w ''${AST_FFI_LIB}
      ' cangjie_runtime/stdlib/libs/std/ast/native/CMakeLists.txt
    '')
    + ''
      sed -i -e 's/-Werror/-Wno-error/g' cangjie_runtime/${stdFolder}/cmake/linux_toolchain.cmake
      sed -i -e 's|third_party/boundscheck-[^)/]\+|third_party/boundscheck|g' cangjie_runtime/${stdFolder}/CMakeLists.txt
      sed -i -e 's|third_party/boundscheck-[^)/]\+|third_party/boundscheck|g' cangjie_runtime/${stdFolder}/libs/CMakeLists.txt
      sed -i -e 's|third_party/pcre2-[^)/]\+|third_party/pcre2|g' cangjie_runtime/${stdFolder}/CMakeLists.txt
      # Find all .cpp and .hpp/.h files and add <stdint.h> if required
      find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
        if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f" && ! grep -q -i -E '#include <(stdint.h|cstdint)>'; then
          sed -i -e "1i #include <stdint.h>\n" "$f"
        fi
      done
      # Create links after patching to avoid scanning files multiple times
      ln -s ../../../${flatbuffersFolder} cangjie_runtime/${stdFolder}/third_party/flatbuffers
      ln -s ../../../libboundscheck cangjie_runtime/${stdFolder}/third_party/boundscheck
      ln -s ../../../pcre2 cangjie_runtime/${stdFolder}/third_party/pcre2
    '';
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    mkdir chir
    cd cangjie_runtime/${stdFolder}
    python3 build.py build -t release "--target-lib=${cangjie-runtime}" \
      "--build-args=--save-temps=$WORKSPACE/chir"
    python3 build.py install
    cd -
  '';
  installPhase = ''
    cp -R cangjie_runtime/${stdFolder}/output $out
    mkdir -p $out/chir/std
    cp -R chir/*.chir $out/chir/std
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl.out}/lib";
  CANGJIE_HOME = "${cangjie-compiler}";
}
