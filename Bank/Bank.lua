local PLR = game:GetService("Players")

local Accounts = script.Parent:FindFirstChild("Accounts")
if not Accounts then
    Accounts = Instance.new("Folder")
    Accounts.Name = "Accounts"
    Accounts.Parent = script.Parent
end


local function AddPlayer(player)
    local account = Accounts:FindFirstChild(tostring(player.UserId))
    if not account then
        account = Instance.new("IntValue")
        account.Value = 0
        account.Name = tostring(player.UserId)
        account.Parent = Accounts
    end
end

for _, player in pairs(PLR:GetPlayers()) do
    AddPlayer(player)
end
PLR.PlayerAdded:Connect(AddPlayer)


task.spawn(function()
    while true do
        task.wait(60)
        for _, account in pairs(Accounts:GetChildren()) do
            account.Value += 1
        end
    end
end)


local API = script.Parent:FindFirstChild("API")
if not API then
    API = Instance.new("Folder")
    API.Name = "API"
    API.Parent = script.Parent
end


local function GetBindable(name, bindableType)
    local bindable = API:FindFirstChild(name)
    if not bindable then
        bindable = Instance.new(bindableType)
        bindable.Name = name
        bindable.Parent = API
    end
    return bindable
end


GetBindable("SubmitPayment", "BindableFunction").OnInvokeWithContext = function(runAs, elevated, recipient, amount)
    if not elevated then
        error("Can only process payment from scripts with elevated permissions")
    end
    local fromAccount = Accounts:FindFirstChild(runAs)
    if not fromAccount then
        error("No account for " .. runAs)
    end
    if typeof(recipient) == "Instance" then
        if recipient:IsA("Player") then
            recipient = recipient.UserId
        else
            error("Player or UserId expected for recipient, got " .. recipient.ClassName)
        end
    end
    recipient = tostring(recipient)
    local toAccount = Accounts:FindFirstChild(recipient)
    if not toAccount then
        error("No account for " .. recipient)
    end
    if fromAccount.Value < amount then
        error("Insufficient funds")
    end

    fromAccount.Value -= amount
    toAccount.Value += amount
end


GetBindable("GetBalance", "BindableFunction").OnInvokeWithContext = function(runAs, elevated)
    if not elevated then
        error("Can only get balance from scripts with elevated permissions")
    end
    local account = Accounts:FindFirstChild(runAs)
    if not account then
        error("No account for " .. runAs)
    end

    return account.Value
end