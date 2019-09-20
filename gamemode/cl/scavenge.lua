
local last_scav = CurTime()

--[[
    OnSpawnMenuOpen()
    Runs the Scavenge ability.
]]
hook.Add("OnSpawnMenuOpen", "Scavenge", function()

	if last_scav < CurTime() then
		last_scav = CurTime() + 30
		net.Start("MMO_Scavenge")
			net.SendToServer()
	else
		chat.AddText(Color(180,80,80), "[SCAVENGING] You must wait "..tostring(math.Round(last_scav - CurTime()), 0).." seconds to use Scavenge again.")
		print(last_scav)
		print(CurTime())
	end

end)