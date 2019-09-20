
-- VARS
world_time = 0
local killer = nil
local iconmodel

-- Add a variable so we can use different HUDs
local use_hud = true

--[[ 	
	Functions
]]

local function CheckHealth()
	if ((LocalPlayer():Health()) < 25) then	return true	else return false end
end

local function EyeTarget()

end

local function Compass()
	local direction = math.Round(LocalPlayer():EyeAngles().y)
	
	local dir = nil
	-- NORTH: 		22.5 to -22.5
	-- NORTHWEST 	67.5 to 22.5
	-- WEST:		112.5 to 67.5
	-- SOUTHWEST	112.5 to 157.5
	-- SOUTH		157.5 to 180 AND -180 to -157.5
	-- SOUTHEAST	-157.5 to -112.5
	-- EAST:		-112.5 to -67.5
	-- NORTHEAST:	-67.5 to -22.5
	
	if		(direction <= 157.5 and direction > 112.5) 			then dir = "SOUTHWEST"
	elseif	(direction <= 112.5 and direction > 67.5)  			then dir = "WEST"
	elseif	(direction <= 67.5  and direction > 22.5)  			then dir = "NORTHWEST"
	elseif	(direction <= 22.5 and direction > (-22.5)) 		then dir = "NORTH"
	elseif	(direction <= (-22.5) and direction > (-67.5)) 		then dir = "NORTHEAST"
	elseif	(direction <= (-67.5) and direction > (-112.5)) 	then dir = "EAST"
	elseif	(direction <= (-112.5) and direction > (-157.5))	then dir = "SOUTHEAST"
	else										  	   			dir = "SOUTH"
	end
	draw.SimpleText(dir,"ChatFont",ScrW()/2,12,Color(180,180,180,255),1,1)
end

-- Draw and display the target player is looking at
local function DisplayTarget()

end

-- Draw the weapons information
local function WeaponsInfo()
	local curWpn = LocalPlayer():GetActiveWeapon()
	if curWpn:IsValid() then
		local wpnClass = curWpn:GetClass()
		if curWpn:GetPrintName() ~= nil then
			--draw.SimpleText(curWpn:GetPrintName(), "Trebuchet24", 330, ScrH()-128, Color(255,255,255), TEXT_ALIGN_CENTER,0)
		end
		if (wpnClass ~= "weapon_crowbar") then
			
			
			-- New Crosshair
			local eyetrace = LocalPlayer():GetEyeTrace()
			if eyetrace.Entity:IsPlayer() then
				if eyetrace.Entity:Team() == LocalPlayer():Team() then
					draw.SimpleText("-", "BudgetLabel", ScrW()/2, ScrH()/2, Color(0,255,0,255), TEXT_ALIGN_CENTER, 1)
                    if wpnClass == "weapon_crossbow" then
                        draw.SimpleText("FRIENDLY", "BudgetLabel", ScrW()/2 + 12, ScrH()/2 + 24, Color(0,255,0,255), TEXT_ALIGN_LEFT, 1)
                    end
				else
					draw.SimpleText("X", "BudgetLabel", ScrW()/2, ScrH()/2, Color(255,0,0,255), TEXT_ALIGN_CENTER, 1)
				end
			elseif eyetrace.Entity:IsNPC() then
				if NPCInfo(eyetrace.Entity) == LocalPlayer():Team() then
					draw.SimpleText("-", "BudgetLabel", ScrW()/2, ScrH()/2, Color(0,255,0,255), TEXT_ALIGN_CENTER, 1)
                    if wpnClass == "weapon_crossbow" then
                        draw.SimpleText("FRIENDLY", "BudgetLabel", ScrW()/2 + 12, ScrH()/2 + 24, Color(0,255,0,255), TEXT_ALIGN_LEFT, 1)
                    end
				else
					draw.SimpleText("X", "BudgetLabel", ScrW()/2, ScrH()/2, Color(255,0,0,255), TEXT_ALIGN_CENTER, 1)
				end
			else
				draw.SimpleText("X", "BudgetLabel", ScrW()/2, ScrH()/2, Color(200,200,0,40), TEXT_ALIGN_CENTER, 1)
			end
			
			-- Since the crossbow has a battery powered scope,
			-- let's give it a cool distance calculator on the HUD
			if wpnClass == "weapon_crossbow" then
			
				local eyetrace = LocalPlayer():GetEyeTrace()
				local distance = math.Round(eyetrace.HitPos:Distance(LocalPlayer():GetPos()), 0)
				local convert = distance * 0.01904 -- Convert from Units to Meters
				
				draw.SimpleText(math.Round(convert, 2).." m", "TargetIDSmall", ScrW()/2 + 128, ScrH()/2 +24, Color(200,200,0,120), TEXT_ALIGN_CENTER, 1)
				
			end
			
			
			if curWpn:Clip1() ~= -1 then
				draw.SimpleText(curWpn:Clip1(), "HUDText1", ScrW()-128, ScrH()-128, Color(255,255,40,255),TEXT_ALIGN_CENTER,0)
				draw.SimpleText(curWpn:Clip1(), "HUDText2", ScrW()-128, ScrH()-128, Color(255,180,40,120),TEXT_ALIGN_CENTER,0)
				draw.SimpleText(LocalPlayer():GetAmmoCount(curWpn:GetPrimaryAmmoType()), "HUDText0b", ScrW()-128, ScrH()-64, Color(255,255,40,255),TEXT_ALIGN_CENTER,0)
				draw.SimpleText(LocalPlayer():GetAmmoCount(curWpn:GetPrimaryAmmoType()), "HUDText0", ScrW()-128, ScrH()-64, Color(255,180,40,120),TEXT_ALIGN_CENTER,0)
			else
				draw.SimpleText(LocalPlayer():GetAmmoCount(curWpn:GetPrimaryAmmoType()), "HUDText1", ScrW()-128, ScrH()-102, Color(255,255,40,255),TEXT_ALIGN_CENTER,0)
				draw.SimpleText(LocalPlayer():GetAmmoCount(curWpn:GetPrimaryAmmoType()), "HUDText2", ScrW()-128, ScrH()-102, Color(255,180,40,120),TEXT_ALIGN_CENTER,0)
			end
			--[[
			if (LocalPlayer():GetAmmoCount(curWpn:GetSecondaryAmmoType()) > 0) then
				draw.SimpleText(LocalPlayer():GetAmmoCount(curWpn:GetSecondaryAmmoType()), "HUDText1", ScrW()-128, ScrH()-128, Color(255,255,40,255),TEXT_ALIGN_CENTER,0)
				draw.SimpleText(LocalPlayer():GetAmmoCount(curWpn:GetSecondaryAmmoType()), "HUDText2", ScrW()-128, ScrH()-128, Color(255,180,40,120),TEXT_ALIGN_CENTER,0)
			end]]
		end
	end
end

-- Draw the player info (Class, Health, Armor, etc)
local function PlayerInfo()
	-- Check for player health to set up trig value
	local less_than = CheckHealth()
	local trig = 255
	
	if less_than then
		trig = math.abs(math.sin(CurTime() * 5)) * 255
	end
	
	-- Sets health to display as a percentage
	local healthValue = math.Round(LocalPlayer():Health() / LocalPlayer():GetMaxHealth() * 100, 0)
	if healthValue > 100 then healthValue = 100 end
	if !(LocalPlayer():Alive()) then
		healthValue = 0
	end
	local armorValue = LocalPlayer():Armor()
	if !(LocalPlayer():Alive()) then
		armorValue = 0
	end
	
	-- Health Box
	--draw.SimpleText("+","HUDText1",48,ScrH()-102,Color(255,255,0,255),TEXT_ALIGN_CENTER)
	--draw.SimpleText("+","HUDText2",48,ScrH()-102,Color(255,180,0,120),TEXT_ALIGN_CENTER)
	draw.SimpleText(healthValue,"HUDText1",128,ScrH()-112,Color(255,255,0,255),TEXT_ALIGN_CENTER)
	draw.SimpleText(healthValue,"HUDText2",128,ScrH()-112,Color(255,180,0,120),TEXT_ALIGN_CENTER)
	
	-- Armor Box
	if LocalPlayer():Armor() > 0 then
		draw.SimpleText(armorValue,"HUDText1",320,ScrH()-112,Color(255,255,0,255),TEXT_ALIGN_CENTER)
		draw.SimpleText(armorValue,"HUDText2",320,ScrH()-112,Color(255,180,0,120),TEXT_ALIGN_CENTER)
	end
	
end

local function KillerName()
	if killer == nil then return "Nobody"
	elseif killer == LocalPlayer():Name() then return "yourself"
	else return killer
	end
end

local function DeathScreen()

	local killerName = KillerName()

	local flash = math.Clamp(math.abs(math.cos(CurTime() * 2) * 255), 32, 180)
	draw.RoundedBox(12,(ScrW()/2)-256,ScrH()/2 + 224,512,96,Color(40,40,40,200))
	draw.SimpleText(LocalPlayer():Name().." has been killed!", "DeathText1", ScrW()/2, ScrH()/2 + 244, Color(255,0,0,255), 1, 1)
	draw.SimpleText("You were killed by "..killerName.."!", "DeathText2", ScrW()/2, ScrH()/2 + 272, Color(255,100,0,255), 1, 1)
	draw.SimpleText("Left-Click or Jump to Respawn at the Rebel City", "DeathText2", ScrW()/2, ScrH()/2 + 308, Color(200,200,200,flash), 1, 1)
	
end

local function HUD()
	if LocalPlayer():Team() ~= 0 then
		PlayerInfo()
		if LocalPlayer():Alive() then
			DisplayTarget()
			WeaponsInfo()
			Compass()
			--MousePanel()
		else 
			DeathScreen()
		end
	end
end
hook.Add("HUDPaint", "TestHud", HUD)

-- Hide the default HUDs
local function HideHud(name)

	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair"}) do
		if name == v then
			return false
		end
	end
end
hook.Add("HUDShouldDraw", "HideDefaultHide", HideHud)

-- This removes the blood-red screen when a player dies
-- It also removes the red indicators, but it is a necessary evil.
hook.Add("HUDShouldDraw","DisableRedScreenOnDeath",function(name)
	if name == "CHudDamageIndicator" then return false end
end)

--[[
	Networking
]]

net.Receive("MMO_LevelUp", function()
	sound.Play("ui/achievement_earned.wav")
end)

net.Receive("MMO_KillerName", function()
	killer = net.ReadString()
end)