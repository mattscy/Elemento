local PLR = game:GetService("Players")
local LS = game:GetService("LogService")

local tool = script.Parent

local sg = Instance.new("ScreenGui")
sg.Archivable = false
sg.Enabled = false

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 100, 1, -100)
container.AnchorPoint = Vector2.new(0.5, 0)
container.Position = UDim2.fromScale(0.5, 0)
container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
container.BorderColor3 = Color3.fromRGB(255, 255, 255)
container.SizeConstraint = Enum.SizeConstraint.RelativeYY
container.ClipsDescendants = false

local scroll = Instance.new("ScrollingFrame")
scroll.BackgroundColor3 = Color3.fromRGB(13, 17, 23)
scroll.BorderColor3 = Color3.fromRGB(255, 255, 255)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
scroll.Size = UDim2.new(1, -100, 0.6, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local terminal = Instance.new("TextBox")
terminal.Font = Enum.Font.Code
terminal.TextSize = 20
terminal.ClearTextOnFocus = false
terminal.MultiLine = true
terminal.Text = 'print("Hello Elemento!")'
terminal.TextColor3 = Color3.fromRGB(255, 255, 255)
terminal.BackgroundTransparency = 1
terminal.Size = UDim2.fromScale(1, 1)
terminal.AutomaticSize = Enum.AutomaticSize.XY
terminal.TextXAlignment = Enum.TextXAlignment.Left
terminal.TextYAlignment = Enum.TextYAlignment.Top

local outputScroll = Instance.new("ScrollingFrame")
outputScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
outputScroll.BorderColor3 = Color3.fromRGB(255, 255, 255)
outputScroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
outputScroll.Size = UDim2.new(1, 0, 0.4, 0)
outputScroll.Position = UDim2.new(0, 0, 0.6, 0)
outputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local output = Instance.new("TextLabel")
output.BackgroundTransparency = 1
output.TextColor3 = Color3.fromRGB(255, 255, 255)
output.TextSize = 20
output.AutomaticSize = Enum.AutomaticSize.XY
output.Font = Enum.Font.Code
output.Size = UDim2.new(1, -20, 1, 0)
output.TextXAlignment = Enum.TextXAlignment.Left
output.TextYAlignment = Enum.TextYAlignment.Top
output.Text = ""
output.BorderColor3 = Color3.fromRGB(255, 255, 255)

terminal.Parent = scroll
scroll.Parent = container
output.Parent = outputScroll
outputScroll.Parent = container
container.Parent = sg

local player = elemento:GetMyPlayer()
sg.Parent = player.PlayerGui

tool.Equipped:Connect(function()
    sg.Enabled = true
end)

tool.Unequipped:Connect(function()
    sg.Enabled = false
end)

local execute = Instance.new("TextButton")
execute.Size = UDim2.fromOffset(100, 20)
execute.TextScaled = true
execute.Text = "Execute"
execute.AnchorPoint = Vector2.new(1, 0)
execute.Position = UDim2.fromScale(1, 0)
execute.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
execute.Parent = container

execute.MouseButton1Click:Connect(function()
    local func, err = loadstring(terminal.Text)
    if func then
        pcall(func)
    else
        error("Error compiling script: " .. err)
    end
end)

local clearOutput = execute:Clone()
clearOutput.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
clearOutput.Position = UDim2.new(1, 0, 0, 30)
clearOutput.Text = "Clear Output"
clearOutput.Parent = container

clearOutput.MouseButton1Click:Connect(function()
    LS:ClearOutput()
    output.Text = ""
end)

LS.MessageOut:Connect(function(message, messageType)
    output.Text = message .. "\n" .. output.Text
end)
