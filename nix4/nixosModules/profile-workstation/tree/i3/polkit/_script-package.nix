{
  fetchurl,
  writeShellApplication,

  python313,
  rofi,
}:
let
  scriptSrc = fetchurl {
    url = "https://github.com/OmarCastro/cmd-polkit/raw/refs/heads/master/examples/scripts/rofi-example-with-fprintd-so.py";
    hash = "sha256-vq407ZIIp+4z19JUD1bMOjR4z6elbvTGObgNiKHLbc4=";
  };

  python = python313;

  package = writeShellApplication {
    name = "rofi-cmd-polkit";
    runtimeInputs = [
      python
      rofi
    ];
    text = ''
      exec python ${scriptSrc}
    '';
  };
in
package
