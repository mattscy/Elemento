local RowHeight = 12


local window = Instance.new("Frame")
window.Size = UDim2.new(0, 300, 1, 0)
window.AnchorPoint = Vector2.new(1, 0)
window.Position = UDim2.fromScale(1, 0)

local explorer = Instance.new("ScrollingFrame")
explorer.Size = UDim2.fromScale(1, 0.5)
explorer.BackgroundColor3 = Color3.new(0, 0, 0)
explorer.BorderColor3 = Color3.new(1, 1, 1)
explorer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local properties = explorer:Clone()
properties.Position = UDim2.fromScale(0, 0.5)

local ui = Instance.new("ScreenGui")
ui.Enabled = false

properties.Parent = window
explorer.Parent = window
window.Parent = ui
ui.Parent = elemento:GetMyPlayer().PlayerGui


local FrameCache = {}

local function AddInstance(inst)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Name = inst.Name

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, RowHeight)
    button.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderColor3 = Color3.fromRGB(200, 200, 200)
    button.Text = inst.Name
    button.Name = "Instance"

    local children = Instance.new("Frame")
    children.Size = UDim2.fromScale(1, 0)
    children.Position = UDim2.fromOffset(0, RowHeight)
    children.AutomaticSize = Enum.AutomaticSize.Y
    children.BackgroundTransparency = 1
    children.Name = "Children"

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.Name

    button.Parent = frame
    list.Parent = children
    children.Parent = frame

    if inst ~= game then
        frame.Parent = FrameCache[inst.Parent].Children
    else
        frame.Parent = explorer
    end

    FrameCache[inst] = frame

    local expanded = false
    button.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            for _, child in pairs(inst:GetChildren()) do
                if FrameCache[child] then
                    FrameCache[child].Visible = true
                else
                    AddInstance(child)
                end
            end
        else
            for _, child in pairs(inst:GetChildren()) do
                FrameCache[child].Visible = false
            end
        end
    end)

    inst.ChildAdded:Connect(function(child)
        if expanded then
            AddInstance(child)
        end
    end)

    inst.ChildRemoved:Connect(function(child)
        if FrameCache[child] then
            FrameCache[child]:Destroy()
            FrameCache[child] = nil
        end
    end)
end
AddInstance(game)


script.Parent.Equipped:Connect(function()
    ui.Enabled = true
end)

script.Parent.Unequipped:Connect(function()
    ui.Enabled = false
end)