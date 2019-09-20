
net.Receive("MMO_DoPurchase", function(len, ply)

		print("[DEBUG] DoPurchase()")
		local iName  = net.ReadString()
		local npc_type = net.ReadString()
		local iCount = net.ReadInt(32)
		
		-- Verify NPC merchant actually has the item player is trying to buy
		local npc_chive = {}
		if npc_type == "Junk Dealer" then
			npc_chive = table.Copy(junk_inventory)
		elseif npc_type == "Arms Dealer" then
			npc_chive = table.Copy(arms_inventory)
		end
		
		local valid = false
		local index = nil
		for k,v in pairs(npc_chive) do
			if npc_chive[k]["name"] == iName then
				valid = true
				index = k
			end
		end
		
		-- Stop now if item isn't valid
		if !valid then return end
		
		-- Calculate cost of the item
		local cost = npc_chive[index]["price"] * iCount
		
		-- Make sure player can afford it
		if cost > ply:GetMoney() then
			net.Start("MMO_SaleFailure")
				net.Send(ply)
			return
		end
		
		-- Deduct cost
		ply:SetMoney(ply:GetMoney() - cost)
		
		-- See if player already has one
		local exists = false
		local i2 = nil
		for k,v in pairs(ply.Inventory) do
			if ply.Inventory[k]["name"] == npc_chive[index]["name"] then
				exists = true
				i2 = k
			end
		end
		
		-- Add it to their inventory
		if exists then
			ply.Inventory[i2]["amount"] = ply.Inventory[i2]["amount"] + iCount
		else
			npc_chive[index]["amount"] = iCount
			table.insert(ply.Inventory, npc_chive[index])
		end
		
		-- Send success message
		net.Start("MMO_SaleSuccess")
			net.Send(ply)
			
		net.Start("MMO_InvUpdate")
			net.WriteTable(ply.Inventory)
			net.Send(ply)
		
end)

net.Receive("MMO_DoSale", function(len, ply)

		print("[DEBUG] DoSale()")
		local iName  = net.ReadString()
		local iCount = net.ReadInt(32)
		
		-- Verify player has the item, and the amount they're trying to sell
		local hasitem = false
		local index = nil
		for k,v in pairs(ply.Inventory) do
			if ply.Inventory[k]["name"] == iName then
				if ply.Inventory[k]["amount"] >= iCount then
					hasitem = true
					index = k
				end
			end
		end
		
		-- Give the player the money for the item
		ply:SetMoney(ply:GetMoney() + (ply.Inventory[index]["amount"] * ply.Inventory[index]["buy_low"]))
		
		-- Remove it from their inventory
		ply.Inventory[index]["amount"] = ply.Inventory[index]["amount"] - iCount
		RemoveZeroes(ply)
		
		-- Send success message
		net.Start("MMO_SaleSuccess")
			net.Send(ply)
		
end)

hook.Add("PlayerUse", "OpenMerchWindow", function(ply, ent)

	if (ent:GetClass() == "npc_monk" and ply:Team() == 1) or (ent:GetClass() == "npc_breen" and ply:Team() == 2) then
		net.Start("MMO_OpenMerchant")
			net.WriteTable(arms_inventory)
			net.WriteString("Arms Dealer")
			net.Send(ply)
	elseif (ent:GetClass() == "npc_vortigaunt" and ply:Team() == 1) or (ent:GetClass() == "npc_mossman" and ply:Team() == 2) then
		net.Start("MMO_OpenMerchant")
			net.WriteTable(junk_inventory)
			net.WriteString("Junk Dealer")
			net.Send(ply)
	end
	
end)