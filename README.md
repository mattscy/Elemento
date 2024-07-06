# Elemento Script Builder

## elemento

`elemento:CreateScript(file: string, elevatedPrivilege: bool?, runAs: string?): Script`

Creates a new script containing the code from the provided GitHub `file`. 
- The `file` should be in the format of `https://github.com/{user}/{repo}/blob/main/{path}`
- If `elevatedPrivilege` is false or empty, the script will only be able to modify:
  - Instances that the script creates, and
  - Instances that are a descendant of the script's Parent.
- If `elevatedPrivilege` is true, the script will be able to modify any instances that the `runAs` has access to:
  - If `runAs` is set to a faction, the script can modify anything belonging to the faction.
  - If `runAs` is left empty, the script can modify anything that you have access to, including anything belonging to the factions that you are a member of.

---
`elemento:CreatePrivateScript(secret: Secret, file: string, elevatedPrivilege: bool?, runAs: string?): Script`

Creates a new script containing the code from a `file` in a private GitHub repository. Accepts a `secret` that contains the access token for the repository. See [Secret](https://github.com/mattscy/Elemento/blob/main/README.md#secret) for details on generating the secret.

---
`elemento:GetMyPlayer(): Player?`

Returns the `Player` that the current execution context belongs to. Returns `nil` if the script is running in a faction context or if the player is not currently in the game.

---
`elemento:GetMyInstances(): Instance[]`

Returns an array of all objects that have been directly created by the faction or player that the script is executing as.

---
`elemento:GetPersonalFolder(): Folder`

Returns a folder that only the current `runAs` context (i.e. the player or faction running the script) can parent instances to.

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
## Script

`Script:UpdateSource()`

When creating a script from `elemento:CreateScript`, the source code will be cached. This function should be used to re-sync the script to use the latest version of the code from GitHub.

---
## Player

`Player:GetService(service: string): Service`

Returns a client-specific service. Currently, the only available service is [ContextActionService](https://create.roblox.com/docs/reference/engine/classes/ContextActionService).

---
`Player:GetMouse(): Mouse`

Returns the client's [Mouse](https://create.roblox.com/docs/reference/engine/classes/Mouse).

---
`Player:GetLocalFolder(): Folder`

Returns a folder that can be used to store instances that should only be visible to this client.

---
## Instance
`Instance.new(className: string, faction: string?): Instance`

Creates a new instance of the given `className`. By default, the instance will be owned by the faction or the user that the script is running as. The `faction` should be specified if the script is running as a user and you want the instance to belong to a specific faction rather than that user.

---
`Instance:CanAccess(): bool`

Returns true if the current script execution context has permissions to modify the instance.

---
`Instance:GetOwner(): string`

Returns the owner of the instance. 
- If the instance belongs to a faction, this will return the faction name.
- If the instance belongs to a player, this will return the player's UserId.

---
`Instance.Archivable: bool`

Set Archivable to false for instances that should not be saved between game sessions.

---
## BindableEvent

`BindableEvent.EventWithContext(runAs: string, elevatedPrivileges: bool, ...)`

This event behaves the same as the regular `BindableEvent.Event`, but it also includes information about the context of the script that fired the event:
- The `runAs` will either be the UserId or faction name of the player/faction that "owns" the firing script.
- The `elevatedPrivileges` will be true if the firing script is running with elevated privileges.

---
## BindableFunction

`BindableFunction.OnInvokeWithContext(runAs: string, elevatedPrivileges: bool, ...): ...`

This callback behaves the same as the regular `BindableFunction.OnInvoke`, but it also includes information about the context of the script that invoked the function:
- The `runAs` will either be the UserId or faction name of the player/faction that "owns" the invoking script.
- The `elevatedPrivileges` will be true if the invoking script is running with elevated privileges.

---
## Secret

`Secret.new(token: string, uses: number?): Secret`

Returns a Secret that encapsulates a GitHub access token. This is for use with `elemento:CreatePrivateScript`.

Follow these steps to create an access token for a private repository:
1. Navigate to [https://github.com/settings/personal-access-tokens/new](https://github.com/settings/personal-access-tokens/new) and sign in.
2. Set the "Token name" and "Expiration" of the token.
3. Under "Repository access" select "Only select repositories".
4. Expand "Select repositories" and select your private repository.
5. Expand "Repository permissions" and set the "Contents" permission to "Access: Read-only".
6. Select "Generate token" and copy the token string.

---
`Secret:GetUses(): number`

Returns the number of uses remaining for the secret. If there are zero uses remaining then the secret can no longer be used to authorise requests.

---
## Other

`require(file: string): any`

Loads the code from a GitHub file and executes it in the current context, returning a value in a similar way to module scripts. Note that this will yield and load the latest version of the file's code without caching it. The `file` argument should be a GitHub file path in the format of `https://github.com/{user}/{repo}/blob/main/{path}`.
