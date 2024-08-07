
local sg = script.Parent:FindFirstChildOfClass("SurfaceGui")
if not sg then
    sg = Instance.new("SurfaceGui")

    local screen = Instance.new("TextLabel")
    screen.BackgroundTransparency = 1
    screen.Size = UDim2.fromScale(1, 1)
    screen.TextScaled = true
    screen.Text = "Click to check balance"
    screen.Name = "Screen"

    screen.Parent = sg
    sg.Parent = script.Parent
end

local cd = script.Parent:FindFirstChildOfClass("ClickDetector")
if not cd then
    cd = Instance.new("ClickDetector")
    cd.Parent = script.Parent
end


local debounce = true
cd.MouseClick:Connect(function(player)
    if not debounce then return end
    debounce = false

    local account = elemento:GetPersonalFolder().Bank.Accounts:FindFirstChild(tostring(player.UserId))
    if account then
        sg.Screen.Text = player.Name .. "'s Balance: $" .. tostring(account.Value)
    else
        sg.Screen.Text = "Account not found"
    end

    task.wait(3)
    sg.Screen.Text = "Click to check balance"

    debounce = true
end)