local ToolLib


local dragStartCF

script.Parent.Equipped:Connect(function()
    ToolLib.StartSelecting(Color3.new(0, 1, 1))
end)

script.Parent.Unequipped:Connect(function()
    ToolLib.StopSelecting()
end)

script.Parent.Activated:Connect(function()
    local handles = ToolLib.SelectPart()

    if handles then
        handles.HandlesStyle = Enum.HandlesStyle.Movement

        handles.MouseButton1Down:Connect(function()
            dragStartCF = selectedPart:GetPivot()
        end)

        handles.MouseDrag:Connect(function(face, dist)
            selectedPart.CFrame = dragStartCF * CFrame.new(Vector3.fromNormalId(face)*math.round(dist))
        end)
    end
end)
