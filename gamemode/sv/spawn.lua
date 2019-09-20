
function SetSpectator(ply, obs)
	if obs == 1 then
		ply:Spectate(6)
		ply:SpectateEntity(nil)
		ply:SetNoTarget(true)
	elseif obs == 0 then
		ply:UnSpectate()
		ply:SetNoTarget(false)
	end
end

function IsSpectator(ply)

	local OBS = ply:GetObserverMode()
	
	if ( OBS == 6 || ply:Team() == 7 || ply:Team() == 2 ) then return true
	else return false
	end
end

function GM:PlayerInitialSpawn(ply)

	ply:SetTeam(0)
	SetSpectator(ply, 1)
	net.Start("MMO_CharCreate")
		net.Send(ply)
	
end

function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	if (info) then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end

function GM:PlayerSpawn(ply)
	if ply:Team() ~= 0 then
		print(ply:GetName().." spawned.")
		
		SetSpectator(ply, 0)
		
		ply:SetMaxHealth(CalculateHitpoints(ply:GetConstitution(), ply:GetLevel(), false))
		
		ply:SetupHands()
		
		ply:Give("weapon_pistol")
		ply:Give("weapon_crowbar")
		ply:Give("item_ammo_pistol")
		ply:Give("item_ammo_pistol")
		ply:Give("item_ammo_pistol")
		ply:Give("item_ammo_pistol")
		
		-- Give server time to catch up
		timer.Simple(0.25, function()
            ply:SetHealth(ply:GetMaxHealth())
        
            -- Make sure team factions are reset
            for k,v in pairs(ents.FindByClass("npc_*")) do
                if IsValid(v) then
                    if v:GetKeyValues()["TeamNum"] < 3 then
                        if NPCInfo(v, false) == ply:Team() then
                            v:AddEntityRelationship(ply, D_LI, 99)
                        else
                            v:AddEntityRelationship(ply, D_HT, 99)
                        end
                    end
                end
            end
        end)
        
	else
		SetSpectator(ply, 1)
		GAMEMODE:PlayerSpawnAsSpectator(ply)
	end
	
end