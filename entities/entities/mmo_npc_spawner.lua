
ENT.Type = "point"

local last_spawn = CurTime()
local next_spawn = CurTime() + 30

function ENT:Initialize()

	print("[DEBUG] Created NPC Spawner @ "..tostring(self:GetPos()))
	if self.livingmobs == nil then self.livingmobs = 0 end
	if self.maxmobs == nil then self.maxmobs = 1 end
	self:SetName(self:MapCreationID())
	self.firstspawn = true
	
end

function ENT:AcceptInput(inputName, activator, called, data)
	if inputName == "DecreaseCount" then
		print("[DEBUG] Decreasing count "..tostring(self.livingmobs).." by 1.")
		self.livingmobs = self.livingmobs - tonumber(data)
	end
end

function ENT:KeyValue(key, value)
	if key == "radius" then self.radius = tonumber(value)
	elseif key == "maxmobs" then self.maxmobs = tonumber(value) 
	elseif key == "timermin" then self.timermin = tonumber(value) 
	elseif key == "timermax" then self.timermax = tonumber(value) 
	elseif key == "levelmin" then self.levelmin = tonumber(value) 
	elseif key == "levelmax" then self.levelmax = tonumber(value) 
	elseif key == "npcclass" then self.npcclass = value 
	elseif key == "citizenmodel" then self.model = value 
	elseif key == "combinemodel" then self.model = value 
	elseif key == "angles" then self:SetAngles(util.StringToType(value, "Angle"))
	end
end

function ENT:Think()

    -- Check for spawn
	if CurTime() >= next_spawn or self.firstspawn then
		print("[DEBUG] Checking for spawn possibility..."..tostring(self.livingmobs).."/"..tostring(self.maxmobs))
		if self.firstspawn  or self.livingmobs < self.maxmobs then
		
			self.firstspawn  = false
		
			local npc = ents.Create(self.npcclass)
			
			local vtimer = (math.random(self.timermin, self.timermax))
			next_spawn = CurTime() + vtimer
			
			-- Set level of mob based on given map range
			local level = math.random(self.levelmin, self.levelmax)
			npc:SetLevel(level)
			
			-- Setting unique name for debugging purposes
			npc:SetName("SPW"..self:MapCreationID().."_"..npc:EntIndex())
			
			-- If the NPC is a gun fighter, give them a gun to use
			if self.npcclass == "npc_combine_s" or self.npcclass == "npc_citizen" then
				npc:SetKeyValue("additionalequipment", "weapon_smg1")
				if self.model == "rebel" and self.npcclass == "npc_citizen" then npc:SetKeyValue("citizentype", 1) end
				npc:SetKeyValue("spawnflags", "1073664")	-- Don't drop gun, Fade Corpse, and don't let rebels follow players, don't allow player to push (8192, 512, 1048576, 16384)
			end
            
			-- Add input so that when the mob dies, the spawner it belongs to will spawn another
			npc:Input("AddOutput", npc, ply, "OnDeath "..self:GetName()..":DecreaseCount:1::-1")
	
			npc:Spawn()
			
			-- Randomly spawn within given radius by map, and randomly pick angles to face
			npc:SetPos(self:GetPos() + Vector(math.random(0, self.radius), math.random(0, self.radius), 0))
            npc:SetSpawnPoint(npc:GetPos())
            print("(DEBUG) SPAWN POINT SET FOR "..tostring(npc:GetName()).." ("..tostring(npc:GetSpawnPoint())..")")
			npc:SetAngles(Angle(0,math.random(1,360),0))
			
			--npc:SetKeyValue("spawnflags",tostring (bit.bor (8192,512)))
			
			timer.Simple(0.1, function()
				npc:SetStrength(1)
				npc:SetConstitution(1)
				npc:SetStamina(1)
				npc:SetDexterity(1)
				npc:SetIntelligence(1)
				npc:SetCharisma(1)
				npc:SetMaxHealth(CalculateHitpoints(npc:GetConstitution("con"), npc:GetLevel(), true))
				npc:SetHealth(npc:GetMaxHealth())
			end)
			self.livingmobs = self.livingmobs + 1
			PrintMessage(HUD_PRINTTALK, "[DEBUG] "..tostring(npc:GetName()).." ["..npc:GetClass().."] Spawned @ "..tostring(npc:GetPos()))
			
		
		else
			print("[DEBUG] Spawner failure, max mobs reached!")
			local vtimer = (math.random(self.timermin, self.timermax))
			next_spawn = CurTime() + vtimer
		end
		
	end
	
end