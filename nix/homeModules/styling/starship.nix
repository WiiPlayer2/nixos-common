{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    mkForce
    tail
    concatStrings
    last
    ;

  pillStartSymbol = "";
  pillEndSymbol = "";
  pillSeparatorSymbol = "";

  osUserColor = "red";
  langColor = "green";
  envColor = "cyan";

  mkPillStart = bg: "[${pillStartSymbol}](fg:${bg})";
  mkPillEnd = bg: "[${pillEndSymbol}](fg:${bg})";
  mkPillTransition = bg: "[${pillSeparatorSymbol}](fg:prev_bg bg:${bg})";
  mkPillContent = format: bg: "[${format}](fg:black bg:${bg})";
  mkPill = format: bg: "${mkPillStart bg}${mkPillContent format bg}${mkPillEnd bg}";

  pills =
    let
      mkPill = format: bg: {
        inherit format bg;
      };
    in
    [
      (mkPill "$os$username$hostname" osUserColor)
      (mkPill "$directory" "orange")
      (mkPill "$git_branch$git_status$git_commit" "yellow")
      (mkPill "$dotnet$c$rust$golang$nodejs$bun$php$java$kotlin$haskell$python" langColor)
      (mkPill "$all" envColor)
      (mkPill "$time" "bright-white")
      (mkPill "$shell" "purple")
    ];

  formattedPills =
    let
      startSymbol = "";
      endSymbol = "";
      separatorSymbol = "";
      mkStart = bg: "[${startSymbol}](fg:${bg})";
      mkEnd = bg: "[${endSymbol}](fg:${bg})";
      mkTransition = bg: "[${separatorSymbol}](fg:prev_bg bg:${bg})";
      mkContent = pill: "[${pill.format}](fg:black bg:${pill.bg})";

      firstPill = builtins.elemAt pills 0;
      lastPill = last pills;
      firstFormattedPill = "${mkStart firstPill.bg}${mkContent firstPill}";
      tailFormattedPills = map (pill: "${mkTransition pill.bg}${mkContent pill}") (tail pills);
      format = "${concatStrings (
        [ firstFormattedPill ] ++ tailFormattedPills ++ [ (mkEnd lastPill.bg) ]
      )}";

    in
    format;

  osUserStyle = "fg:black bg:${osUserColor}";
  langStyle = "bg:${langColor}";
  envStyle = "bg:${envColor}";
  mkSimpleStyle = format: style: {
    inherit style;
    format = "[ ${format} ]($style)";
  };
in
{
  programs.starship.settings = mkIf config.programs.starship.enable {
    format = "($cmd_duration$status$line_break)${formattedPills}$line_break$character ";

    # Previous Command
    cmd_duration = {
      disabled = false;
      show_milliseconds = true;
      format = " in $duration ";
      style = "bg:bright-white";
      min_time_to_notify = 45000;
    };

    # OS + User
    os = {
      disabled = false;
      style = "bg:red fg:black";
      symbols = {
        NixOS = " ";
        Windows = "";
        Ubuntu = "󰕈";
        SUSE = "";
        Raspbian = "󰐿";
        Mint = "󰣭";
        Macos = "󰀵";
        Manjaro = "";
        Linux = "󰌽";
        Gentoo = "󰣨";
        Fedora = "󰣛";
        Alpine = "";
        Amazon = "";
        Android = "";
        AOSC = "";
        Arch = "󰣇";
        Artix = "󰣇";
        CentOS = "";
        Debian = "󰣚";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
      };
    };
    username = {
      show_always = true;
      style_user = "bg:red fg:black";
      style_root = "bg:red fg:black";
      format = "[ $user]($style)";
    };
    hostname = mkSimpleStyle "$ssh_symbol$hostname" osUserStyle;

    # Directory
    directory = {
      style = "bg:orange fg:black";
      format = "[ $path ]($style)";
      truncation_length = 3;
      truncation_symbol = "…/";
      substitutions = {
        Documents = "󰈙 ";
        Downloads = " ";
        Music = "󰝚 ";
        Pictures = " ";
        Developer = "󰲋 ";
      };
    };

    # Git
    git_branch = {
      symbol = "";
      style = "bg:yellow";
      format = "[[ $symbol $branch ](fg:black bg:yellow)]($style)";
    };
    git_status = {
      style = "bg:yellow";
      format = "[[($all_status$ahead_behind )](fg:black bg:yellow)]($style)";
    };
    git_commit = {
      style = "bg:yellow";
      format = "[[(\\($hash$tag\\) )](fg:black bg:yellow)]($style)";
    };

    # Languages
    nodejs = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    bun = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    c = {
      symbol = " ";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    rust = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    golang = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    php = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    java = {
      symbol = " ";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    kotlin = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    haskell = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version) ](fg:black bg:green)]($style)";
    };
    python = {
      symbol = "";
      style = langStyle;
      format = "[[ $symbol( $version)(\\(#$virtualenv\\)) ](fg:black bg:green)]($style)";
    };
    dotnet = {
      symbol = " ";
      style = langStyle;
      format = "[[ $symbol($version )(🎯 $tfm ) ](fg:black bg:cyan)]($style)";
    };

    # Environments
    docker_context = {
      symbol = "";
      style = envStyle;
      format = "[[ $symbol( $context) ](fg:black bg:cyan)]($style)";
    };
    conda = {
      symbol = "  ";
      style = "fg:black bg:cyan";
      format = "[$symbol$environment ]($style)";
      ignore_base = false;
    };
    direnv = {
      symbol = "  ";
      allowed_msg = "󰄴 ";
      not_allowed_msg = " ";
      loaded_msg = "󱥿 ";
      unloaded_msg = "󱧋 ";
      style = "fg:black bg:cyan";
      format = "[ $symbol\\($loaded$allowed\\) ]($style)";
    };
    nix_shell = {
      symbol = " ";
      style = "fg:black bg:cyan";
      format = "[ $symbol$name ]($style)";
    };
    shlvl = {
      style = "fg:black bg:cyan";
      format = "[ $symbol$shlvl ]($style)";
    };
    kubernetes = mkSimpleStyle "$symbol$context( \($namespace\))" envStyle;
    helm = mkSimpleStyle "$symbol($version)" envStyle;

    # Time
    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:bright-white";
      format = "[[  $time ](fg:black bg:bright-white)]($style)";
    };

    # Shell
    shell = {
      style = "fg:black bg:purple";
      format = "[ $indicator ]($style)";
    };

    character = {
      disabled = false;
      success_symbol = "[󱢇](bold fg:green)";
      error_symbol = "[󱢇](bold fg:red)";
      vimcmd_symbol = "[❮](bold fg:green)";
      vimcmd_replace_one_symbol = "[❮](bold fg:bright-white)";
      vimcmd_replace_symbol = "[❮](bold fg:bright-white)";
      vimcmd_visual_symbol = "[❮](bold fg:yellow)";
    };
  };
}
