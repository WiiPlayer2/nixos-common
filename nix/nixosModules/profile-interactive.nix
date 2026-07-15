{ ... }:
{
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Start swapping at 10% free memory left
  };
}
