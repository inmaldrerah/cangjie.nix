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
  ...
}:
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie-runtime";
  version = cjver;
  srcs = builtins.filter (
    x:
    builtins.elem x.name [
      "cangjie_runtime"
      "libboundscheck"
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
  postPatch = ''
    sed -i -e 's/-Werror/-Wno-error/g' cangjie_runtime/runtime/config.cmake
    # Find all .cpp and .hpp/.h files and add <stdint.h> if required
    find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
      if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f" && ! grep -q -i -E '#include <(stdint.h|cstdint)>'; then
        sed -i -e "1i #include <stdint.h>\n" "$f"
      fi
    done
    # Create links after patching to avoid scanning files multiple times
    ln -s ../../../libboundscheck cangjie_runtime/runtime/third_party/third_party_bounds_checking_function
  '';
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    cd cangjie_runtime/runtime
    python3 build.py clean
    python3 build.py build -t release -v "$CANGJIE_VERSION"
    python3 build.py install
    cd -
  '';
  installPhase = ''
    # mkdir -p $out
    # cp -R cangjie_runtime/runtime/output/common/linux_release_$ARCH/{lib,runtime} $out
    cp -R cangjie_runtime/runtime/output $out
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl}/lib";
  CANGJIE_HOME = "${cangjie-compiler}";
}
