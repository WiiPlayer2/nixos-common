{
  writeShellApplication,

  rofi,
  autorandr,
}:
writeShellApplication {
  name = "display-menu";
  runtimeInputs = [
    rofi
    autorandr
  ];
  # https://csaratakij.github.io/RofiMenuGenerator/
  text = ''
    #!/bin/sh

    MENU="Load first detected profile|Cycle profile|Clone all connected outputs at the largest common resolution|Clone all connected outputs with the largest resolution (scaled down if necessary)|Stack all connected outputs horizontally at their largest resolution|Stack all connected outputs vertically at their largest resolution|Stack all connected outputs horizontally at their largest resolution in reverse order|Stack all connected outputs vertically at their largest resolution in reverse order"

    DIALOG_RESULT=$(echo "$MENU" | rofi -sep "|" -dmenu -i -p "Display Menu" -tokenize -lines 5 -width 50 -padding 50 -disable-history)

    echo "This result is : $DIALOG_RESULT"
    sleep 1;

    if [ "$DIALOG_RESULT" = "Load first detected profile" ];
    then
      exec autorandr --change

    elif [ "$DIALOG_RESULT" = "Cycle profile" ];
    then
      exec autorandr --cycle

    elif [ "$DIALOG_RESULT" = "Clone all connected outputs at the largest common resolution" ];
    then
      exec autorandr common

    elif [ "$DIALOG_RESULT" = "Clone all connected outputs with the largest resolution (scaled down if necessary)" ];
    then
      exec autorandr common-largest

    elif [ "$DIALOG_RESULT" = "Stack all connected outputs horizontally at their largest resolution" ];
    then
      exec autorandr horizontal

    elif [ "$DIALOG_RESULT" = "Stack all connected outputs vertically at their largest resolution" ];
    then
      exec autorandr vertical

    elif [ "$DIALOG_RESULT" = "Stack all connected outputs horizontally at their largest resolution in reverse order" ];
    then
      exec autorandr horizontal-reverse

    elif [ "$DIALOG_RESULT" = "Stack all connected outputs vertically at their largest resolution in reverse order" ];
    then
      exec autorandr vertical-reverse
    fi
  '';
}
