local valid_textures = {}

net.Receive("MMO_Scavenge", function(len, ply)

	-- http://wiki.garrysmod.com/page/Enums/MAT
	local eyetrace = ply:GetEyeTrace()
	if ply.NextScavenge < CurTime() then
		ply.NextScavenge = CurTime() + 30
		
		-- All chances give small chance to win a weapon
		local wpnTable = {
			item_smg, item_ar2, item_pistol_ammo
		}
		
		-- Is the player underwater? If so, award "Water"
		
		-- What prop is the player looking at?
		
			-- TREE: Charcoal
			
			-- BROKE CARS: Rebar, 12v Battery, Metal Fragments, weapon parts
			
			-- COMBINE APC: Combine Ball, 12v Battery, Metal Fragments, Antigravity Matter
			
			-- TRASH CAN/DUMPSTER: Metal Fragments, Small Capsule, Dirty Syringe
			
		-- What surface is the player looking at?
		
			-- CONCRETE: Rebar, weapon parts
			
			-- OTHER: All except antigravity matter and combine ball
			
		
	end
end)