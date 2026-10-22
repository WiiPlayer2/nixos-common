{
  programs.openspec = {
    enable = true;
    settings = {
      profile = "custom";
      workflows = [
        "propose"
        "explore"
        "new"
        "continue"
        "apply"
        "ff"
        "sync"
        "archive"
        "bulk-archive"
        "verify"
      ];
    };
  };
}
