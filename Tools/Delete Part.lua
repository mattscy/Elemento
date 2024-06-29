local PLR = game:GetService("Players")

local deleteHighlight
local selectedPart

local deleteMaid = {}


function StartDeleting()
    StopDeleting()

    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    local mouse = player:GetMouse()

    deleteHighlight = Instance.new("Highlight")
    deleteHighlight.FillTransparency = 0.5
    deleteHighlight.FillColor = Color3.new(1, 0, 0)
    deleteHighlight.Archivable = false
    deleteHighlight.Parent = player:GetLocalFolder()

    table.insert(deleteMaid, mouse.Move:Connect(function()
        selectedPart = mouse.Target
        if selectedPart and not selectedPart:CanAccess() then
            selectedPart = nil
        end
        deleteHighlight.Adornee = selectedPart
    end))
end


function StopDeleting()
    for _, conn in pairs(deleteMaid) do
        conn:Disconnect()
    end
    deleteMaid = {}

    if deleteHighlight then
        deleteHighlight:Destroy()
        deleteHighlight = nil
    end
end


function Delete()
    if selectedPart then
        selectedPart:Destroy()
        selectedPart = nil

        StartDeleting()
    end
end


script.Parent.Equipped:Connect(StartDeleting)
script.Parent.Unequipped:Connect(StopDeleting)
script.Parent.Activated:Connect(Delete)