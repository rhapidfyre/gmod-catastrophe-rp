--[[
local function PollDB()

    if sql.TableExists("Marketplace") then
        return true
    else
        sql.Query("CREATE TABLE Marketplace(dbid INTEGER PRIMARY KEY, SteamID TEXT, ItemInfo TEXT, Seller TEXT, value INTEGER, starttime DATETIME, auction BOOLEAN NOT NULL DEFAULT 0, endtime DATETIME, legal BOOLEAN NOT NULL DEFAULT 0)")
        return false;
    end

end

local function DBExists()
    if PollDB() then
        return tbl
    else
        return nil;
    end
end

local marketplace = {}
    marketplace.items = DBExists()

-- Handles withdrawal
function marketplace.withdraw(buyer, seller, dbid)
end

-- Handles depositing
function marketplace.deposit(seller, dbid)
end

-- Retrieves the DB ID number the player is inspecting
function marketplace.inspect(dbid)
end

net.Receive("MMO_BuyMarket", function(len, ply)
    local itemName = net.ReadString()
    local seller = net.ReadString()
    local buyer = ply
    local info = sql.Query("SELECT dbid FROM Marketplace WHERE itemName = '"..itemName.."' AND seller = '"..seller.."'")
    if IsValid(info) then
    else
        ply:PrintMessage(HUD_PRINTTALK, "[MARKET] That item doesn't exist on the market!")
    end
end)

net.Receive("MMO_SellMarket", function()
end)

timer.Create("MMO_MarketUpdate", 60, 0, function()
    market.update()
    
    -- Send a net msg to all players
    -- If they have the market open, receiving this will refresh their window.
    net.Start("MMO_MarketUD")
        net.WriteBool(true)
        net.Broadcast()
end)]]