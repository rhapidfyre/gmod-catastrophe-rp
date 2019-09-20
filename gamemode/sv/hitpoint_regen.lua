
--[[
	Regenerates all player's HP if it's not full
]]

-- Runs our Regeneration if the entity is valid.
local function RegenHP(ent)

	print("[DEBUG] "..tostring(ent).." is out of combat. Health is: "..ent:Health().."/"..ent:GetMaxHealth().."... Regenerating.")
	
	local flag = false
	if ent:IsNPC() then flag = true end
	
	local new_value = (CalculateRegen(ent:GetStamina(), base_regen, ent:GetLevel(), flag))
	print("[DEBUG] Regenerate "..tostring(new_value).." HP")
	if (ent:Health() + new_value) > ent:GetMaxHealth() then
		print("[DEBUG] HP too high ("..tostring(ent:Health() + new_value).."), setting to max ("..tostring(ent:GetMaxHealth())..")")
		ent:SetHealth(ent:GetMaxHealth())
	else
		ent:SetHealth(ent:Health() + new_value)
		timer.Simple(0.1, function() print("[DEBUG] HP-Regen: New Health value = "..tostring(ent:Health())) end)
	end
	
end

-- Make sure it's allowed (valid) that the entity can start regenerating (not in combat, etc)
local function CheckValid(ent)

	if ent:Health() < ent:GetMaxHealth() then
	
		if ent.last_hurt == nil or (ent.last_hurt + post_combat < CurTime()) then
		
			local flag = true
			
			if ent:IsPlayer() then 
			
				if !(ent:Alive()) then flag = false end
				
			end
		
			if flag == true then RegenHP(ent) end
			
		end
		
	elseif ent:Health() > ent:GetMaxHealth() then
	
		ent:SetHealth(ent:GetMaxHealth())
		print("[DEBUG] "..tostring(ent).."'s health was higher than GetMaxHealth. Set to ("..tostring(ent:Health()).."/"..tostring(ent:GetMaxHealth()))
		
	end
	
end

-- Check for HP Regen on 'Server Tick'
hook.Add("ServerTick", "HPRegen", function()
	-- Check regen on all players
	for _,ply in pairs(player.GetAll()) do
		if ply:Health() > ply:GetMaxHealth() then
			ply:SetHealth(ply:GetMaxHealth())
		elseif ply:Health() < ply:GetMaxHealth() then
			CheckValid(ply)
		end
	end
	
	-- Check regen on all NPCs
	for _,ent in pairs(ents.GetAll()) do
		if ent:IsNPC() then
			if ent:Health() then
				if ent:Health() < ent:GetMaxHealth() then
					CheckValid(ent)
				elseif ent:Health() > ent:GetMaxHealth() then
					ent:SetHealth(ent:GetMaxHealth())
				end
			end
		end
	end
	
end)