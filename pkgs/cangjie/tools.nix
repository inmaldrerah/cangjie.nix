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
      "flatbuffers-release"
      "sqlite3"
      "json"
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
    mkdir -p cangjie_tools/cangjie-language-server/third_party
    mkdir -p cangjie_tools/cjlint/third_party
    ln -s ../../../flatbuffers-release cangjie_tools/cangjie-language-server/third_party/flatbuffers
    ln -s ../../../json cangjie_tools/cangjie-language-server/third_party/json-v3.11.3
    ln -s ../../../flatbuffers-release cangjie_tools/cjlint/third_party/flatbuffers
    ln -s ../../../json cangjie_tools/cjlint/third_party/json-v3.11.3
    sed -i -e 's/return str\.begin\.column < pos.column < str\.begin\.column + str\.value\.size();/return (str.begin.column < pos.column) \&\& (pos.column < str.begin.column + str.value.size());/' cangjie_tools/cangjie-language-server/src/languageserver/ArkServer.cpp
    sed -i -e 's/        generate_flat_header()/    generate_flat_header()/' cangjie_tools/cangjie-language-server/build/build.py
  ''
  + (lib.optionalString (cjver >= "1.1") ''
    ln -s ../../../sqlite3 cangjie_tools/cangjie-language-server/third_party/sqlite3
    sed -i -e 's/        build_sqlite_amalgamation()/    build_sqlite_amalgamation()/' cangjie_tools/cangjie-language-server/build/build.py
  '');
  dontConfigure = true;
  buildPhase = ''
    export WORKSPACE=$PWD
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6}
    if [ ! -v NO_CJPM ]; then
      cd cangjie_tools/cjpm/build
      python3 build.py build -t release --set-rpath ${cangjie-toolless}/runtime/lib/linux_''${ARCH}_cjnative
      python3 build.py install
      cd -
    fi
    if [ ! -v NO_CJFMT ]; then
      cd cangjie_tools/cjfmt/build
      python3 build.py build -t release -j 32
      python3 build.py install
      cd -
    fi
    if [ ! -v NO_CJLSP ]; then
      cd cangjie_tools/cangjie-language-server/build
      python3 build.py build -t release -j 32
      python3 build.py install
      cd -
    fi
    if [ ! -v NO_CJLINT ]; then
      cd cangjie_tools/cjlint/build
      python3 build.py build -t release -j 32
      python3 build.py install
      cd -
    fi
  '';
  installPhase = ''
    mkdir -p $out/bin $out/config $out/lib
    cp cangjie_tools/cjpm/dist/cjpm $out/bin/cjpm
    cp cangjie_tools/cjfmt/build/build/bin/cjfmt $out/bin/cjfmt
    cp cangjie_tools/cjfmt/config/*.toml $out/config/
    cp cangjie_tools/cangjie-language-server/output/bin/LSPServer $out/bin/LSPServer
    cp cangjie_tools/cjlint/dist/bin/cjlint $out/bin/cjlint
    cp cangjie_tools/cjlint/dist/config/*.json $out/config/
    cp cangjie_tools/cjlint/dist/lib/libcjlint.so $out/lib/libcjlint.so
  '';
  ARCH = "x86_64";
  SDK_NAME = "linux-x64";
  CANGJIE_VERSION = cjver;
  STDX_VERSION = "1";
  OPENSSL_PATH = "${openssl.out}/lib";
  CANGJIE_HOME = "${cangjie-toolless}";
  CANGJIE_STDX_PATH = "${cangjie-stdx}/static/stdx";
}
