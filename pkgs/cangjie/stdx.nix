{
  cjver,
  cjsrcs,
  pkgs,
  lib,
  libedit,
  libxcrypt,
  openssl,
  ncurses6,
  cangjie,
  ...
}:
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie-stdx";
  version = cjver;
  srcs = builtins.filter (
    x:
    builtins.elem x.name [
      "cangjie_compiler"
      "cangjie_stdx"
      "libboundscheck"
      "zlib"
    ]
  ) cjsrcs;
  sourceRoot = ".";
  buildInputs = [
    libedit
    libxcrypt
    openssl
    ncurses6
    cangjie
  ];
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    python3
    git
  ];
  postPatch = ''
    sed -i -e 's/-Werror/-Wno-error/g' cangjie_stdx/build/common/linux_toolchain.cmake
    sed -i -e 's|third_party/boundscheck-[^)/]\+|third_party/boundscheck|g' cangjie_stdx/CMakeLists.txt
    sed -i -e 's|third_party/boundscheck-[^)/]\+|third_party/boundscheck|g' cangjie_stdx/src/CMakeLists.txt
    # Find all .cpp and .hpp/.h files and add <stdint.h> if required
    find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
      if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f" && ! grep -q -i -E '#include <(stdint.h|cstdint)>'; then
        sed -i -e "1i #include <stdint.h>\n" "$f"
      fi
    done
    mkdir -p cangjie_stdx/third_party
    ln -s ../../libboundscheck cangjie_stdx/third_party/boundscheck
    ln -s ../../zlib cangjie_stdx/third_party/zlib
  '';
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    cd cangjie_stdx
    python3 build.py clean
    python3 build.py build -t release "--include=$WORKSPACE/cangjie_compiler/include"
    python3 build.py install
    export CANGJIE_STDX_PATH=$WORKSPACE/cangjie_stdx/target/linux_''${ARCH}_cjnative/static/stdx
    cd -
  '';
  installPhase = ''
    cp -R cangjie_stdx/target/linux_''${ARCH}_cjnative $out
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl}/lib";
  CANGJIE_HOME = "${cangjie}";
}
