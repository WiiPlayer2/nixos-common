{ lib, super }:
with lib;
path: transformerConfig:
if isList transformerConfig then
  map (super.transformerForPath path) transformerConfig
else
  super.transformerForPath path transformerConfig
