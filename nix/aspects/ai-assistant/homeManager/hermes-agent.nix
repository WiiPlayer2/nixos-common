{
  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };
  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard";
    extraDependencyGroups = [
      "web"
    ];
  };
}
