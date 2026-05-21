{
  programs.nix-monitor = {
    enable = true;
    generationsCommand = [
      "bash"
      "-c"
      "echo $(($(ls -l /nix/var/nix/profiles/system* | wc -l)-1))"
    ];
    rebuildCommand = [
      "bash"
      "-c"
      "pkexec nrs"
    ];
    gcCommand = [
      "bash"
      "-c"
      "pkexec nix-cleanup"
    ];
  };
}
