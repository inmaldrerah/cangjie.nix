{
  cjver,
  cjsrcs,
  pkgs,
  lib,
  libedit,
  libxcrypt,
  openssl,
  ncurses6,
  ...
}:
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie-compiler";
  version = cjver;
  srcs = builtins.filter (
    x:
    builtins.elem x.name [
      "cangjie_compiler"
      "flatbuffers"
      "libboundscheck"
      "libxml2"
      "llvm-project"
    ]
  ) cjsrcs;
  sourceRoot = ".";
  buildInputs = [
    libedit
    libxcrypt
    openssl
    ncurses6
  ];
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    python3
    git
  ];
  postUnpack = ''
    tar -C cangjie_compiler/third_party -xf libxml2/libxml2-*.tar.xz
  '';
  postPatch = ''
    git -C llvm-project apply --reject --whitespace=fix ../cangjie_compiler/third_party/llvmPatch.diff
    sed -i -e 's/-Werror/-Wno-error/g' cangjie_compiler/cmake/linux_toolchain.cmake
    # Find all .cpp and .hpp/.h files and add <stdint.h> if required
    find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
      if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f" && ! grep -q -i -E '#include <(stdint.h|cstdint)>'; then
        sed -i -e "1i #include <stdint.h>\n" "$f"
      fi
    done
    # Create links after patching to avoid scanning files multiple times
    ln -s ../../flatbuffers cangjie_compiler/third_party/flatbuffers
    ln -s ../../llvm-project cangjie_compiler/third_party/llvm-project
    ln -s ../../libboundscheck cangjie_compiler/third_party/boundscheck
  '';
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    cd cangjie_compiler
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    python3 build.py build -t release \
        --no-tests \
        --target-lib=${ncurses6}/lib \
        --build-cjdb \
        -j32
    python3 build.py install
    cd -
  '';
  installPhase = ''
    cp -R cangjie_compiler/output $out
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl}/lib";
}
