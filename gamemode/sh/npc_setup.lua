
-- TEAM: 1 Rebel 2 Combine 3 Xen 4 Neutral
-- Called by "NPC Name" function below NPCName()

local npc_title = {}
	npc_title["npc_alyx"] 			  = {}
	npc_title["npc_antlion"] 		  = {}
	npc_title["npc_antlionguard"] 	  = {}
	npc_title["npc_barnacle"] 		  = {}
	npc_title["npc_barney"] 		  = {} 
	npc_title["npc_breen"] 			  = {}
	npc_title["npc_citizen"] 		  = {}
	npc_title["npc_combine_s"] 		  = {}
	npc_title["npc_crow"] 			  = {}
	npc_title["npc_cscanner"] 		  = {}
	npc_title["npc_eli"] 			  = {}
	npc_title["npc_fastzombie"] 	  = {}
	npc_title["npc_fastzombie_torso"] = {}
	npc_title["npc_gman"] 			  = {}
	npc_title["npc_grenade_frag"] 	  = {}
	npc_title["npc_headcrab"] 		  = {}
	npc_title["npc_headcrab_black"]   = {}
	npc_title["npc_headcrab_fast"] 	  = {}
	npc_title["npc_helicopter"] 	  = {}
	npc_title["npc_kleiner"] 		  = {}
	npc_title["npc_magnusson"] 		  = {}
	npc_title["npc_manhack"] 		  = {}
	npc_title["npc_metropolice"] 	  = {}
	npc_title["npc_missiledefense"]   = {}
	npc_title["npc_monk"] 			  = {}
	npc_title["npc_mossman"] 		  = {}
	npc_title["npc_pigeon"] 		  = {}
	npc_title["npc_poisonzombie"] 	  = {}
	npc_title["npc_rollermine"] 	  = {}
	npc_title["npc_seagull"] 		  = {}
	npc_title["npc_sniper"] 		  = {}
	npc_title["npc_strider"] 		  = {}
	npc_title["npc_turret_ceiling"]   = {}
	npc_title["npc_turret_floor"] 	  = {}
	npc_title["npc_turret_ground"] 	  = {}
	npc_title["npc_vehicledriver"] 	  = {}
	npc_title["npc_vortigaunt"] 	  = {}
	npc_title["npc_zombie"] 		  = {}
	npc_title["npc_zombie_torso"] 	  = {}
	npc_title["npc_zombine"] 		  = {}
    npc_title["npc_dog"]              = {}

	npc_title["npc_alyx"]["title"] 					= "Alyx Vance"
	npc_title["npc_alyx"]["team"] 					= 1
		
	npc_title["npc_antlion"]["title"] 				= "Antlion"
	npc_title["npc_antlion"]["team"] 				= 3
			
	npc_title["npc_antlionguard"]["title"]			= "Antlion Guard"
	npc_title["npc_antlionguard"]["team"] 			= 3
			
	npc_title["npc_barnacle"]["title"] 				= "Barnacle"
	npc_title["npc_barnacle"]["team"] 				= 3
			
	npc_title["npc_barney"]["title"] 				= "Barney Calhoun"
	npc_title["npc_barney"]["team"] 				= 1
			
	npc_title["npc_breen"]["title"] 				= "Wallace Breen"
	npc_title["npc_breen"]["team"] 					= 2
			
	npc_title["npc_citizen"]["title"] 				= "Rebel Soldier"
	npc_title["npc_citizen"]["team"] 				= 1
			
	npc_title["npc_combine_s"]["title"] 			= "Combine Soldier"
	npc_title["npc_combine_s"]["team"] 				= 2
			
	npc_title["npc_crow"]["title"] 					= "A Crow"
	npc_title["npc_crow"]["team"] 					= 4
			
	npc_title["npc_cscanner"]["title"] 				= "City Scanner"
	npc_title["npc_cscanner"]["team"] 				= 2
			
	npc_title["npc_eli"]["title"] 					= "Eli Vance"
	npc_title["npc_eli"]["team"] 					= 1
	
	npc_title["npc_fastzombie"]["title"] 			= "Fast Zombie"
	npc_title["npc_fastzombie"]["team"] 			= 3
	
	npc_title["npc_fastzombie_torso"]["title"] 		= "Fast Zombie"
	npc_title["npc_fastzombie_torso"]["team"] 		= 3
	
	npc_title["npc_gman"]["title"] 					= "The G-Man"
	npc_title["npc_gman"]["team"] 					= 4
		
	npc_title["npc_grenade_frag"]["title"] 			= "*"
	npc_title["npc_grenade_frag"]["team"] 			= 4
		
	npc_title["npc_headcrab"]["title"] 				= "A Headcrab"
	npc_title["npc_headcrab"]["team"] 				= 3
		
	npc_title["npc_headcrab_black"]["title"] 		= "Poison Headcrab"
	npc_title["npc_headcrab_black"]["team"] 		= 3
		
	npc_title["npc_headcrab_fast"]["title"] 		= "Fast Headcrab"
	npc_title["npc_headcrab_fast"]["team"] 			= 3
		
	npc_title["npc_helicopter"]["title"] 			= "Combine Helicopter"
	npc_title["npc_helicopter"]["team"] 			= 2
		
	npc_title["npc_kleiner"]["title"] 				= "Dr. Kleiner"
	npc_title["npc_kleiner"]["team"] 				= 1
		
	npc_title["npc_magnusson"]["title"] 			= "Dr. Magnusson"
	npc_title["npc_magnusson"]["team"] 				= 1
		
	npc_title["npc_manhack"]["title"] 				= "A Manhack"
	npc_title["npc_manhack"]["team"] 				= 2
		
	npc_title["npc_metropolice"]["title"] 			= "Police Officer"
	npc_title["npc_metropolice"]["team"] 			= 2
		
	npc_title["npc_missiledefense"]["title"] 		= "Combine Mortar"
	npc_title["npc_missiledefense"]["team"] 		= 2
		
	npc_title["npc_monk"]["title"] 					= "The Armorer"
	npc_title["npc_monk"]["team"] 					= 1
		
	npc_title["npc_mossman"]["title"] 				= "Dr. Mossman"
	npc_title["npc_mossman"]["team"] 				= 2
		
	npc_title["npc_pigeon"]["title"] 				= "A Pigeon"
	npc_title["npc_pigeon"]["team"] 				= 4
		
	npc_title["npc_poisonzombie"]["title"] 			= "Poison Zombie"
	npc_title["npc_poisonzombie"]["team"] 			= 3
		
	npc_title["npc_rollermine"]["title"] 			= "A Rollermine"
	npc_title["npc_rollermine"]["team"] 			= 2
		
	npc_title["npc_seagull"]["title"] 				= "A Seagull"
	npc_title["npc_seagull"]["team"] 				= 4
		
	npc_title["npc_sniper"]["title"] 				= "Combine Sniper"
	npc_title["npc_sniper"]["team"] 				= 2
		
	npc_title["npc_strider"]["title"] 				= "Combine Strider"
	npc_title["npc_strider"]["team"] 				= 2
		
	npc_title["npc_turret_ceiling"]["title"] 		= "Ceiling Turret"
	npc_title["npc_turret_ceiling"]["team"] 		= 2
		
	npc_title["npc_turret_floor"]["title"] 			= "Combine Turret"
	npc_title["npc_turret_floor"]["team"] 			= 2
		
	npc_title["npc_turret_ground"]["title"] 		= "Ground Turret"
	npc_title["npc_turret_ground"]["team"] 			= 2
		
	npc_title["npc_vehicledriver"]["title"] 		= "APC Driver"
	npc_title["npc_vehicledriver"]["team"] 			= 4
		
	npc_title["npc_vortigaunt"]["title"] 			= "A Junk Dealer"
	npc_title["npc_vortigaunt"]["team"] 			= 1
	
	npc_title["npc_zombie"]["title"] 				= "Zombie"
	npc_title["npc_zombie"]["team"] 				= 3
		
	npc_title["npc_zombie_torso"]["title"] 			= "Zombie"
	npc_title["npc_zombie_torso"]["team"] 			= 3
		
	npc_title["npc_zombine"]["title"] 				= "Combine Zombie"
	npc_title["npc_zombine"]["team"] 				= 3
		
	npc_title["npc_dog"]["title"] 				    = "Dog"
	npc_title["npc_dog"]["team"] 				    = 1

    
hook.Add("OnEntityCreated", "SetNPCTeam", function(ent)
    local npcTeam = NPCInfo(ent, false)
    ent:SetKeyValue("TeamNum", npcTeam)
    ent:SetNWInt("EntTeam", npcTeam)
end)
    
-- returns "npc_name"
function NPCInfo(npc, argu)
	if IsValid(npc) then
		if npc:IsNPC() then
			if argu then
				return npc_title[npc:GetClass()]["title"]
			else
				return npc_title[npc:GetClass()]["team"]
			end
        else return 3
		end
    else return 3
	end
end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	