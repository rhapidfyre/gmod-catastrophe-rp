
local allow_voice = true
LocalPlayer().SuitTalking = false

local function VoxNotify(dmg, dmgType)

	local hitpoints = LocalPlayer():Health()
	
	if dmgType == DMG_CRUSH or dmgType == DMG_FALL then
		
		if dmg > 65 then
			surface.PlaySound("hl1/fvox/fuzz.wav")
			timer.Simple(0.25, function() surface.PlaySound("hl1/fvox/fuzz.wav") end)
			timer.Simple(0.5, function() surface.PlaySound("hl1/fvox/fuzz.wav") end)
			
			timer.Simple(0.75, function()
				surface.PlaySound("hl1/fvox/major_fracture.wav")
				end)
		elseif dmg > 20 then
			surface.PlaySound("hl1/fvox/fuzz.wav")
			timer.Simple(0.25, function() surface.PlaySound("hl1/fvox/fuzz.wav") end)
			
			timer.Simple(0.5, function()
				surface.PlaySound("hl1/fvox/minor_fracture.wav")
				end)
		end
		
	else
	
		if hitpoints <= 60 and hitpoints > 0 then
	
			if 		hitpoints >= 50 then
				surface.PlaySound("hl1/fvox/fuzz.wav")
				timer.Simple(0.25, function() surface.PlaySound("hl1/fvox/blood_loss.wav") end)
			elseif 	hitpoints >= 37 then
				surface.PlaySound("hl1/fvox/fuzz.wav")
				timer.Simple(0.25, function() surface.PlaySound("hl1/fvox/health_dropping.wav") end)
			elseif 	hitpoints >= 10 then
				surface.PlaySound("hl1/fvox/fuzz.wav")
				timer.Simple(0.25, function() surface.PlaySound("hl1/fvox/health_critical.wav") end)
			elseif 	hitpoints < 10 then
				surface.PlaySound("hl1/fvox/fuzz.wav")
				timer.Simple(0.25, function() surface.PlaySound("hl1/fvox/near_death.wav") end)
			end
			
		elseif hitpoints <= 0 then
		
			surface.PlaySound("hl1/fvox/beep.wav")
			timer.Simple(0.8, function() surface.PlaySound("hl1/fvox/beep.wav") end)
			timer.Simple(1.6, function() surface.PlaySound("hl1/fvox/beep.wav") end)
			timer.Simple(2.4, function() surface.PlaySound("hl1/fvox/flatline.wav") end)
			
		end
	
	end
	
end

net.Receive("MMO_FVox", function()

	local dmg 		= net.ReadInt(32)
	local dmgType 	= net.ReadInt(32)
	
	if LocalPlayer().SuitTalking then VoxNotify(dmg, dmgType) end
	
end)

net.Receive("MMO_PickupSound", function()
	print("[DEBUG] Pick up item sound")
	surface.PlaySound("items/ammo_pickup.wav")
end)

net.Receive("MMO_LevelUp", function()
    print("(DEBUG) Level-Up Sound")
    surface.PlaySound("misc/levelup.wav")
end)



