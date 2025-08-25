{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.social;
in
{
  options.my.useCase.social =
    let
      self = config.my.useCase.social;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Social";
      options = {
        chatting = mkSubGroup {
          description = "Chatting";
          options =
            let
              self = config.my.useCase.social.chatting;
              mkSub = mkSubUseCaseOption self;
            in
            {
              telegram = mkSub "Telegram";
            };
        };
        fediverse = mkSub "Fediverse";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.fediverse.enable {
      my.programs.tuba.enable = true;
    })
  ];
}
