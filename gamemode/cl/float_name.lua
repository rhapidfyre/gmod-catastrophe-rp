local see_indicators 	= true	-- Allow players to turn off floating names
local float_height 		= 2	-- For walking mobs
local float_height_down = (-32)	-- For ceiling turrets, etc
local my_alliance		= 0 --LocalPlayer():Team()

local max_d 			= 768	-- The distance at which names disappear
local full_alpha		= 512	-- The distance at which names reach full opacity

-- Healthbar Size (x = max size, y = health, z = max health)
local function FixSize(x,y,z)
	return ((x * y) / z)
	
end


-- Draw Float Text
local function DrawTag(alliance,targetScreenpos,npc,alpha,ent)

	if ent:GetClass() ~= "npc_grenade_frag" and ent:GetClass() ~= "npc_satchel" and ent:GetClass() ~= "npc_tripmine" then
		local color
		if 	   tonumber(alliance) ~= tonumber(LocalPlayer():Team())	then color = Color(255,80,80,alpha)
		else 				      			         color = Color(60,220,60,alpha)
		end
		
		local npc_level = ent:GetLevel()
		
        --[[
		if ent:GetNWString("targetname") ~= "" then
			npc = ent:GetNWString("targetname")
			color = Color(255,math.abs(math.sin(CurTime() * 2)) * 255,0,255)
		end]]
		
		if npc == nil then npc = "NPC" end
		draw.RoundedBoxEx(10,targetScreenpos.x - 70,targetScreenpos.y-32,140,24,Color(0,0,0,alpha/2),true,true,false,false)
		draw.SimpleTextOutlined(npc, "FloatText1", tonumber(targetScreenpos.x)-64, tonumber(targetScreenpos.y)-30, color, 0, 0, 1, Color(0,0,0,alpha))
		
		if npc_level > 100 or ent:GetMaxHealth() > 9000 then npc_level = "RAID"
		else npc_level = "Lv "..npc_level end
		
		local color = 220
		if npc_level == "RAID" then
			color = 0
		end
		draw.SimpleTextOutlined(npc_level, "FloatText2", tonumber(targetScreenpos.x)+64, tonumber(targetScreenpos.y)-30, Color(220,color,color,alpha), 2, 0, 1, Color(0,0,0,alpha))
		
		draw.RoundedBox(0,targetScreenpos.x - 64,targetScreenpos.y-16,128,4,Color(80,0,0,alpha))
		draw.RoundedBox(0,targetScreenpos.x - 64,targetScreenpos.y-16,FixSize(128, ent:Health(), ent:GetMaxHealth()),4,Color(180,0,0,alpha))
	elseif ent:GetClass() == "npc_satchel" or ent:GetClass() == "npc_tripmine" then
		-- Do nothing
	else
		local trig = math.abs(math.sin(CurTime() * 12) * 255)
		draw.SimpleTextOutlined("k", "FloatText3", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y), Color(255,trig,trig), 1, 1, 2, Color(0,0,0,255))
	end
end

-- Draw PC Tag
local function DrawPCTag(ent,targetScreenpos,alpha,npc)

	local alliance = ent:Team()
	local title = ent:GetPlayerTitle()
	local color
	if 	   alliance ~= my_alliance	then color = Color(255,140,140,alpha)
	else 				      			 color = Color(0,180,255,alpha)
	end
	local guild_name = ent:GetGuildName()
	if guild_name ~= nil and guild_name ~= "" then guild_name = "<"..guild_name..">" end
	if title == nil then title = "" end
	draw.RoundedBoxEx(10,targetScreenpos.x - 70,targetScreenpos.y-32,140,32,Color(0,0,0,alpha/2),true,true,false,false)
	draw.SimpleTextOutlined(ent:Name(), "FloatText1", tonumber(targetScreenpos.x) - 64, tonumber(targetScreenpos.y)-30, color, 0, 0, 1, Color(0,0,0,alpha))
	draw.SimpleTextOutlined("Lv "..ent:GetLevel(), "FloatText2", tonumber(targetScreenpos.x) + 64, tonumber(targetScreenpos.y)-30, Color(220,220,220,alpha), 2, 0, 1, Color(0,0,0,alpha))
	draw.SimpleTextOutlined(title, "FloatText2", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y)-46, Color(220,180,0,alpha), 1, 0, 1, Color(0,0,0,alpha))
	draw.RoundedBox(6,targetScreenpos.x - 64,targetScreenpos.y-16,128,12,Color(80,0,0,alpha))
	draw.RoundedBox(6,targetScreenpos.x - 64,targetScreenpos.y-16,FixSize(128, ent:Health(), ent:GetMaxHealth()),12,Color(180,0,0,alpha))
	draw.SimpleTextOutlined(guild_name, "FloatText2", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y)-17, Color(25,220,25,alpha), 1, 0, 1, Color(0,0,0,alpha))

end

-- Draw Corpse Tag
local function DrawCorpseTag(ent,targetScreenpos,alpha)

	local decay = ((ent:GetNWInt("deathtime") + 600) - CurTime())
	local color = Color(160,160,160,alpha)
	draw.RoundedBoxEx(10,targetScreenpos.x - 70,targetScreenpos.y-32,140,32,Color(0,0,0,alpha/2),true,true,false,false)
	draw.SimpleTextOutlined(ent:GetNWString("owner"), "FloatText1", tonumber(targetScreenpos.x) - 64, tonumber(targetScreenpos.y)-30, color, 0, 0, 1, Color(0,0,0,alpha))
	draw.RoundedBox(6,targetScreenpos.x - 64,targetScreenpos.y-16,128,12,Color(80,80,80,alpha))
	
	if decay > 1 then
		draw.SimpleTextOutlined("Decays in: "..string.FormattedTime(decay, "%02i:%02i"), "FloatText1", tonumber(targetScreenpos.x) - 32, tonumber(targetScreenpos.y)-18, color, 0, 0, 1, Color(0,0,0,alpha))
	else
		draw.SimpleTextOutlined("Decaying..", "FloatText1", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y)-18, color, 1, 0, 1, Color(0,0,0,alpha))
	end
	
end

-- Draw Terminals
local function DrawTerminals(ent,targetScreenpos,alpha)
	local termtype = nil
	if ent:GetClass() == "mmo_rebel_bank" or ent:GetClass() == "mmo_combine_bank" then termtype = "Banking Terminal"
	elseif ent:GetClass() == "mmo_gunsmithing" then termtype = "Gunsmiths Crate"
	elseif ent:GetClass() == "mmo_engineering" then termtype = "Engineering Workspace"
	elseif ent:GetClass() == "mmo_researching" then termtype = "Research Station"
	elseif ent:GetClass() == "mmo_demolitions" then termtype = "Demolitions Computer"
	elseif ent:GetClass() == "mmo_marketplace" then termtype = "Market Terminal"
	else
		termtype = "Unknown Terminal"
	end
	local color = Color(220,220,220,alpha)
	draw.SimpleTextOutlined(termtype, "FloatText1", tonumber(targetScreenpos.x), tonumber(targetScreenpos.y)-30, color, 1, 1, 1, Color(0,0,0,alpha))
	
end

-- Return ScreenPos
local function ScreenPos(target)
	local targetPos = target:GetPos() + Vector(0,0,target:OBBMaxs().z + float_height) --Vector(0,0,float_height)
	return targetPos:ToScreen()
end

-- Distance Between Screen and Player
local function TargetDistance(target)
	local local_position = LocalPlayer():GetPos()
	return math.floor((local_position:Distance(target:GetPos())))
end

-- Collect incoming information and dispatch it to be drawn
local function CollectInfo(ent,npc,d)

	local screen_pos = ScreenPos(ent)
	local alpha = 255
	local name
	if d >= full_alpha then alpha = math.abs(d - (max_d - 1)) end
	
	if npc then
		DrawTag(NPCInfo(ent, false), screen_pos, NPCInfo(ent, true), alpha, ent)
	else	
		DrawPCTag(ent, screen_pos, alpha)
	end
	
end
local function BodyInfo(ragdoll,d)

	local screen_pos = ScreenPos(ragdoll)
	local alpha = 255
	local name
	if d >= full_alpha then alpha = math.abs(d - (max_d - 1)) end
	
	DrawCorpseTag(ragdoll, screen_pos, alpha)
	
end

-- Display NPCs
local function TagTerms()
	for _,ent in pairs(ents.FindByClass("mmo_*")) do
		local d = TargetDistance(ent)
		if d < max_d then
			local screen_pos = ScreenPos(ent)
			local alpha = 255
			local name
			if d >= full_alpha then alpha = math.abs(d - (max_d - 1)) end
			
			DrawTerminals(ent, screen_pos, alpha)
		end
	end
end

-- Display NPCs
local function TagNPC()
	for _,npc in pairs(ents.FindByClass("npc_*")) do
		local d = TargetDistance(npc)
		if d < max_d then
			if LocalPlayer():IsLineOfSightClear(npc) then CollectInfo(npc,true,d) end
		end
	end
end

-- Display Players
local function TagPC()
	for _,ply in pairs(player.GetAll()) do
		if ply ~= LocalPlayer() then
			local d = TargetDistance(ply)
			if d < max_d then
				if LocalPlayer():IsLineOfSightClear(ply) then
					
					CollectInfo(ply,false,d)
					
				end
			end
		end
	end
end

local function TagBodies()
	for _,ragdoll in pairs(ents.FindByClass("prop_ragdoll")) do
		local d = TargetDistance(ragdoll)
		if d < max_d then
			if LocalPlayer():IsLineOfSightClear(ragdoll) then BodyInfo(ragdoll,d) end
		end
	end
end

hook.Add("HUDPaint", "FloatName", function()
	TagNPC()
	TagPC()
	TagBodies()
	TagTerms()
end)