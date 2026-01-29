{ pkgs, ... }:
{
  cjver = "1.0.5";
  patchLLVM = true;
  patchTinytoml = false;
  cjdbDisablePython = false;
  cjsrcs = [
    (pkgs.fetchgit {
      name = "cangjie_compiler";
      url = "https://gitcode.com/Cangjie/cangjie_compiler.git";
      rev = "v1.0.5";
      hash = "sha256-7uGTmwx1kdPnyGaGm4/EiaYSOfbP5qSRUtULWD5Yn9s=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "cangjie_runtime";
      url = "https://gitcode.com/Cangjie/cangjie_runtime.git";
      rev = "v1.0.5";
      hash = "sha256-QRect8uvi0nkS2b/CIOXno4oH5iuvwkOjd1u5CpsoJs=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "cangjie_tools";
      url = "https://gitcode.com/Cangjie/cangjie_tools.git";
      rev = "v1.0.5";
      hash = "sha256-Mu97lf84CaP6VVtB6RHmgP2WqyInLasLkM9QR3FxgY4=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "cangjie_stdx";
      url = "https://gitcode.com/Cangjie/cangjie_stdx.git";
      rev = "v1.0.5";
      hash = "sha256-GPBMMomCELCBruwsI06OHeJgA7nCd54Z9GlKRMh54wk=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "flatbuffers";
      url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
      rev = "741ee53d0dbd826f0a35de2a4b0a2d096d95fc69";
      hash = "sha256-gyJTj4UKNUrDZrWaJACmK26lwhLHmOVHFDAgb5Jnt1I=";
      leaveDotGit = true;
    })
    (pkgs.fetchgit {
      name = "llvm-project";
      url = "https://gitee.com/openharmony/third_party_llvm-project.git";
      rev = "5c68a1cb123161b54b72ce90e7975d95a8eaf2a4";
      hash = "sha256-A8y23IWvE7uKdbWyp/7217kRviD/IUEORUimm7fd38Q=";
      leaveDotGit = true;
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
      hash = "sha256-6Y35qGqpLCRtMbkO3862XI/7e0CK7Uc27F4O3HwbWCE=";
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
  ];
}
