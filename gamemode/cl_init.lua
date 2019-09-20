
-- Include client code
include("shared.lua")
ProcDirTree("catastropherp/gamemode/cl", "LUA", include, { ["lua"] = true, })
ProcDirTree("catastropherp/gamemode/cl", "LUA", AddCSLuaFile, { ["lua"] = true, })

function GM:PreGamemodeLoaded()
	-- Precache content
	ProcDirTree("gamemodes/catastropherp/content", "GAME", util.PrecacheModel, { ["mdl"] = true, ["vmt"] = true, })
	ProcDirTree("gamemodes/catastropherp/content", "GAME", util.PrecacheSound, { ["wav"] = true, ["mp3"] = true, })
end