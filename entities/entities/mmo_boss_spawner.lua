
ENT.Type = "point"

local last_spawn = CurTime()
local next_spawn = CurTime() + 5

function ENT:Initialize()

	print("[DEBUG] Created Boss-NPC Spawner @ "..tostring(self:GetPos()))
	if self.livingmobs == nil then self.livingmobs = 0 end
	if self.maxmobs == nil then self.maxmobs = 1 end
	self:SetName(self:MapCreationID())
	self.firstspawn = true
end

function ENT:AcceptInput(inputName, activator, called, data)
	if inputName == "DecreaseCount" then
		print(self.livingmobs)
		self.livingmobs = self.livingmobs - tonumber(data)
		print("Living mobs count decreased.")
		print(self.livingmobs)
	end
end

function ENT:KeyValue(key, value)
	if key == "radius" then self.radius = tonumber(value)
	elseif key == "maxmobs" then self.maxmobs = 1 
	elseif key == "targetname" then self.bossname = tostring(value)
	elseif key == "timermin" then self.timermin = tonumber(value) 
	elseif key == "timermax" then self.timermax = tonumber(value) 
	elseif key == "levelmax" then self.levelmax = tonumber(value) 
	elseif key == "npcclass" then self.npcclass = value 
	elseif key == "citizenmodel" then self.model = value 
	elseif key == "combinemodel" then self.model = value 
	elseif key == "angles" then self:SetAngles(util.StringToType(value, "Angle"))
	end
end

function ENT:Think()

	if CurTime() >= next_spawn or self.firstspawn then
	
		if self.firstspawn  or self.livingmobs < self.maxmobs then
		
			self.firstspawn  = false
			
			print("[DEBUG] Spawning a "..self.npcclass)
		
			local npc = ents.Create(self.npcclass)
			
			local vtimer = (math.random(self.timermin, self.timermax))
			next_spawn = CurTime() + vtimer
			
			npc:SetLevel(self.levelmax)
			
			-- Setting unique name for debugging purposes
			npc:SetName("BOSS"..self:MapCreationID().."_"..npc:EntIndex())
			
			-- If the NPC is a gun fighter, give them a gun to use
			if self.npcclass == "npc_combine_s" or self.npcclass == "npc_citizen" then
				npc:SetKeyValue("additionalequipment", "weapon_ar2")
				npc:SetKeyValue("spawnflags", "1057280")	-- Don't drop gun, Fade Corpse, and don't let rebels follow players (8192, 512, 1048576)
			end
			
			-- Add input so that when the mob dies, the spawner it belongs to will spawn another
			npc:Input("AddOutput", npc, ply, "OnDeath "..self:GetName()..":DecreaseCount:1::-1")
			npc:SetName(self.bossname)
			npc:SetNWString("targetname", self.bossname)
			npc:SetNWBool("bossfight", true)
			npc:Spawn()
			
			-- Randomly spawn within given radius by map, and randomly pick angles to face
			npc:SetPos(self:GetPos() + Vector(math.random(0, self.radius), math.random(0, self.radius), 0))
			npc:SetAngles(Angle(0,math.random(1,360),0))
			
			--npc:SetKeyValue("spawnflags",tostring (bit.bor (8192,512)))
			
			--local new_health = npc:GetMaxHealth() + (NPC_SCALE_HP * npc:GetLevel())
			npc:SetMaxHealth(CalculateHitpoints(npc:GetNWInt("con"), npc:GetLevel(), true))
			npc:SetHealth(npc:GetMaxHealth())
			
			self.livingmobs = self.livingmobs + 1
			
			print("[DEBUG] Boss Level:      "..npc:GetLevel())
			print("[DEBUG] Boss Max Health: "..npc:GetMaxHealth())
			
		
		else
			print("[DEBUG] Spawner is full!")
			print("[DEBUG] MAX: "..self.maxmobs.." CURR: "..self.livingmobs)
			local vtimer = (math.random(self.timermin, self.timermax))
			next_spawn = CurTime() + vtimer
		end
		
	end
	
end