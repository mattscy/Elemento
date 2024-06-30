local PLR = game:GetService("Players")

local FreeMove = require("https://github.com/mattscy/Elemento/blob/main/Tools/Modules/Free%20Move%20Part.lua")

local handles
local selectedPart
local selectMaid = {}
local dragStartPos


function OnEquip()
    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    local mouse = player:GetMouse()

    local debounce = 0
    table.insert(selectMaid, mouse.Button1Down:Connect(function()
        debounce += 1
        local currentDebounce = debounce

        task.defer(function()
            if not dragStartCF and debounce == currentDebounce then
                DeselectPart()
                FreeMove.StartFreeMove()
            end
        end)
    end))

    table.insert(selectMaid, mouse.Button1Up:Connect(function()
        dragStartCF = nil
        debounce += 1

        FreeMove.StopFreeMove()
        SelectPart()
    end))

end


function OnUnequip()
    for _, conn in pairs(selectMaid) do
        conn:Disconnect()
    end
    selectMaid = {}

    FreeMove.StopFreeMove()
    DeselectPart()
end


function SelectPart()
    DeselectPart()

    if selectedPart then
        local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)

        handles = Instance.new("Handles")
        handles.Style = Enum.HandlesStyle.Movement
        handles.Archivable = false
        handles.Adornee = selectedPart
        handles.Parent = player.PlayerGui

        handles.MouseButton1Down:Connect(function()
            dragStartCF = selectedPart:GetPivot()
        end)

        handles.MouseDrag:Connect(function(face, dist)
            selectedPart.CFrame = dragStartCF * CFrame.new(Vector3.fromNormalId(face)*math.round(dist))
        end)
    end
end


function DeselectPart()
    if handles then
        handles:Destroy()
        handles = nil
    end
end


script.Parent.Equipped:Connect(OnEquip)
script.Parent.Unequipped:Connect(OnUnequip)