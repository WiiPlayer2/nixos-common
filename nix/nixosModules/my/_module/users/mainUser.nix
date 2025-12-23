{ hostConfig, ... }:
let
  mainUser = hostConfig.mainUser;
in
{
  users.users.${mainUser} = {
    extraGroups = [
      "dialout"
    ];
  };
}
