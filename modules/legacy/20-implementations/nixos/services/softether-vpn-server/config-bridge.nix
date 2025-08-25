cfg: with (import ./_config.nix); {
  values = {
    ConfigRevision = {
      type = "uint";
      data = 0;
    };
    IPsecMessageDisplayed = {
      type = "bool";
      data = false;
    };
    Region = {
      type = "string";
      data = "$";
    };
  };
  sections = {
    tmp = { };
  };
}
