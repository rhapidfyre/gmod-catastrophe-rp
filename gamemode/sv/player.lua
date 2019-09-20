local respawn = false

function GM:PlayerDeathSound() return false end

function GM:PlayerShouldTakeDamage(ply, victim)
	if ply:IsPlayer() and victim:IsPlayer() then
		if ply:Team() == victim:Team() then
			return false
		end
		if (math.abs(ply:PlayerLevel() - victim:PlayerLevel()) > 20) then
			return false
		end
	end
	return true
end

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
	if ply:Team() == 2 then
		ply:EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav", 50, 100, 0.2)
		return false
	end
end

function GM:PlayerSetModel(ply)
	ply:SetModel("models/player/group03/male_0"..math.random(1,9)..".mdl")
end

function GM:PlayerConnect(name, ip)
	-- Console log keeping
	print("[JOINED] "..name.." connected: "..ip)
	PrintMessage(HUD_PRINTTALK, name.." has joined the game.")
end

function GM:PlayerDisconnected(ply)
	SaveStats(ply) -- sv_global.lua
	-- Console log keeping
	print("[DISCONNECTED] "..ply:GetName().." quit.")
	PrintMessage(HUD_PRINTTALK, ply:GetName().." has left the game. (Quit)")
end

function GM:PlayerLoadout(ply) end

function GM:PlayerHurt(victim,attacker,remain,taken) end

function GM:CanPlayerSuicide(ply) return false end

hook.Add("KeyPress", "Respawnkey", function(ply, key)
	if ply:KeyPressed(IN_FORWARD) or ply:KeyPressed(IN_JUMP) then
		respawn = true
		timer.Simple(0.25, function() respawn = false end)
		return 0
	end
	return 0
end)

function GM:PlayerDeathThink(ply)

	if ( ply.NextSpawnTime && ply.NextSpawnTime > CurTime() ) then return end

	if ( ply:IsBot() || ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
	
		ply:Spawn()
	
	end
end

function GM:PlayerDeath(ply,inflictor,attacker)

	print (ply:GetName().. " died.")
	ply.NextSpawnTime 	= CurTime()+3
	ply.TimeofDeath		= CurTime()
	
	if ply:Team() == 1 then
		if ply:GetFemale() then
			sound.Play("vo/npc/female01/help01.wav", ply:GetPos())
		else
			sound.Play("vo/npc/male01/help01.wav", ply:GetPos())
		end
	elseif ply:Team() == 2 then
		sound.Play("npc/metropolice/die"..math.random(1,4)..".wav", ply:GetPos(), 75, 100, 0.75)
	end
	
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(ply:GetModel())
	ragdoll:SetPos(ply:GetPos())
	ragdoll:SetAngles(ply:GetAngles())
	ragdoll:Spawn()
	ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ragdoll.sid = ply:SteamID()
	ragdoll.uid = ply:UniqueID()
	ragdoll.Owner = ply
	ragdoll.Expired = false
	ragdoll.DeathTime = CurTime()
    
	ragdoll:SetNWInt("deathtime", CurTime())
	ragdoll:SetNWString("owner", ply:SteamID64())
	ragdoll:SetNWBool("corpse", true)
	ragdoll:SetNWBool("lootable", false)
    
	local json_table = util.TableToJSON(ply.Inventory)
    ragdoll.LootTable = json_table
	
    -- Empty player inventory upon death
    table.Empty(ply.Inventory)
    
	-- position the bones
    local num = ragdoll:GetPhysicsObjectCount()-1
    local v = ply:GetVelocity()
    
    for i=0, num do
        local bone = ragdoll:GetPhysicsObjectNum(i)
        if IsValid(bone) then
            local bp, ba = ply:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
            if bp and ba then
                bone:SetPos(bp)
                bone:SetAngles(ba)
            end
    
            -- not sure if this will work:
            bone:SetVelocity(v)
        end
    end
    
    net.Start("MMO_PlayerDead")
        net.Send(ply)
	
end

function GM:DoPlayerDeath(victim,attacker,damage)
	if attacker:IsPlayer() then
	net.Start("MMO_KillerName")
		net.WriteString(attacker:Name())
		net.Send(victim)
	elseif attacker:IsNPC() then
	net.Start("MMO_KillerName")
		net.WriteString(attacker:GetClass())
		net.Send(victim)
	end
end

hook.Add("PlayerSpawn", "NoCRagdoll", function(ply)
    ply:SetShouldServerRagdoll(false)
end)
