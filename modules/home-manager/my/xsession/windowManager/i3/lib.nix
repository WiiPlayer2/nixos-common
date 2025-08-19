{ lib, config }:
rec {
  modifier = config.xsession.windowManager.i3.config.modifier;
  brightnessChange = "5%";
  moveToWorkspace = ws: "move container to workspace ${ws}; workspace ${ws}";
  moveWorkspace = output: "move workspace to output ${output}";
  workspaces = import ./workspaces.nix;
  workspaceIdentifier =
    workspace: number:
    if builtins.hasAttr "name" workspace then
      "\"${toString number}: ${workspace.name}\""
    else
      "number ${toString number}";
  workspaceKeyBindings =
    workspace: number:
    let
      identifier = workspaceIdentifier workspace number;
      numberKey = if number == 10 then "0" else toString number;
    in
    {
      "${modifier}+${numberKey}" = "workspace ${identifier}";
      "${modifier}+Shift+${numberKey}" = moveToWorkspace identifier;
    };
  allWorkspaceKeyBindings = lib.listToAttrs (
    builtins.concatMap
      (
        { workspace, number }: lib.attrsToList (workspaceKeyBindings workspace number)
      )
      (lib.imap (number: workspace: { inherit number workspace; }) workspaces)
  );
  workspaceHasAssigns = workspace: builtins.hasAttr "assigns" workspace;
  workspaceAssignsList =
    workspace: number:
    if workspaceHasAssigns workspace then
      [
        {
          name = workspaceIdentifier workspace number;
          value = workspace.assigns;
        }
      ]
    else
      [ ];
  allWorkspaceAssigns = lib.listToAttrs (
    builtins.concatMap ({ workspace, number }: workspaceAssignsList workspace number) (
      lib.imap (number: workspace: { inherit number workspace; }) workspaces
    )
  );
  loadProfile =
    name: inputs:
    let
      profilePath = ./profiles/${name}.nix;
      profile = import profilePath;
    in
    profile inputs;
}
