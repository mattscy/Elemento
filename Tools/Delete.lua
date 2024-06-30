script.Parent.Equipped:Connect(function()
    ToolLib.StartSelecting(Color3.new(1, 0, 0))
end)

script.Parent.Unequipped:Connect(function()
    ToolLib.StopSelecting()
end)

script.Parent.Activated:Connect(function()
    local selectedPart = ToolLib.GetSelectedPart()
    if selectedPart then
        ToolLib.DeselectPart()
        selectedPart:Destroy()

        ToolLib.StartSelecting(Color3.new(1, 0, 0))
    end
end)