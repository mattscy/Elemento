local API = {}

local Bank = elemento:GetPrivateFolder().Parent["16542699"]


function API.SubmitPayment(recipient, amount)
    return Bank.API.SubmitPayment:Invoke(recipient, amount)
end


function API.GetBalance()
    return Bank.API.GetBalance:Invoke()
end


return API