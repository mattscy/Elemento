local PLR = game:GetService("Players")

local placingPart
local placementMaid = {}


function GetLocalPlayer()
    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    return elemento:GetLocalPlayer(player)
end


function StartPlacing()
    StopPlacing()

    local lp = GetLocalPlayer()
    local mouse = lp:GetMouse()

    placingPart = Instance.new("Part")
    placingPart.Size = Vector3.new(2, 2, 2)
    placingPart.TopSurface = Enum.SurfaceType.Smooth
    placingPart.BottomSurface = Enum.SurfaceType.Smooth
    placingPart.Anchored = true
    placingPart.CanCollide = false
    placingPart.CanQuery = false
    placingPart.Transparency = 0.5
    placingPart.Parent = lp:GetLocalFolder()

    table.insert(placementMaid, mouse.Move:Connect(function()
        local mousePos = mouse.Hit.Position
        placingPart.CFrame = CFrame.new(
            math.round(mousePos.X),
            math.round(mousePos.Y),
            math.round(mousePos.Z)
        )
    end))
end


function StopPlacing()
    for _, conn in pairs(placementMaid) do
        conn:Disconnect()
    end
    placementMaid = {}

    if placingPart then
        placingPart:Destroy()
        placingPart = nil
    end
end


function Place()
    if placingPart then
        placingPart.Transparency = 0
        placingPart.CanCollide = true
        placingPart.CanQuery = true
        placingPart.Parent = workspace
        placingPart = nil
    end
end


script.Parent.Equipped:Connect(StartPlacing)
script.Parent.Unequipped:Connect(StopPlacing)
script.Parent.Activated:Connect(Place)