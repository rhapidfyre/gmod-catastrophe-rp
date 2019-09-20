
hook.Add("PlayerDeath", "EXPPenalty", function(victim, inflictor, attacker)
	-- EXP Penalty is EXP_PENALTY % of total level experience
	if victim:IsPlayer() then
		local difference = victim:GetExperience() - (victim:GetExperience()*0.05)
		victim:SetExperience((victim:GetExperience() * -1) + difference)
		-- Ensure player never goes negative
		if victim:GetExperience() < 0 then
			victim:SetExperience(victim:GetExperience() + (victim:GetExperience() * (-1)))
		end
	end
end)

local function LevelUp(ply)
	
	ply:SetExperience(ply:GetExperience() - ply:GetNextLevel())
	ply:SetNextLevel(ply:GetNextLevel() + (ply:GetNextLevel() * 0.10))
	
	PrintMessage(HUD_PRINTTALK, ply:Name().." has reached level ["..tostring(ply:GetLevel() + 1).."]")
	ply:SetLevel(ply:GetLevel() + 1)
	ply:PrintMessage(HUD_PRINTTALK, "You have received 2 stat points! Open the context menu to spend them (C: Default)")
	ply:SetStatPoints(ply:GetStatPoints() + 2)
    
    net.Start("MMO_LevelUp")
        net.Send(ply)
	
	if ply:GetExperience() >= ply:GetNextLevel() then LevelUp(ply) end
	
end

function GrantExp(ply, value)
	
	ply:SetExperience(ply:GetExperience() + value)
	if ply:GetExperience() >= ply:GetNextLevel() then LevelUp(ply) end
	
end

function GM:OnNPCKilled(npc,attacker,inflictor)
	
	local highest = attacker
	local hDamage = 0
	
    npc:SetShouldServerRagdoll(false)
    
	if IsValid(npc.DamageTable) then
		for k,v in pairs(npc.DamageTable) do
			local damage = npc.DamageTable[k]["damage"]
			if damage > hDamage then
				highest = npc.DamageTable[k]["attacker"]
				hDamage = damage
			end
		end
	end
	
	local flag = false
	local killer
	
	-- Awardee is a Player Character
	if highest:IsPlayer() then
	
		killer = highest
		flag = true
		
	-- Inflictor is an NPC, no exp, no loot, no body
	elseif highest:IsNPC() then	return
	end

	-- Stop this function now, if a prop or world entity killed the NPC
	if killer == nil then return
	end
	
	-- If the killer is +/- 12 levels, don't award any experience but spawn a corpse
	local plyLevel = killer:GetLevel()
	local npcLevel = npc:GetLevel()
	if (plyLevel - npcLevel > 12) or (npcLevel - plyLevel > 12) then
		BuildLootTable(0, npc, killer)
		return
	end
	
	-- Killer is player
	if flag then
	
		local eligible = {}
		
		-- Award all players who are in the same group
		local comingsoon = 0
		
		-------------------------
		-- Calculate exp worth --
		-------------------------
		local award = 0
		local avg_lvl = plyLevel	-- Placeholder, this will be used for determining average level for group members

		if plyLevel > npcLevel then
			-- Using clamp, to make sure that the EXP award is never zero or negative
			-- base EXP multiplied by the the difference of levels
			award = math.Round(math.Clamp(EXP_KILL * (npcLevel / avg_lvl), 0, EXP_KILL), 2)
		elseif plyLevel < npcLevel then
			-- Base Award plus any bonus multiplier for being lower level than the NPC
			award = math.Round(EXP_KILL + (EXP_KILL * (npcLevel - avg_lvl)), 2)
		else
			-- Equal Level, award Base EXP amount
			award = EXP_KILL
		end
			
		-- Divide up EXP award based on # of players
		if #eligible > 0 then
		
			award = math.Round(award / #eligible, 2)
			print("[DEBUG] Experience will be divided amongst "..#eligible.." players.")
			
		end
		
		-- This will have to be looped to award the correct exp
		GrantExp(killer, award)
		
		-- Conduct Loot
		local groupnum = killer:GetGroupNumber()

		local ragdoll = ents.Create("prop_ragdoll")
		ragdoll:SetModel(npc:GetModel())
		ragdoll:SetVelocity(npc:GetVelocity())
		ragdoll:SetAngles(npc:GetAngles())
		ragdoll:SetPos(npc:GetPos())
		ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
		ragdoll:Spawn()
		
		ragdoll.DeathTime = CurTime()
		ragdoll.Expired = false
        
		ragdoll:SetNWString("targetname", npc:GetClass())
		ragdoll:SetNWString("deathtime", CurTime())
		ragdoll:SetNWInt("loot_group", killer:GetGroupNumber())
		ragdoll:SetNWEntity("loot_entity", killer)
		ragdoll:SetNWBool("lootable", true)
		
		-- Set loot table to the NPC
		ragdoll.LootTable = npc.LootTable
		
		
		
		-- TTT velocity hack to stop server crashing from crazy ragdoll behavior
		local velo = ragdoll:GetVelocity():Length()
		if velo >= 1500 and Velo <= 2999 then ragdoll:SetVelocity(0)
		elseif velo >= 3000 then ragdoll:Remove() end
		
	end	
	
end