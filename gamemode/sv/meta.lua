
local meta = FindMetaTable("Player")
local exp_modifier = 0.10

--[[ Set server rank to give access to admin abilities
function meta:ServerRank(rank)
end

function meta:MetaWipe(value)

	self.MyGuild 		= nil
	self.MyTitle 		= nil
	self.MyLevel 		= nil
	self.MySkillPoints 	= nil
	self.MyStatPoints 	= nil
	self.MyExp 			= nil
	self.MyNext 		= nil
	self.Female 		= nil
	self.MyLevel 		= nil
	
	self.str 	= nil
	self.sta 	= nil
	self.con 	= nil
	self.dex 	= nil
	self.int 	= nil
	self.cha 	= nil
	
end

-- Returns player's guild name
-- guildname: Sets guild name if given
function meta:Guild(guildname)

	-- Check if obj var exists. If not, create it
	if self.MyGuild == nil then
		if self:GetNWString("guild") == nil  or self:GetNWString("guild") == 0 then
			self.MyGuild = ""
			self:GetNWString("guild", self.MyGuild)
		else self.MyGuild = self:GetNWString("guild") end
	end
	
	-- Then check if argument is given
	if guildname then
	
		-- If argument is given, update variable value
		self.MyGuild = guildname
		
	end
	-- Return value of obj var
	return self.MyGuild

end

-- Player title
function meta:Title(title)
	if self.MyTitle == nil then
		if self:GetNWString("title") == nil or self:GetNWString("title") == 0 then
			self.MyTitle = ""
			self:GetNWString("title", self.MyTitle)
		else self.MyTitle = self:GetNWString("title") end
	end
	
	if title then
		self.MyTitle = title
		timer.Simple(0.1, function() self:SetNWString("title", self.MyTitle) end)
	end
	
	return self.MyTitle
end

function meta:PlayerLevel(value)
	if self.MyLevel == nil or self.MyLevel == 0 then
		if self:GetNWInt("level") == nil or self:GetNWInt("level") == 0 then
			self.MyLevel = 1
			self:SetNWInt("level", self.MyLevel)
		else self.MyLevel = self:GetNWInt("level") end
	end
	
	if value then
		if (self.MyLevel == nil or !IsValid(self.MyLevel == "")) then
			self.MyLevel = 1
		else
			self.MyLevel = self.MyLevel + value
		end
		timer.Simple(0.1, function() self:SetNWInt("level", self.MyLevel) end)
	end
	
	return self.MyLevel
end

-- Current Skillpoints available. If no value given, returns value
function meta:SkillPoints(value)
	if self.MySkillPoints == nil then
		self.MySkillPoints = self:GetNWInt("skillpoints")
	end
	
	if value then
		self.MySkillPoints = self.MySkillPoints + value
		timer.Simple(0.1, function() self:SetNWInt("skillpoints", self.MySkillPoints) end)
	end
	
	return self.MySkillPoints
end

function meta:StatPoints(value)
	if self.MyStatPoints == nil then
		self.MyStatPoints = self:GetNWInt("statpoints")
	end
	
	if value then
		self.MyStatPoints = self.MyStatPoints + value
		timer.Simple(0.1, function() self:SetNWInt("statpoints", self.MyStatPoints) end)
	end
	net.Start("MMO_StatPoints")
		net.Send(self)
	return self.MyStatPoints
end

-- Current Experience
function meta:Experience(value)
	if self.MyExp == nil then
		self.MyExp = 0
		self:SetNWInt("experience", self.MyExp)
	end
	
	if value then
		self.MyExp = math.Round(self.MyExp + value, 0)
		timer.Simple(0.1, function() self:SetNWInt("experience", self.MyExp) end)
	end
	timer.Simple(0.25, function()
		if self.NextLevel ~= nil and self.MyExp ~= nil then
			if tonumber(self.MyExp) >= tonumber(self.MyNext) then
				-- Current level cap is set to 100
				if self:PlayerLevel() == 100 then
					self.MyExp = self.MyNext
				else
					local expCap = self.MyNext
					self:PlayerLevel(1)
					self.MyExp = math.Round(math.abs(self.MyNext - self.MyExp), 0)
					self.MyNext = math.Round(expCap + (expCap * exp_modifier), 0)
					
					sound.Play("ambient/alarms/warningbell1.wav", self:GetPos())
					PrintMessage(HUD_PRINTTALK, self:Nick().." has gained a level and is now Level ["..self.MyLevel.."]")
					self:SetNWInt("experience", self.MyExp)
					self:SetNWInt("next_level", self.MyNext)
					self:SetNWInt("level", self.MyLevel)
					self:StatPoints(2)
				end
			end
		end
	end)
	return self.MyExp
end

-- Experience to Hit Next Level
function meta:NextLevel(value)
	if self.MyNext == nil or self.MyNext == 0 then
		self.MyNext = 100
		self:SetNWInt("next_level", self.MyNext)
	end
	
	if value then
		self.MyNext = math.Round(self.MyNext + value, 2)
		timer.Simple(0.1, function() self:SetNWInt("next_level", self.MyNext) end)
	end
	
	return self.MyNext
end


]]







