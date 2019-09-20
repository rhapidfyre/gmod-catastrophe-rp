
-- Function returns the KEY of the value that was found, returns nil if not found
-- NOTE: This function is searching tables within the table it's given i.e: table[a][b]
local function GetTableIndex(findIndex, search)
	print("[DEBUG] Looking for ["..search.."]")
	for k,v in pairs(findIndex) do
		if findIndex[k]["name"] == search then
			print("[DEBUG] Found and returning Index #"..tostring(k))
			return k
		end
	end
end

-- Bank Prop Transaction
net.Receive("MMO_BankTransaction", function(len, ply)
	local deposit		= net.ReadBool()
	local accountTo		= nil
	local accountFrom	= nil
	local search		= net.ReadString()
	local iCount		= net.ReadInt(32)
	
	if deposit then
		accountTo = ply.BankInventory
		accountFrom = ply.Inventory
	else
		accountTo = ply.Inventory
		accountFrom = ply.BankInventory
	end
	
	
	-- Find KEY of the FROM account where item exists (the key should always exist from here unless they cheated)
	local i1 = GetTableIndex(accountFrom, search)
	local amountFrom = accountFrom[i1]["amount"]
	
	-- Check if the current index already exists in the TO account (this may return nil if it doesn't exist already)
	local i2 = GetTableIndex(accountTo, accountFrom[i1]["name"])
	
	local amountTo = nil -- Assume the table doesn't exist
	
	-- This little condition sets our flag to true, if it does in fact exist already in the inventory we're transfering to
	local exists_previously = false
	if i2 ~= nil then
		amountTo = accountTo[i2]["amount"]
		exists_previously = true
	end
	
	-- If it exists already, then modify the amount
	if exists_previously then
		accountTo[i2]["amount"] = amountTo + iCount
		accountFrom[i1]["amount"] = amountFrom - iCount
		if accountFrom[i1]["amount"] <= 0 then
			-- If we're all out of said prop, remove it from the inventory. No negative or zero values taking up slots
			table.remove(accountFrom, i1)
		end
		
	-- The inventory we're transfering the prop to does have it already. Create it.
	else
	
		-- Deduct the transfer against the FROM amount
		local remaining = accountFrom[i1]["amount"] - iCount
		accountFrom[i1]["amount"] = remaining
		
		-- and then add it to the new one
		local new_account = table.Copy(accountFrom[i1])
		new_account["amount"] = iCount
		table.insert(accountTo, new_account)
		
		-- If the FROM inventory is now zero or negative, get rid of it.
		if accountFrom[i1]["amount"] <= 0 then
			table.remove(accountFrom, i1)
		end
	end
	
	-- Take our new tables, and assign  them to the player inventories appropriately
	if deposit then
		ply.Inventory = accountFrom
		ply.BankInventory = accountTo
	else
		ply.Inventory = accountTo
		ply.BankInventory = accountFrom
	end
	
	-- Anytime an inventory/bank changes, update it with the client(s)
	net.Start("MMO_InvUpdate")
		net.WriteTable(ply.Inventory)
		net.Send(ply)
		
	net.Start("MMO_BankUpdate")
		net.WriteTable(ply.BankInventory)
		net.WriteTable(ply.Inventory)
		net.Send(ply)

end)
