{ lib }:
with lib;
let
  # _test = recursiveGenAttrs
  #   [
  #     ["devShells"]
  #     config.systems
  #     (cursor: (attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir (cfg.src + (elemAt cursor 0))))))
  #   ]
  #   (
  #     cursor:
  #     let
  #       src = cfg.src + "/${elemAt cursor 0}/${elemAt cursor 2}";
  #     in
  #     load src
  #   );

  gen' =
    cursor:
    nestedNamesFn:
    fn:
    let
      firstNamesFn = elemAt nestedNamesFn 0;
      namesFn = if isFunction firstNamesFn then firstNamesFn else (_: firstNamesFn);
      attrs =
        genAttrs
          (namesFn cursor)
          (
            n:
            let
              cursor' = cursor ++ [ n ];
              restNestedNamesFn = sublist 1 ((length nestedNamesFn) - 1) nestedNamesFn;
              recursiveValue =
                gen'
                  cursor'
                  restNestedNamesFn
                  fn;
              leafValue =
                fn cursor';
              value =
                if restNestedNamesFn == [ ]
                then leafValue
                else recursiveValue;
            in
            value
          );
    in
    attrs;

in
gen' [ ]
