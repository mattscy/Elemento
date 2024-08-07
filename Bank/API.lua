local API = {}

local Bank = elemento:GetPersonalFolder().Parent["16542699"].Bank


function API.SubmitPayment(recipient, amount)
    return Bank.API.SubmitPayment:Invoke(recipient, amount)
end


function API.GetBalance()
    return Bank.API.GetBalance:Invoke()
end


return API