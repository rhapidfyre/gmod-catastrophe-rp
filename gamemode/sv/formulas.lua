
function StatModifier(value)
	print("[DEBUG] Stat Modifier: "..tostring(STAT_MOD * (value * .01)) )
	return ( STAT_MOD * (value * .01) )
end

-- Takes in player/npc Consitution, their base hp, and their current level.
-- npc: Bool -> Is entity NPC? They get an advantage.
function CalculateHitpoints(con, level, npc)
	
	local new_value = ((BASE_HP) + (HP_MODIFY*(level-1))) + (((BASE_HP) + (HP_MODIFY*(level-1)))*(StatModifier(con)))
	return (math.Round(math.abs(new_value), 2))

end

-- Takes in player/npc Dexterity, their base damage, and their current level.
-- npc: Bool -> Is entity NPC? Give advantage.
function CalculateDamageBon(dex, base, level, npc)

	local new_value = ((base) + (DMG_MODIFY*(level-1))) + (((base) + (DMG_MODIFY*(level-1)))*(StatModifier(dex)))
	return (math.Round(math.abs(new_value), 2))

end

function CalculateRegen(sta, base, level, npc)
	
	local value = ((HP_REGEN +(((level))-1)) + (((HP_REGEN + (((level))-1)))*(StatModifier(sta))))
	
	if npc then
		value = (value * NPC_ADV_HP)
	end
	
	return math.Round(math.abs(value))
	
end