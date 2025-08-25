let
  __value = type: data: {
    inherit type data;
  };
in
{
  boolValue = __value "bool";
  uintValue = __value "uint";
  uint64Value = __value "uint64";
  byteValue = __value "byte";
  stringValue = __value "string";
}
