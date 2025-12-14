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
  ...
}:
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie-stdlib";
  version = cjver;
  srcs = builtins.filter (
    x:
    builtins.elem x.name [
      "cangjie_runtime"
      "flatbuffers-release"
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
  postPatch = ''
    git -C flatbuffers-release apply --whitespace=fix ../cangjie_runtime/std/third_party/flatbufferPatch.diff
    rm -r flatbuffers-release/.git
    sed -i -e 's/-Werror/-Wno-error/g' cangjie_runtime/std/cmake/linux_toolchain.cmake
    sed -i -e 's|third_party/boundscheck-[^)/]\+|third_party/boundscheck|g' cangjie_runtime/std/CMakeLists.txt
    sed -i -e 's|third_party/boundscheck-[^)/]\+|third_party/boundscheck|g' cangjie_runtime/std/libs/CMakeLists.txt
    sed -i -e 's|third_party/pcre2-[^)/]\+|third_party/pcre2|g' cangjie_runtime/std/CMakeLists.txt
    # Find all .cpp and .hpp/.h files and add <stdint.h> if required
    find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
      if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f" && ! grep -q -i -E '#include <(stdint.h|cstdint)>'; then
        sed -i -e "1i #include <stdint.h>\n" "$f"
      fi
    done
    # Create links after patching to avoid scanning files multiple times
    ln -s ../../../flatbuffers-release cangjie_runtime/std/third_party/flatbuffers
    ln -s ../../../libboundscheck cangjie_runtime/std/third_party/boundscheck
    ln -s ../../../pcre2 cangjie_runtime/std/third_party/pcre2
  '';
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    cd cangjie_runtime/std
    python3 build.py clean
    python3 build.py build -t release "--target-lib=${cangjie-runtime}"
    python3 build.py install
    cd -
  '';
  installPhase = ''
    cp -R cangjie_runtime/std/output $out
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl}/lib";
  CANGJIE_HOME = "${cangjie-compiler}";
}
