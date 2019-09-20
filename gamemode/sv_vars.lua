
-- Contains all the variables that span across more than 1 Lua file

SAVE_INTVL		= 120
LOOT_DISTANCE	= 128

BASE_HP			= 100
EXP_KILL 		= 25	-- Base Experience per kill
EXP_PENALTY		= 0.05	-- Percent of EXP to remove upon death
	
HP_MODIFY 		= 5		-- Base HP Modifier for Calculating Hitpoint Maximum
DMG_MODIFY		= 2		-- Base DMG Modifier for Calculating Base Damage
	
NPC_ADV_HP		= 1.2	-- HP Advantage given to NPCs
NPC_ADV_DMG		= 1.2	-- DMG Advantage given to NPCs
	
HP_PER_LVL		= 3		-- HP given per level in addition to Constitution Modifier	(level * HP_PER_LVL)
DMG_PER_LVL		= 1		-- DMG Given per level in addition to Dexterity/Strength Modifier (level * DMG_PER_LVL)
	
STAT_MOD		= 4		-- Stat Modifier
	
DECAY_ITEM		= 60	-- Time (in seconds) until dropped props disappear forever
regen_time 		= 2		-- Time (in seconds) between regenerating health (NOT USED AS OF 6/26/2017)
post_combat 	= 6		-- Time someone must wait since last injury to begin regenerating health
HP_REGEN 		= 5		-- Amount of HP regenerated every (regen_time)