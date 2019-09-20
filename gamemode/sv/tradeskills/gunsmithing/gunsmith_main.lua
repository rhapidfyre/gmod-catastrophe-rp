
-- Handles Initiation of the Gunsmithing Tradeskill
hook.Add("KeyPress", "GunsmithOpen", function(ply, key)
	if (key == IN_USE) then
		print("[DEBUG] Player pressed USE on an object.")
		if IsValid(ent) then
			if ent:GetModel() == "models/items/ammocrate_pistol.mdl" then
				print("[DEBUG] Player using Gunsmithing Crate...")
			end
		end
	end
end)