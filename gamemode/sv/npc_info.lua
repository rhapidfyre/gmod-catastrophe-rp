
local idling = {}
    idling[1] = true
    idling[2] = true
    idling[3] = true

-- Return to spawn point
hook.Add("ServerTick", "SpawnReturn", function()
    for k,v in pairs (ents.FindByClass("npc_*")) do
        local spawnpt = v:GetSpawnPoint()
        if spawnpt:Distance(v:GetPos()) > 256 then
            if idling[v:GetCurrentSchedule()] then
                v:SetLastPosition(spawnpt)
                v:SetSaveValue("m_vecLastPosition", spawnpt)
                v:SetSchedule(SCHED_FORCED_GO)
            end
        end
    end
end)