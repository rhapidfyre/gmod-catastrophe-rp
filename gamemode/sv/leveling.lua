

-- Handles Leveling up
net.Receive("MMO_RaiseStat", function(len, ply)

	local stat  = net.ReadString()
	
	if ply:GetStatPoints() > 0 then
	
		local echoo = "none" 
		
		if stat == "str" then
			ply:SetStrength(ply:GetStrength()+1)
			echoo = "STRENGTH"
		elseif stat == "dex" then
			ply:SetDexterity(ply:GetDexterity()+1)
			echoo = "DEXTERITY"
		elseif stat == "con" then
			ply:SetConstitution(ply:GetConstitution()+1)
			echoo = "CONSTITUTION"
			timer.Simple(0.25, function()
				local new_value = CalculateHitpoints(ply:GetConstitution(), ply:GetLevel(), false)
				ply:SetMaxHealth(new_value)
				ply:SetHealth(new_value)
				print("NEW HP: "..ply:Health().."/"..ply:GetMaxHealth())
			end)
		elseif stat == "sta" then
			ply:SetStamina(ply:GetStamina()+1)
			echoo = "STAMINA"
		elseif stat == "int" then
			ply:SetIntelligence(ply:GetIntelligence()+1)
			echoo = "INTELLIGENCE"
		elseif stat == "cha" then
			ply:SetCharisma(ply:GetCharisma()+1)
			echoo = "CHARISMA"
		end
        
		ply:SetStatPoints(ply:GetStatPoints() - 1)
		ply:PrintMessage(HUD_PRINTTALK, "You have increased "..echoo.."!")
        
        net.Start("MMO_UDStat")
            net.Send(ply)
	end
	
end)
