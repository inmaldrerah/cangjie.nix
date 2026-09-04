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
      hash = "sha256-FWjJbM+n8O45nQ4SAqoSWulMSGGZqqL37uj5trMCJ70=";
    })
    (pkgs.fetchgit {
      name = "cangjie_runtime";
      url = "https://gitcode.com/Cangjie/cangjie_runtime.git";
      rev = "v1.0.5";
      hash = "sha256-tHQntCAz8M9DKnZWbQ3/Zpfs1SWYA2MrxQgXLpCHbM4=";
    })
    (pkgs.fetchgit {
      name = "cangjie_tools";
      url = "https://gitcode.com/Cangjie/cangjie_tools.git";
      rev = "v1.0.5";
      hash = "sha256-YXwll/pBDq5izlqDCCF0v2lWf9Kt1q+lYjQY+1cPjB8=";
    })
    (pkgs.fetchgit {
      name = "cangjie_stdx";
      url = "https://gitcode.com/Cangjie/cangjie_stdx.git";
      rev = "v1.0.5";
      hash = "sha256-c9gQpyrZ2luJvUm6dDMtB/SJVGRaVgfUWvgmtbbLqBg=";
    })
    (pkgs.fetchgit {
      name = "flatbuffers";
      url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
      rev = "741ee53d0dbd826f0a35de2a4b0a2d096d95fc69";
      hash = "sha256-LeCn//ny4P01zgewIgKTvpZOSIqY8O3wg/HeSNQYq4U=";
    })
    (pkgs.fetchgit {
      name = "llvm-project";
      url = "https://gitee.com/openharmony/third_party_llvm-project.git";
      rev = "5c68a1cb123161b54b72ce90e7975d95a8eaf2a4";
      hash = "sha256-kqF3l2RdTvTxUy71YCjUDsv/zTlmzoGyZB+DkzTps0g=";
    })
    (pkgs.fetchgit {
      name = "libboundscheck";
      url = "https://gitee.com/openharmony/third_party_bounds_checking_function.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-MmtvcYH9nIXp0iOE8Meog5+uxwYaBSsR2e4M/BYpnnU=";
    })
    (pkgs.fetchgit {
      name = "libxml2";
      url = "https://gitcode.com/openharmony/third_party_libxml2.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-33GianhqLC47MuIKmmTVndEUxT31IzR8bMxWOKShvyo=";
    })
    (pkgs.fetchgit {
      name = "flatbuffers-release";
      url = "https://gitcode.com/openharmony/third_party_flatbuffers.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-IqPR2PZqD6on8CUME98J8CbrMtJT6yt/zO9FG5YZh78=";
    })
    (pkgs.fetchgit {
      name = "pcre2";
      url = "https://gitee.com/openharmony/third_party_pcre2.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-dQzN/3+nskR1J7UWGw6u5AxbgSbzh+7HS/KrgmEBUSw=";
    })
    (pkgs.fetchgit {
      name = "zlib";
      url = "https://gitee.com/openharmony/third_party_zlib.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-wt3iXDb/Dq+KbMjeCYMYuDOtG6iKEDiWsekN99FvyDo=";
    })
    (pkgs.fetchgit {
      name = "json";
      url = "https://gitcode.com/openharmony/third_party_json.git";
      rev = "OpenHarmony-v6.0-Release";
      hash = "sha256-X/OIrpUnjOmqGd4/EZGTOpwrU8Te2e1aRuibW+p2uOk=";
    })
  ];
}
