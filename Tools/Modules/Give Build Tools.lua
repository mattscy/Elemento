local function GiveTool(name)
    local player = elemento:GetMyPlayer()
    
    local tool = player.Backpack:FindFirstChild(name)
    if tool then tool:Destroy() end
    
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.CanBeDropped = false
    tool.RequiresHandle = false
    
    local scr = elemento:CreateScript(
        `https://github.com/mattscy/Elemento/blob/main/Tools/{game:GetService("HttpService"):UrlEncode(name)}.lua`,
        true
    )
    scr.Parent = tool
    
    tool.Parent = player.Backpack
end

GiveTool("Create Part")
GiveTool("Delete Part")


return true