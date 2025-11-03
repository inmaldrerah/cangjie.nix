{ cjver, cjsrcs, pkgs, lib, libedit, ncurses6, ... }:
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie";
  version = cjver;
  srcs = cjsrcs;
  sourceRoot = ".";
  buildInputs = [
    libedit
    ncurses6
  ];
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    python3
    git
  ];
  postUnpack = ''
    ln -s ../../flatbuffers cangjie_compiler/third_party/flatbuffers
    ln -s ../../llvm-project cangjie_compiler/third_party/llvm-project
    ln -s ../../libboundscheck cangjie_compiler/third_party/boundscheck-v1.1.16
    ln -s ../../libxml2 cangjie_compiler/third_party/libxml2-v2.9.12
  '';
  postPatch = ''
    git -C flatbuffers apply ../cangjie_compiler/third_party/flatbufferPatch.diff
    git -C llvm-project apply ../cangjie_compiler/third_party/llvmPatch.diff
    # Find all .cpp and .hpp/.h files and add <cstdint> before <string>
    find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
      # Only modify files that actually include <string>
      if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f"; then
        # Insert #include <cstdint> before the #include <string> line
        sed -i 's|^|#include <cstdint>\n|' "$f"
      fi
  done
  '';
  dontConfigure = true;
  buildPhase = ''
    cd cangjie_compiler;
    python3 build.py clean;
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6};
    python3 build.py build -t release \
        --target-lib=${ncurses6}/lib \
        --build-cjdb;
    python3 build.py install;
    cd -;
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = "1.0.0";
  STDX_VERSION = "1";
}
