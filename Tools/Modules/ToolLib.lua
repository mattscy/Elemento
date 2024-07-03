local ToolLib = {}

local PLR = game:GetService("Players")
local CAS
local selectedPart


ToolLib.SurfaceAxisMap = {
    [Enum.NormalId.Front] = "Z";
    [Enum.NormalId.Back] = "Z";
    [Enum.NormalId.Right] = "X";
    [Enum.NormalId.Left] = "X";
    [Enum.NormalId.Top] = "Y";
    [Enum.NormalId.Bottom] = "Y";
}

local PerpSurfaceMap = {
    [Enum.NormalId.Front] = Enum.NormalId.Top;
    [Enum.NormalId.Back] = Enum.NormalId.Top;
    [Enum.NormalId.Right] = Enum.NormalId.Top;
    [Enum.NormalId.Left] = Enum.NormalId.Top;
    [Enum.NormalId.Top] = Enum.NormalId.Front;
    [Enum.NormalId.Bottom] = Enum.NormalId.Front;
}

local PerpSurface2Map = {
    [Enum.NormalId.Front] = Enum.NormalId.Right;
    [Enum.NormalId.Back] = Enum.NormalId.Left;
    [Enum.NormalId.Right] = Enum.NormalId.Front;
    [Enum.NormalId.Left] = Enum.NormalId.Back;
    [Enum.NormalId.Top] = Enum.NormalId.Right;
    [Enum.NormalId.Bottom] = Enum.NormalId.Left;
}


-- FREE MOVEMENT

local Epsilon = 0.1
local freeMoveMaid = {}
local freeMoveRot = CFrame.new()
local unit = 1


function ToolLib.StartFreeMove()
    ToolLib.StopFreeMove()
    ToolLib.StopSelecting()
    ToolLib.DeselectPart()  

    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    local mouse = player:GetMouse()
    CAS = player:GetService("ContextActionService")

    selectedPart = mouse.Target
    if selectedPart and not selectedPart:CanAccess() then
        selectedPart = nil
    end
    if selectedPart then
        ToolLib.HighlightSelected()

        selectedPart.CanQuery = false
        selectedPart.CanCollide = false
        selectedPart.Archivable = false
        selectedPart.Transparency = 0.5

        local function MoveStep()
            local target = mouse.Target

            if target and target ~= selectedPart then

                local mousePos = mouse.Hit.Position
                local mouseSurface = mouse.TargetSurface

                local rot = target.CFrame.Rotation * freeMoveRot

                local normal = target.CFrame.Rotation * Vector3.fromNormalId(mouseSurface)
                local perpNormal = target.CFrame.Rotation * Vector3.fromNormalId(PerpSurfaceMap[mouseSurface])
                
                -- local axis = ToolLib.SurfaceAxisMap[mouseSurface]
                local targetSurfaceCornerPos = target.Position + normal*target.Size/2 -- (target.Size[axis]/2)
                local targetSurfaceCornerCF = CFrame.lookAlong(targetSurfaceCornerPos, normal, perpNormal)


                local offsetDist, partLatWidth, partLongWidth
                if rot.LookVector:FuzzyEq(normal, Epsilon) or rot.LookVector:FuzzyEq(-normal, Epsilon) then
                    offsetDist = selectedPart.Size.Z/2
                    if rot.UpVector:FuzzyEq(perpNormal, Epsilon) or rot.UpVector:FuzzyEq(-perpNormal, Epsilon) then
                        partLatWidth = selectedPart.Size.X
                        partLongWidth = selectedPart.Size.Y
                    else
                        partLatWidth = selectedPart.Size.Y
                        partLongWidth = selectedPart.Size.X
                    end
                elseif rot.RightVector:FuzzyEq(normal, Epsilon) or rot.RightVector:FuzzyEq(-normal, Epsilon) then
                    offsetDist = selectedPart.Size.X/2
                    if rot.UpVector:FuzzeEq(perpNormal, Epsilon) or rot.UpVector:FuzzeEq(-perpNormal, Epsilon) then
                        partLatWidth = selectedPart.Size.Z
                        partLongWidth = selectedPart.Size.Y
                    else
                        partLatWidth = selectedPart.Size.Y
                        partLongWidth = selectedPart.Size.Z
                    end
                else
                    offsetDist = selectedPart.Size.Y/2
                    if rot.LookVector:FuzzeEq(perpNormal, Epsilon) or rot.LookVector:FuzzeEq(-perpNormal, Epsilon) then
                        partLatWidth = selectedPart.Size.X
                        partLongWidth = selectedPart.Size.Z
                    else
                        partLatWidth = selectedPart.Size.Z
                        partLongWidth = selectedPart.Size.X
                    end
                end
                
                local midOffset = mousePos - targetSurfaceCornerPos
                local longDist = midOffset:Dot(targetSurfaceCornerCF.RightVector)
                local latDist = midOffset:Dot(targetSurfaceCornerCF.UpVector)
                
                local latWidth = target.Size[ToolLib.SurfaceAxisMap[PerpSurfaceMap[mouseSurface]]]
                if math.round(latWidth/unit)%2 == math.round(partLatWidth/unit)%2 then
                    latDist = math.floor(latDist/unit + 0.5)*unit
                else
                    latDist = (math.floor(latDist/unit) + 0.5)*unit
                end

                local longWidth = target.Size[ToolLib.SurfaceAxisMap[PerpSurface2Map[mouseSurface]]]
                if math.round(longWidth/unit)%2 == math.round(partLongWidth/unit)%2 then
                    longDist = math.floor(longDist/unit + 0.5)*unit
                else
                    longDist = (math.floor(longDist/unit) + 0.5)*unit
                end

                local pos = targetSurfaceCornerPos
                    + targetSurfaceCornerCF.RightVector*longDist
                    + targetSurfaceCornerCF.UpVector*latDist
                    + targetSurfaceCornerCF.LookVector*offsetDist

                selectedPart.CFrame = rot + pos

            end
        end

        table.insert(freeMoveMaid, mouse.Move:Connect(MoveStep))
        MoveStep()

    else
        ToolLib.ClearSelection()
    end

    CAS:BindAction("Rotate", function(name, state)
        if state == Enum.UserInputState.Begin then
            freeMoveRot *= CFrame.Angles(0, math.rad(90), 0)
        end
    end, false, Enum.KeyCode.R)

    CAS:BindAction("Turn", function(name, state)
        if state == Enum.UserInputState.Begin then
            freeMoveRot *= CFrame.Angles(math.rad(90), 0, 0)
        end
    end, false, Enum.KeyCode.T)
end


function ToolLib.StopFreeMove()
    for _, conn in pairs(freeMoveMaid) do
        conn:Disconnect()
    end
    freeMoveMaid = {}

    if selectedPart then
        selectedPart.CanCollide = true
        selectedPart.CanQuery = true
        selectedPart.Archivable = true
        selectedPart.Transparency = 0
    end

    if CAS then
        CAS:UnbindAction("Rotate")
        CAS:UnbindAction("Turn")
        CAS = nil
    end
end


-- SELECTION

local handles

function ToolLib.SelectPart()
    ToolLib.StopFreeMove()
    ToolLib.DeselectPart()
    ToolLib.StopSelecting()

    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)

    if selectedPart then
        handles = Instance.new("Handles")
        handles.Archivable = false
        handles.Adornee = selectedPart
        handles.Parent = player.PlayerGui

        return handles
    end
end


function ToolLib.DeselectPart()
    if handles then
        handles:Destroy()
        handles = nil
    end
end


function ToolLib.GetSelectedPart()
    return selectedPart
end


-- HOVER HIGHLIGHT

local highlight = Instance.new("Highlight")
highlight.FillTransparency = 0.5
highlight.Archivable = false

local hoverMaid = {}


function ToolLib.StartSelecting()
    ToolLib.StopSelecting()

    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    local mouse = player:GetMouse()

    highlight.Parent = player:GetLocalFolder()

    table.insert(hoverMaid, mouse.Move:Connect(function()
        selectedPart = mouse.Target
        if selectedPart and not selectedPart:CanAccess() then
            selectedPart = nil
        end
        highlight.Adornee = selectedPart
    end))

    return highlight
end


function ToolLib.StopSelecting()
    for _, conn in pairs(hoverMaid) do
        conn:Disconnect()
    end
    hoverMaid = {}
end


function ToolLib.HighlightSelected()
    if selectedPart then
        highlight.Adornee = selectedPart
    end
end


function ToolLib.ClearSelection()
    highlight.Adornee = nil
    selectedPart = nil
end



return ToolLib