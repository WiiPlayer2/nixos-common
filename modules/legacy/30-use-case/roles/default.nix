{ lib, ... }:
with lib;
let
  toLegacy =
    names:
    mkRenamedOptionModule
      (
        [
          "my"
          "roles"
        ]
        ++ names
      )
      (
        [
          "my"
          "roles"
          "legacy"
        ]
        ++ names
      );
in
{
  imports = [
    (toLegacy [
      "personal"
      "phone"
    ])
    (toLegacy [
      "work"
      "default"
    ])
    ./legacy
  ];
}
