# Elemento Script Builder

## Elemento

`elemento:CreateScript(repo: string, elevatedPrivilege: bool?, runAs: string?): Script`

Creates a new script containing the code from the provided `repo`. 
- The `repo` should be in the format of `https://api.github.com/repos/{user}/{repo}/contents/{filePath}`
- If `elevatedPrivilege` is false or empty, the script will only be able to modify the instances that it creates.
- If `elevatedPrivilege` is true, the script will be able to modify any instances that the `runAs` has access to:
  - If `runAs` is set to a faction, the script can modify anything belong to the faction.
  - If `runAs` is left empty, the script can modify anything that you have access to, including anything belonging to the factions that you are a member of.

---
`elemento:GetLocalPlayer(player: Player): LocalPlayer`

Returns a `LocalPlayer` instance that is used to detect input for the given `player`.

---
`elemento:GetMyPlayer(): Player?`

Returns the `Player` that the current execution context belongs to. Returns `nil` if the script is running in a faction context or if the player is not currently in the game.

---
`elemento:CreateFaction(factionName: string)`

Creates a faction with the given name. You can only own one faction at a time.

---
`elemento:InviteToFaction(factionName: string, player: Player)`

Adds `player` to the given faction. This can only be called by the faction owner.

---
`elemento:KickFromFaction(factionName: string, player: Player)`

Removes `player` from the given faction. This can only be called by the faction owner.

---
`elemento:TransferFactionOwnership(factionName: string, newOwner: Player)`

Changes the owner of the given faction to `newOwner`. This can only be called by the faction owner.

---
## LocalPlayer

`LocalPlayer:GetService(service: string): Service`

Returns a client-specific service. Currently, the only available service is [ContextActionService](https://create.roblox.com/docs/reference/engine/classes/ContextActionService).

---
`LocalPlayer:GetMouse(): Mouse`

Returns the client's [Mouse](https://create.roblox.com/docs/reference/engine/classes/Mouse).

---
## Instance
The following methods can be called on any instances.

`Instance:CanAccess(): bool`

Returns true if the current script execution context has access to modify the instance.

---
`Instance:GetOwner(): string`

Returns the owner of the instance. 
- If the instance belongs to a faction, this will return the faction name.
- If the instance belongs to a player, this will return the player's UserId.
