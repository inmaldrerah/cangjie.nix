{ cjver, cjsrcs, pkgs, lib, libedit, ncurses6, ... }:
pkgs.llvmPackages_15.stdenv.mkDerivation {
  pname = "cangjie";
  version = cjver;
  srcs = cjsrcs;
  sourceRoot = ".";
  buildInputs = [
    libedit
    ncurses6
  ];
  postUnpack = ''
    ln -s ../../flatbuffers cangjie-compiler/third_party/flatbuffers
    ln -s ../../llvm-project cangjie-compiler/third_party/llvm-project
  '';
  postPatch = ''
    git -C flatbuffers apply ../cangjie-compiler/third_party/flatbufferPatch.diff
    git -C llvm-project apply ../cangjie-compiler/third_party/llvmPatch.diff
  '';
  buildPhase = ''
    runhook preBuild;

    cd cangjie_compiler;
    python3 build.py clean;
    export CMAKE_PREFIX_PATH=${libedit}:${ncurses6};
    python3 build.py build -t release \
        --target-lib=${ncurses6}/lib \
        --build-cjdb;
    python3 build.py install;
    cd -;

    runhook postBuild
  '';
}
