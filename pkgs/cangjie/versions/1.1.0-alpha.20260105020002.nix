{ pkgs, ... }:
{
  cjver = "1.1.0-alpha.20260105020002";
  patchLLVM = false;
  patchTinytoml = true;
  cjdbDisablePython = false;
  cjsrcs = [
    (pkgs.fetchgit {
      name = "cangjie_compiler";
      url = "https://gitcode.com/Cangjie/cangjie_compiler.git";
      rev = "ce9cf482ce4c91238d0ad2c6c585ad717a9fc94e";
      hash = "sha256-8IfI1MLXVOaLV29iHF79+bnm2Iq6WTVPKyKzWeCLjgs=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "cangjie_runtime";
      url = "https://gitcode.com/Cangjie/cangjie_runtime.git";
      rev = "899dd7cf77798ceab61cd672f606a058f1e5af19";
      hash = "sha256-dbCvRZhdWDtglGH0KZdAqNwHTLbI/a6dswNFzEioWOY=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "cangjie_tools";
      url = "https://gitcode.com/Cangjie/cangjie_tools.git";
      rev = "d88b44102b29ec92cee19a4fbb9090b9d639751b";
      hash = "sha256-ef3DDj9iS9dxTs+0ADEeJ+YXKm2BSq1qyYi1JZt/Kcw=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "cangjie_stdx";
      url = "https://gitcode.com/Cangjie/cangjie_stdx.git";
      rev = "2238632798d226433f802232dc78d0148ffb7d80";
      hash = "sha256-KYbMDi+m+nD6K0sOOGdJ9YTdcjaADAmBdmLHDpnjpOI=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "flatbuffers";
      url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
      rev = "a28912875aa5e275f4b98d9145ac58131658f81a";
      hash = "sha256-LeCn//ny4P01zgewIgKTvpZOSIqY8O3wg/HeSNQYq4U=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "llvm-project";
      url = "https://gitcode.com/Cangjie/llvm-project.git";
      rev = "20dbe2768b30fd879c21a17627cce2255688a8b5";
      hash = "sha256-spN6m/TepcRKxHWQpMW/gbW13Vk3wo4GueTvlCqOaIQ=";
      leaveDotGit = true; # Required: used by git log
    })
    (pkgs.fetchgit {
      name = "tinytoml";
      url = "https://gitcode.com/src-openeuler/tinytoml.git";
      rev = "openEuler-24.03-LTS-SP1";
      hash = "sha256-ldnK4RUO/HjHCQaZ7IDBk5T8spoPGKMuZIVLWGAybWE=";
    })
    (pkgs.fetchgit {
      name = "libboundscheck";
      url = "https://gitee.com/openharmony/third_party_bounds_checking_function.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-JptEX6TD44i5aSmvb5wO9gK/umzuLQkyNosmVi631p0=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "libxml2";
      url = "https://gitcode.com/openharmony/third_party_libxml2.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-7T25HC25eSPtSs+K4h8Lnh9tdkTfwQHWRepXVOF1Dtw=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "flatbuffers-release";
      url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-Z8xXh2ZkVpnLjCRNCfHyUTmxobjq/wS/OORaDZUqayI=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "pcre2";
      url = "https://gitee.com/openharmony/third_party_pcre2.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-PE16Hg9YLPZ+VEbyccbxA+NkXSGKOAraf0joXygEYoQ=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "zlib";
      url = "https://gitee.com/openharmony/third_party_zlib.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-wDh2WYc4cFRBUntUVsxeBVBbCOxORnUBTX2ncLNpWSg=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "json";
      url = "https://gitcode.com/openharmony/third_party_json.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-jptGvl7aqbz4XbY6EtyeZ3x9FYBTf1QYUOW3c4ufgyw=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "sqlite3";
      url = "https://gitcode.com/openharmony/third_party_sqlite.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-4Upc3sUiO3TGXiNOhrrpXIT6TK2Fik+N1ZRSEiZqfMs=";
      leaveDotGit = true;
    })
  ];
}
