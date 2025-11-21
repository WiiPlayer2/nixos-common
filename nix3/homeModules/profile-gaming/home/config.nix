{ pkgs }:
{
  packages = with pkgs; [
    bizhawk
    randovania

    (writeShellApplication {
      name = "fix-dolphin-read-memory-for-archipelago";
      text = ''
        echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      '';
    })
  ];

  sessionVariables = {
    DME_DOLPHIN_PROCESS_NAME = ".dolphin-emu-wr";
  };
}
