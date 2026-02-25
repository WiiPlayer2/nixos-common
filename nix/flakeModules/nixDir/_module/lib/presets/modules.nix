{
  lib,
  import-tree,
  inputs,
  root,
}:
{
  apply ? (x: x),

  config ? { },
}:
{
  loadByAttribute = true;

  loader = args: apply (root.loaders.modules args);
}
// config
