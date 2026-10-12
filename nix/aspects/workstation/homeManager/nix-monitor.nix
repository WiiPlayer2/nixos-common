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

    # It hogs the disk and the disk usage monitor can refresh on demand if needed
    storeSizeCommand = [
      "bash"
      "-c"
      "echo N/A"
    ];
  };
}
