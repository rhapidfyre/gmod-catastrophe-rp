	
local teams = {
	{0,		"Spectator",Color(150,150,150,255),		true,	"info_player_start"},			-- Specs
	{1,		"Rebel",	Color(0,60,220,225),		true,	"info_player_deathmatch"},		-- Rebel Team Spawns
	{2,		"Combine",	Color(255,80,80,255),		true,	"info_player_combine"},			-- Combine Team Spawns
	{3,		"Xen",		Color(255,80,80,255),		false,	"info_player_xen" }				-- Shouldn't be a factor
}

for n,r in pairs(teams) do
	--          #,name,color,joinable
	team.SetUp( n, r[2], r[3], r[4] )
	team.SetSpawnPoint(n,r[5])
end
--[[
DEFINE_BASECLASS("player_default")
local PLAYER = {}
PLAYER.WalkSpeed = 400
PLAYER.RunSpeed  = 1000
	
function PLAYER:SetupDataTables()

	self.Player:NetworkVar("Int",0,"Strength")
	self.Player:NetworkVar("Int",1,"Constitution")
	self.Player:NetworkVar("Int",2,"Stamina")
	self.Player:NetworkVar("Int",3,"Dexterity")
	self.Player:NetworkVar("Int",4,"Intelligence")
	self.Player:NetworkVar("Int",5,"Charisma")
	self.Player:NetworkVar("Int",6,"Level")
	self.Player:NetworkVar("Int",7,"StatPoints")
	self.Player:NetworkVar("Int",8,"Engineering")
	self.Player:NetworkVar("Int",9,"Demolitions")
	self.Player:NetworkVar("Int",10,"Researching")
	self.Player:NetworkVar("Int",11,"Gunsmithing")
	self.Player:NetworkVar("Int",12,"Scavenging")
	
	self.Player:NetworkVar("Bool",0,"Initialized")
	self.Player:NetworkVar("Bool",1,"Female")
	
	self.Player:NetworkVar("Float",0,"Money")
	self.Player:NetworkVar("Float",1,"Experience")
	self.Player:NetworkVar("Float",2,"NextLevel")
	self.Player:NetworkVar("Float",3,"Hunger")
	self.Player:NetworkVar("Float",4,"Thirst")
	self.Player:NetworkVar("Float",5,"Endurance")
	self.Player:NetworkVar("Float",6,"Oxygen")
	
	self.Player:NetworkVar("String",0,"GuildName")
	self.Player:NetworkVar("String",1,"PlayerTitle")
	
end
player_manager.RegisterClass("player_custom", PLAYER, "player_default")]]