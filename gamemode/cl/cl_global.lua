
myWeight = 140
inventory = {}
bankinv = {}

--[[
    net.Receive()
    Updates the inventory of the player & carry weight
]]
net.Receive("MMO_InvUpdate", function()
    -- Update inventory items
    -- Update carry weight
end)

--[[
    net.Receive()
    Updates the bank inventory of the player
]]
net.Receive("MMO_BankUpdate", function()
    -- Update bank inventory
end)