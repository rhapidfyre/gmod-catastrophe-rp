
include("sv_vars.lua")
include("shared.lua")
include("sh/utils.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_vars.lua")


local LuaFiles = { ["lua"] = true, }
ProcDirTree("catastropherp/gamemode/sv", "LUA", include, LuaFiles)
ProcDirTree("catastropherp/gamemode/cl", "LUA", AddCSLuaFile, LuaFiles)
ProcDirTree("catastropherp/gamemode/sh", "LUA", AddCSLuaFile, LuaFiles)

function GM:PreGamemodeLoaded()
	ProcDirTree("gamemodes/catastropherp/content", "GAME", util.PrecacheModel, { ["mdl"] = true, ["vmt"] = true, })
	ProcDirTree("gamemodes/catastropherp/content", "GAME", util.PrecacheSound, { ["wav"] = true, ["mp3"] = true, })
end

function GM:Initialize()
end

function GM:InitPostEntity()
	local invulnerables = {
		"npc_alyx",
		"npc_monk",
		"npc_eli",
		"npc_kleiner",
		"npc_mossman",
		"npc_dog"
	}
	for k,v in pairs(ents.GetAll()) do
		if table.HasValue(invulnerables, v:GetClass()) then
			v:SetLevel(1000)
			v:SetMaxHealth(9999)
			v:SetHealth(9999)
		end
	end
end