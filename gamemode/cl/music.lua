local play_music = true
local last_play = CurTime()
local deathsong = false

local function AllowMusic(value) play_music = value end

net.Receive("MMO_PlayerDead", function()
	print("Playing Death Song...")
	timer.Simple(0.25, function()
		if play_music and !deathsong then
			surface.PlaySound("music/death_theme.wav")
		end
	end)
    table.Empty(inventory)
end)