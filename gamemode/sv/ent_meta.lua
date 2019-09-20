--[[local entmeta = FindMetaTable("Entity")

function entmeta:SetTeam(value)
    self:SetKeyValue("TeamNum", value)
end

function entmeta:Team()
    return (self:GetKeyValues()["TeamNum"])
end]]