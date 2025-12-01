{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.sshd;
  sshdTmpDirectory = "${config.user.home}/sshd-tmp";
  sshdDirectory = "${config.user.home}/sshd";
  pathToPubKey = "...";
  port = 2222;

  sshdConfigFile = pkgs.writeTextFile {
    name = "sshd_config";
    text = ''
      HostKey ${sshdDirectory}/ssh_host_rsa_key
      Port ${toString port}
      PermitUserEnvironment yes
      Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
    '';
  };
in
{
  options.services.sshd = {
    enable = lib.mkEnableOption "SSH Server";
  };

  config =
    with lib;
    mkIf cfg.enable {
      build.activation.sshd = ''
        $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${config.user.home}/.ssh"
        # $DRY_RUN_CMD cat ${pathToPubKey} > "${config.user.home}/.ssh/authorized_keys"

        if [[ ! -d "${sshdDirectory}" ]]; then
          $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
          $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

          $VERBOSE_ECHO "Generating host keys..."
          $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

          $VERBOSE_ECHO "Apply some workarounds for deploy-rs..."
          $DRY_RUN_CMD echo -e "PATH=${config.user.home}/.nix-profile/bin:/usr/bin:/bin:/usr/sbin:/sbin:${pkgs.openssh}/bin" >> "${config.user.home}/.ssh/environment"

          $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
        fi
      '';

      programs.supervisord.config.programs.sshd = {
        command = "${pkgs.openssh}/bin/sshd -f \"${sshdConfigFile}\" -D";
      };
    };
}
