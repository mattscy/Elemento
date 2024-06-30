local ToolLib = require("https://github.com/mattscy/Elemento/blob/main/Tools/Modules/ToolLib.lua")
local PLR = game:GetService("Players")

local startSize, startCF
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
            if not startSize and debounce == currentDebounce then
                ToolLib.StartFreeMove()
            end
        end)
    end))

    table.insert(selectMaid, mouse.Button1Up:Connect(function()
        debounce += 1
        startSize = nil
        startCF = nil

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

        handles.MouseButton1Down:Connect(function()
            startSize = selectedPart.Size
            startCF = selectedPart.CFrame
        end)

        handles.MouseDrag:Connect(function(face, dist)
            dist = math.round(dist)

            local normal = Vector3.fromNormalId(face)
            local absNormal = Vector3.new(
                math.abs(normal.X),
                math.abs(normal.Y),
                math.abs(normal.Z)
            )

            local newSize = startSize + absNormal*dist
            if math.min(newSize.X, newSize.Y, newSize.Z) > 0 then
                selectedPart.Size = newSize
                selectedPart.CFrame = startCF*(normal*dist/2)
            end
        end)
    end
end