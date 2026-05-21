{
  security = {
    polkit.enable = true;
    pam.services = {
      dms-greeter = {
        fprintAuth = false;
        u2f.enable = false;
      };
      greetd = {
        fprintAuth = false;
        u2f.enable = false;
      };
    };
  };
}
