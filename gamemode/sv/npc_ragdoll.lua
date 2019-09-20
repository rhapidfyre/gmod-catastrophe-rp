
function GM:CreateEntityRagdoll(ent, ragdoll)
	print("Ragdoll: "..tostring(ragdoll).. " belongs to "..tostring(ent))
	ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ragdoll.Owner = ent
	ragdoll.Expired = false
	ragdoll.DeathTime = CurTime()
	ragdoll:SetNWInt("deathtime", CurTime())
	ragdoll:SetNWString("owner", ent:GetNWString("targetname"))
	ragdoll:SetNWBool("corpse", true)
	ragdoll:SetNWBool("lootable", false)
end