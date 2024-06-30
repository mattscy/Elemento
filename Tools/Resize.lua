local ToolLib = require("https://github.com/mattscy/Elemento/blob/main/Tools/Modules/ToolLib.lua")
local PLR = game:GetService("Players")

local lastSize
local selectMaid = {}


script.Parent.Equipped:Connect(function()

    local highlight = ToolLib.StartSelecting()
    highlight.FillColor = Color3.new(0, 1, 1)

    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    local mouse = player:GetMouse()

    local debounce = 0
    table.insert(selectMaid, mouse.Button1Down:Connect(function()
        debounce += 1
        local currentDebounce = debounce
        
        task.defer(function()
            if not lastSize and debounce == currentDebounce then
                ToolLib.StartFreeMove()
            end
        end)
    end))

    table.insert(selectMaid, mouse.Button1Up:Connect(function()
        debounce += 1
        lastSize = nil

        CreateHandles()
    end))
    
end)


script.Parent.Unequipped:Connect(function()
    for _, conn in pairs(selectMaid) do
        conn:Disconnect()
    end
    selectMaid = {}

    ToolLib.StopFreeMove()
    ToolLib.DeselectPart()
    ToolLib.StopSelecting()
    ToolLib.ClearSelection()
end)


function CreateHandles()
    local handles = ToolLib.SelectPart()

    if handles then
        local selectedPart = ToolLib.GetSelectedPart()

        handles.Style = Enum.HandlesStyle.Resize

        handles.MouseButton1Down:Connect(function(face)
            lastSize = 0
        end)

        handles.MouseDrag:Connect(function(face, dist)
            selectedPart:Resize(face, dist - lastSize)
            lastSize = dist
        end)
    end
end