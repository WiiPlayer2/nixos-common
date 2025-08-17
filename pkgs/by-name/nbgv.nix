{ buildDotnetGlobalTool }:

buildDotnetGlobalTool {
  pname = "nbgv";
  version = "3.7.115";

  nugetHash = "sha256-GP2lzFFA7ihC7Hc5d1zciqMtxNb6GjCoX0ewPxm3w3g=";

  passthru.skipUpdate = true;
}
