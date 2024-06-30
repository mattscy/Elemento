local ToolLib = require("https://github.com/mattscy/Elemento/blob/main/Tools/Modules/ToolLib.lua")


script.Parent.Equipped:Connect(function()
    local highlight = ToolLib.StartSelecting()
    highlight.FillColor = Color3.new(1, 0, 0)
end)

script.Parent.Unequipped:Connect(function()
    ToolLib.StopSelecting()
    ToolLib.ClearSelection()
end)

script.Parent.Activated:Connect(function()
    local selectedPart = ToolLib.GetSelectedPart()
    if selectedPart then
        ToolLib.StopSelecting()
        selectedPart:Destroy()

        ToolLib.StartSelecting(Color3.new(1, 0, 0))
    end
end)