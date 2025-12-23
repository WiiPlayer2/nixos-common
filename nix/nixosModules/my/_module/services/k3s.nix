{ pkgs, ... }:
{
  services.k3s = {
    package = pkgs.unstable.k3s;
    gracefulNodeShutdown = {
      enable = true;
      # default is 30s/10s
      shutdownGracePeriod = "2m";
      shutdownGracePeriodCriticalPods = "30s";
    };
  };
}
