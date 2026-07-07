{ lib, ... }:
with lib;

# fixedDimension := [ {...} ]
# normalizedDimension := {...} -> {...} -> [ {...} ]
# dimension := [ {...} ] | {...} -> ( [ {...} ] | {...} -> [ {...} ] )
# [ dimension ] -> fixedDimension
dimensions:
let
  # dimension -> normalizedDimension
  normalizeDimension =
    dimension:
    if isList dimension then
      _: x: map (mergeAttrs x) dimension
    else if isFunction dimension then
      x:
      let
        innerDimension = dimension x;
      in
      if isList innerDimension then
        y: map (mergeAttrs y) innerDimension
      else if isFunction innerDimension then
        innerDimension
      else
        throw "WRONG TYPE: ${typeOf dimension} / ${typeOf innerDimension}"
    else
      throw "WRONG TYPE: ${typeOf dimension}";

  # [ normalizedDimension ]
  normalizedDimensions = map normalizeDimension dimensions;

  seed = [ { } ];

  # fixedDimension -> normalizedDimension -> fixedDimension
  applyOnce = acc: cur: concatMap (cur _) acc;

  # fixedDimension
  fixedPoints = foldl applyOnce seed normalizedDimensions;
in
fixedPoints
