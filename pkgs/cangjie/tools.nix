{
  cjver,
  cjsrcs,
  pkgs,
  lib,
  libedit,
  libxcrypt,
  openssl,
  ncurses6,
  cangjie-toolless,
  cangjie-toolless-wrapped,
  cangjie-stdx,
  ...
}:
pkgs.llvmPackages.stdenv.mkDerivation {
  pname = "cangjie-tools";
  version = cjver;
  srcs = builtins.filter (
    x:
    builtins.elem x.name [
      "cangjie_tools"
    ]
  ) cjsrcs;
  sourceRoot = ".";
  buildInputs = [
    libedit
    libxcrypt
    openssl
    ncurses6
    cangjie-toolless-wrapped
  ];
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    python3
    git
  ];
  postPatch = ''
    # Find all .cpp and .hpp/.h files and add <stdint.h> if required
    find . -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | while read f; do
      if grep -q -i -E '(u?int|float)(_fast|_least|max|ptr)?[0-9]*_(t|min|max)' "$f" && ! grep -q -i -E '#include <(stdint.h|cstdint)>'; then
        sed -i -e "1i #include <stdint.h>\n" "$f"
      fi
    done
  '';
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    cd cangjie_tools/cjpm/build
    python3 build.py clean
    python3 build.py build -t release --set-rpath ${cangjie-toolless}/runtime/lib/linux_''${ARCH}_cjnative
    python3 build.py install
    cd -
    cd cangjie_tools/cjfmt/build
    python3 build.py clean
    python3 build.py build -t release -j32
    python3 build.py install
    cd -
    # cd cangjie_tools/cangjie-language-server/build
    # python3 build.py clean
    # python3 build.py build -t release -j32
    # python3 build.py install
    # cd -
  '';
  installPhase = ''
    mkdir -p $out/bin $out/config
    cp cangjie_tools/cjpm/dist/cjpm $out/bin/cjpm
    cp cangjie_tools/cjfmt/build/build/bin/cjfmt $out/bin/cjfmt
    cp cangjie_tools/cjfmt/config/*.toml $out/config/
    # cp cangjie_tools/cangjie-language-server/output/bin/LSPServer $out/bin/LSPServer
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl}/lib";
  CANGJIE_HOME = "${cangjie-toolless}";
  CANGJIE_STDX_PATH = "${cangjie-stdx}/static/stdx";
}
