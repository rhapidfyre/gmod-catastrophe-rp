
-- Vocal ouch sounds when taking damage
hook.Add("EntityTakeDamage", "OuchSounds", function(target, dmgInfo)
	if target:IsPlayer() then
		local pain_chance = math.random(1,100)
		if pain_chance > 40 then
			if target:Team() == 1 then
				if target:GetFemale() then
					sound.Play("vo/npc/female01/pain0"..math.random(1,9)..".wav", target:GetPos())
				else
					sound.Play("vo/npc/male01/pain0"..math.random(1,9)..".wav", target:GetPos())
				end
			elseif target:Team() == 2 then	
				sound.Play("npc/metropolice/pain"..math.random(1,4)..".wav", target:GetPos())
			end
		end
	end
end)


-- Used for modifying damage based on levels
function GM:EntityTakeDamage(target, dmginfo)

	-- WARNING [DEBUG]: 357 can one shot kill level 100's!!!! Check damage multipliers and health modifiers
	
	-- If the attacker is an NPC, find their modified damage based on level
	local attacker = dmginfo:GetAttacker()
	local is_npc = false
	
	-- Stop friendlies from killing their own NPCs
	if target:IsNPC() and attacker:IsPlayer() then
		local npcTeam = NPCInfo(target, false)
		if npcTeam == attacker:Team() then
			if target:Health() + 50 < target:GetMaxHealth() then
			target:AddEntityRelationship(attacker, D_HT, 99)
			end
		end
	end
	
	if target:IsNPC() or target:IsPlayer() then
	
		if attacker:IsNPC() then is_npc = true end
		
		if attacker:IsNPC() or attacker:IsPlayer() then
			
			local new_damage = CalculateDamageBon(attacker:GetDexterity(), dmginfo:GetDamage(), attacker:GetLevel(), is_npc)
			-- If the attacking player is lower level, penalize their damage
			local level_spread = target:GetLevel() - attacker:GetLevel()
			
			local dmg_penalty = 1
			if level_spread > 0 then
				dmg_penalty = 1 / (0.25 * level_spread + 1) 	-- DESMOS: y = 1 / (.25x + 1)
			end
			
			-- new_damage should come in rounded so may be no need to round it here
			local set_damage = math.Round(new_damage * dmg_penalty, 0)
			if set_damage < 1 then set_damage = 1 end
			
			dmginfo:SetDamage(set_damage)
			target.last_hurt = CurTime()
			
			timer.Simple(0.25, function()
				if IsValid(target) then
				end
			end)
		end
		
		-- Build a table of everyone who's ever attacked this NPC
		if target:IsNPC() and (attacker:IsNPC() or attacker:IsPlayer()) then
		
			-- If the damage table doesn't exist, create it.
			if !(target.DamageTable) then
				target.DamageTable = {}
			end
			
			local dmgtable = {}
			dmgtable["attacker"] = attacker	-- Insert the attacker
			if attacker:IsPlayer() and attacker:GetGroupNumber() ~= 0 then
				dmgtable["groupnumber"] = attacker:GetGroupNumber() -- If they're grouped, insert their group number
			end
			
			if dmgtable["damage"] == nil or !IsValid(dmgtable["damage"]) then dmgtable["damage"] = 0 end
			dmgtable["damage"] = dmginfo:GetDamage()
			
			local dmgflag = true
			for k,v in pairs (target.DamageTable) do
				if target.DamageTable[k]["attacker"] == dmgtable["attacker"] then
					target.DamageTable[k]["damage"] = target.DamageTable[k]["damage"] + dmgtable["damage"]
					dmgflag = false
				end
			end
			
			if dmgflag then table.insert(target.DamageTable, dmgtable) end
			
		end
	
	end
	net.Send("MMO_FVox")
		net.WriteInt(dmginfo:GetDamage(), 32)
		net.WriteInt(dmginfo:GetDamageType(), 32)
		net.Send(ply)
		
	if target:IsNPC() then
		local godmode = {
			["npc_vortigaunt"] = true,
			["npc_monk"] = true
		}
		if godmode[target:GetClass()] then
			dmginfo:SetDamage(0)
			return true
		end
	end
	
end

function GM:ScaleNPCDamage()
	print("NPC Took Damage!")
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	print("Player Took Damage!")
end

