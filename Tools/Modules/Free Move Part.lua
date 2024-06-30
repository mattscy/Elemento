local FreeMove = {}

local CAS
local selectedPart
local Epsilon = 0.1
local freeMoveMaid = {}
local freeMoveRot = CFrame.new()


local SurfaceAxisMap = {
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


function FreeMove.StartFreeMove()
    FreeMove.StopFreeMove()

    local player = PLR:GetPlayerFromCharacter(script.Parent.Parent)
    local mouse = player:GetMouse()
    CAS = player:GetService("ContextActionService")

    selectedPart = mouse.Target
    if selectedPart and not selectedPart:CanAccess() then
        selectedPart = nil
    end
    if selectedPart then
        selectedPart.CanQuery = false
        selectedPart.CanCollide = false
        selectedPart.Archivable = false
        selectedPart.Transparency = 0.5

        local function MoveStep()
            local target = mouse.Target

            if target then

                local mousePos = mouse.Hit.Position
                local mouseSurface = mouse.TargetSurface

                local rot = target.CFrame.Rotation * freeMoveRot

                local normal = target.CFrame.Rotation * Vector3.fromNormalId(mouseSurface)
                local perpNormal = target.CFrame.Rotation * Vector3.fromNormalId(PerpSurfaceMap[mouseSurface])
                
                local axis = SurfaceAxisMap[mouseSurface]
                local targetSurfaceMidPos = target.Position + normal*(target.Size[axis]/2)
                local targetSurfaceMidCF = CFrame.lookAlong(targetSurfaceMidPos, normal, perpNormal)

                local offsetDist
                if rot.LookVector:FuzzyEq(normal, Epsilon) or rot.LookVector:FuzzyEq(-normal, Epsilon) then
                    offsetDist = selectedPart.Size.Z/2
                elseif rot.RightVector:FuzzyEq(normal, Epsilon) or rot.RightVector:FuzzyEq(-normal, Epsilon) then
                    offsetDist = selectedPart.Size.X/2
                else
                    offsetDist = selectedPart.Size.Y/2
                end

                local midOffset = mousePos - targetSurfaceMidPos
                local longDist = math.round(midOffset:Dot(targetSurfaceMidCF.RightVector))
                local latDist = math.round(midOffset:Dot(targetSurfaceMidCF.UpVector))

                local pos = targetSurfaceMidPos
                    + targetSurfaceMidCF.RightVector*longDist
                    + targetSurfaceMidCF.UpVector*latDist
                    + targetSurfaceMidCF.LookVector*offsetDist

                selectedPart.CFrame = rot + pos

            end
        end

        table.insert(freeMoveMaid, mouse.Move:Connect(MoveStep))
        MoveStep()
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


function FreeMove.StopFreeMove()
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


return FreeMove