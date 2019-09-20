
-- Variables for storing during creation
local team_choice 	= 1
local gender		= false
local myGender		= nil
local model			= nil
local statboost		= nil
local statname		= nil
local team_name		= nil

local menu			= nil
local submenu1		= nil
local submenu2		= nil
local modelview		= "player/kleiner.mdl"
local stathovered	= nil

local play_music	= true
local currPage		= 1


local function ClearPrevious()
	if (submenu1 ~= nil) then
		submenu1 = nil
	end
	if (submenu2 ~= nil) then
		submenu2 = nil
	end
end

local function FinalSubmit()
	LocalPlayer():ConCommand("stopsound")
	
	if statname == "Strength" 			then statboost = "str"
	elseif statname == "Dexterity" 		then statboost = "dex"
	elseif statname == "Constitution" 	then statboost = "con"
	elseif statname == "Intelligence" 	then statboost = "int"
	elseif statname == "Stamina" 		then statboost = "sta"
	elseif statname == "Charisma"		then statboost = "cha"
	else 								     statboost = "cha"
	end
	
	timer.Simple(0.25, function() 
		net.Start("MMO_CharSubmit")
			net.WriteInt(team_choice, 8)
			net.WriteBool(gender)
			net.WriteString(model)
			net.WriteString(statboost)
			net.SendToServer()
	end)
end

local function Intro()
	draw.SimpleText("It is the month after Dr. Freeman destroyed the City 17 Citadel.", "Trebuchet18", submenu1:GetWide()/2, 18, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Rumor has it that Alyx and Dr. Freeman have left for the Borealis.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Nobody has reported their arrival or safe return, leaving both sides of the war uneasy.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", 4, 72, Color(200,200,200,255))
	draw.SimpleText("The civil war is now in full effect. Rebels and Combines fight over territory,", "Trebuchet18", submenu1:GetWide()/2, 90, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("each trying to wipe the other out. The Rebels are no longer underground, fighting", "Trebuchet18", submenu1:GetWide()/2, 108, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("openly on the topside and establishing bases anywhere they can.", "Trebuchet18", submenu1:GetWide()/2, 126, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", 4, 144, Color(200,200,200,255))
	draw.SimpleText("The Black Mesa Science Team still has not found a way to erradicate Xen life from Earth,", "Trebuchet18", submenu1:GetWide()/2, 162, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("and with the civil war raging on like never before, their efforts are becoming more complicated.", "Trebuchet18", submenu1:GetWide()/2, 180, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("There are no more established cities. People are either rebel soldiers, combine puppets,", "Trebuchet18", submenu1:GetWide()/2, 198, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("or food for the creatures of Xen.", "Trebuchet18", submenu1:GetWide()/2, 216, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", 4, 234, Color(200,200,200,255))
	draw.SimpleText("It is the time where the Rebels have deployed their Underground Forces, and the Combine", "Trebuchet18", submenu1:GetWide()/2, 252, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("dispatch their Elite Squadron... The most elite of their armies. They train hard, build", "Trebuchet18", submenu1:GetWide()/2, 270, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("their own legacies, and create masterwork items to make themselves and their friends stronger...", "Trebuchet18", submenu1:GetWide()/2, 288, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", 4, 306, Color(200,200,200,255))
	draw.SimpleText("And this is where your legacy begins...", "Trebuchet18", submenu1:GetWide()/2, 324, Color(200,200,200,255),TEXT_ALIGN_CENTER)
end

local function TeamDescription()
	draw.SimpleText("Rebellion Special Forces", "Trebuchet24", submenu1:GetWide()/2, 18, Color(80,120,255,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Ally yourself with the Rebellion, and fight off Combine from the planet.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Rebels start at Station 84 in the underground railroad.", "Trebuchet18", submenu1:GetWide()/2, 72, Color(200,200,200,255), TEXT_ALIGN_CENTER)
	draw.SimpleText("Rebels can choose any male, female, or medic rebel model.", "Trebuchet18", submenu1:GetWide()/2, 90, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 108, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 126, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 144, Color(200,200,200,255), TEXT_ALIGN_CENTER)
	draw.SimpleText("Combine Elite Squadron", "Trebuchet24", submenu1:GetWide()/2, 162, Color(255,180,50,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 180, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Wake up as one of the Combine Elite and erradicate the Rebellion!", "Trebuchet18", submenu1:GetWide()/2, 198, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Combines start near City 13 at the Forward Detachment Base", "Trebuchet18", submenu1:GetWide()/2, 216, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Combines can only be male, and can choose from any of the 3 combine models.", "Trebuchet18", submenu1:GetWide()/2, 234, Color(200,200,200,255),TEXT_ALIGN_CENTER)

end

local function GenderDescription()
	draw.SimpleText("Rebel Female", "Trebuchet24", submenu1:GetWide()/2, 18, Color(255,60,180,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Typically more logical than men, with the sterilization of the human race by the combine,", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("women have become some of the most thoughtful, organized, and ferocious leaders in battle.", "Trebuchet18", submenu1:GetWide()/2, 72, Color(200,200,200,255), TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 90, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 108, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 126, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 144, Color(200,200,200,255), TEXT_ALIGN_CENTER)
	draw.SimpleText("Rebel Male", "Trebuchet24", submenu1:GetWide()/2, 162, Color(40,40,255,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 180, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("Since male's no longer seek female companionship due to the combine's sterilization,", "Trebuchet18", submenu1:GetWide()/2, 198, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("they have nothing else to focus on except becoming the most valiant soldier on the battlefield.", "Trebuchet18", submenu1:GetWide()/2, 216, Color(200,200,200,255),TEXT_ALIGN_CENTER)

end

local function StatsDescription()
	draw.SimpleText("* Pick one stat to start with a +2 bonus *", "DebugFixedSmall", submenu1:GetWide()/2, 8, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	
	if stathovered == "Strength" then
		draw.SimpleText("Strength", "Trebuchet24", submenu1:GetWide()/2, 18, Color(255,0,0,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Strength determines how quickly you can build things in tradeskills.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("It also determines your damage bonus when using melee weapons.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	elseif stathovered == "Constitution" then
		draw.SimpleText("Constitution", "Trebuchet24", submenu1:GetWide()/2, 18, Color(0,180,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Constitution affects your maximum hitpoints.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Players who put points into constitution will have more health.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("This bonus health also applies to negative constitution affects", "Trebuchet18", submenu1:GetWide()/2, 72, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	elseif stathovered == "Stamina" then
		draw.SimpleText("Stamina", "Trebuchet24", submenu1:GetWide()/2, 18, Color(245,65,65,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Stamina impacts hitpoint regeneration per tick.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Higher stamina provides more hitpoints on regen check.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	elseif stathovered == "Dexterity" then
		draw.SimpleText("Dexterity", "Trebuchet24", submenu1:GetWide()/2, 18, Color(255,150,20,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Dexterity determines maximum sprinting speed, and movement speed.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("How dexterous you are also affects your damage bonus from using firearms", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	elseif stathovered == "Intelligence" then
		draw.SimpleText("Intelligence", "Trebuchet24", submenu1:GetWide()/2, 18, Color(80,50,220,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Intelligence is solely a tradeskill stat; No combat mechanics rely on this.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("The higher your Intelligence is, the more likely your combinations will succeed.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("A higher intelligence also affects how often your tradeskill progresses to a higher level.", "Trebuchet18", submenu1:GetWide()/2, 72, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	elseif stathovered == "Charisma" then
		draw.SimpleText("Charisma", "Trebuchet24", submenu1:GetWide()/2, 18, Color(255,60,160,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Charisma is how well you deal with other people; Social interaction.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Very charismatic people will get better prices when buying and selling items.", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Charisma will also affect loot rarity. Higher charisma = better items.", "Trebuchet18", submenu1:GetWide()/2, 72, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("HOVER A STAT CHOICE FOR MORE INFO", "Trebuchet24", submenu1:GetWide()/2, 18, Color(255,0,0,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("Choose ONE (1) stat to be given a (+2) bonus upon starting the game.", "Trebuchet18", submenu1:GetWide()/2, 36, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("", "Trebuchet18", submenu1:GetWide()/2, 54, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("WARNING: If you reset this character's stats at a later time in the game,", "Trebuchet18", submenu1:GetWide()/2, 72, Color(200,200,200,255),TEXT_ALIGN_CENTER)
		draw.SimpleText("this bonus is lost forever on this character!!", "Trebuchet18", submenu1:GetWide()/2, 90, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	end
end

local function Confirmation()
	draw.SimpleText("Character Confirmation", "Trebuchet24", submenu1:GetWide()/2, 18, Color(255,180,60,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("", "Trebuchet18", 12, 36, Color(80,120,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("NAME", "Trebuchet24", 64, 54, Color(80,120,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet18", 12, 72, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText(LocalPlayer():Name(), "Trebuchet18", 72, 90, Color(200,200,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet18", 12, 108, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("SEX", "Trebuchet24", 64, 126, Color(80,120,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet24", 12, 144, Color(80,120,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText(myGender, "Trebuchet18", 72, 162, Color(200,200,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet18", 12, 180, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText("ALLIANCE", "Trebuchet24", 64, 198, Color(80,120,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet18", 12, 216, Color(200,200,200,255),TEXT_ALIGN_CENTER)
	draw.SimpleText(team_name, "Trebuchet18", 72, 234, Color(200,200,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet18", 12, 252, Color(200,200,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("STAT BONUS", "Trebuchet24", 64, 270, Color(80,120,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText("", "Trebuchet18", 12, 288, Color(200,200,200,255),TEXT_ALIGN_LEFT)
	draw.SimpleText(statname.." +2", "Trebuchet18", 72, 304, Color(200,200,200,255),TEXT_ALIGN_LEFT)
end

local function PageOneButtons()
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),64)
	button.Paint = function()
		if button:IsHovered() then
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,220,180,255))
			draw.SimpleTextOutlined("Create a New Character", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Create a New Character", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
		end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	button.DoClick = function()
		currPage = 2
		menu:Close()
		timer.Simple(0.25, function()
			DrawMenu()
		end)
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),128)
	button.Paint = function()
		if button:IsHovered() then
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,220,180,255))
			draw.SimpleTextOutlined("Continue Previous Character", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Continue Previous Character", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
		end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	button.DoClick = function()
		net.Start("MMO_LoadChar")
			net.SendToServer()
		menu:Close()
		gui.EnableScreenClicker(false)
		LocalPlayer():ConCommand("stopsound")
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),192)
	button.Paint = function()
		if button:IsHovered() then
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,220,180,255))
			draw.SimpleTextOutlined("Toggle Menu Music", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Toggle Menu Music", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
		end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	button.DoClick = function()
		if play_music == true then
			play_music = false
			LocalPlayer():ConCommand("stopsound")
		else
			play_music = true
			surface.PlaySound("music/catastrophe_intro.wav")
		end
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),256)
	button.Paint = function()
		if button:IsHovered() then
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(220,180,180,255))
			draw.SimpleTextOutlined("Disconnect", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,180,180,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Disconnect", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
		end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	button.DoClick = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		LocalPlayer():ConCommand("disconnect")
	end
end

local function PageTwoButtons()
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),64)
	button.Paint = function()
		draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
		draw.SimpleTextOutlined("Rebel Special Forces", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
	function button:OnCursorEntered()
		surface.PlaySound("vo/npc/barney/ba_letsdoit.wav")
	end
	button.DoClick = function()
		currPage = 3
		menu:Close()
		timer.Simple(0.25, function()
			DrawMenu()
		end)
		surface.PlaySound("vo/npc/barney/ba_laugh01.wav")
	end
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),128)
	button.Paint = function()
		draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
		draw.SimpleTextOutlined("Combine Elite Squad", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
	function button:OnCursorEntered()
		surface.PlaySound("npc/metropolice/vo/unitis10-8standingby.wav")
	end
	button.DoClick = function()
		currPage = 4
		team_choice = 2
		myGender = "Male"
		menu:Close()
		timer.Simple(0.25, function()
			DrawMenu()
		end)
		surface.PlaySound("npc/metropolice/vo/covermegoingin.wav")
	end
end

local function PageThreeButtons()
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),64)
	button.Paint = function()
		draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
		draw.SimpleTextOutlined("Female", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
	function button:OnCursorEntered()
		surface.PlaySound("vo/npc/female01/question07.wav")
	end
	button.DoClick = function()
		currPage = 4
		gender = true
		myGender = "Female"
		menu:Close()
		timer.Simple(0.25, function()
			DrawMenu()
		end)
		surface.PlaySound("vo/npc/female01/readywhenyouare01.wav")
	end
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),128)
	button.Paint = function()
		draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
		draw.SimpleTextOutlined("Male", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
	function button:OnCursorEntered()
		surface.PlaySound("vo/npc/male01/answer32.wav")
	end
	button.DoClick = function()
		currPage = 4
		gender = false
		myGender = "Male"
		menu:Close()
		timer.Simple(0.25, function()
			DrawMenu()
		end)
		surface.PlaySound("vo/npc/male01/readywhenyouare01.wav")
	end
end

local function PageFourButtons()

	local avModels = {}	
	local spacer = 64
	
	if team_choice == 1 then
		local sexTitle = nil
		
		if myGender == "Male" then
			sexTitle = "male"
			avModels = {"1","2","3","4","5","6","7","8","9"}
		else
			sexTitle = "female"
			avModels = {"1","2","3","4","6","7"}
		end
		
		for k,v in pairs(avModels) do
			local button = vgui.Create("DButton", submenu2)
			button:SetSize(submenu2:GetWide()*0.75,32)
			button:SetText("")
			button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),spacer)
			button.Paint = function()
				if button:IsHovered() then
					modelview = "models/humans/group03/"..sexTitle.."_0"..v..".mdl"
				end
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
				draw.SimpleTextOutlined("Citizen Model #"..v, "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
				end
			function button:OnCursorEntered()
				surface.PlaySound("buttons/lightswitch2.wav")
			end
			button.DoClick = function()
				currPage = 5
				model = "models/player/group03/"..sexTitle.."_0"..v
				menu:Close()
				timer.Simple(0.25, function()
					DrawMenu()
				end)
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			spacer = spacer + 64
		end
	else
		local button = vgui.Create("DButton", submenu2)
		button:SetSize(submenu2:GetWide()*0.75,32)
		button:SetText("")
		button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),64)
		button.Paint = function()
			if button:IsHovered() then
				modelview = "models/combine_soldier.mdl"
			end
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Combine Soldier", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
			function button:OnCursorEntered()
				surface.PlaySound("buttons/lightswitch2.wav")
			end
		button.DoClick = function()
			currPage = 5
			model = "models/player/combine_soldier.mdl"
			menu:Close()
			timer.Simple(0.25, function()
				DrawMenu()
			end)
			surface.PlaySound("garrysmod/ui_click.wav")
		end
		local button = vgui.Create("DButton", submenu2)
		button:SetSize(submenu2:GetWide()*0.75,32)
		button:SetText("")
		button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),128)
		button.Paint = function()
			if button:IsHovered() then
				modelview = "models/combine_super_soldier.mdl"
			end
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Combine Elite", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
		function button:OnCursorEntered()
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		button.DoClick = function()
			currPage = 5
			model = "models/player/combine_super_soldier.mdl"
			menu:Close()
			timer.Simple(0.25, function()
				DrawMenu()
			end)
			surface.PlaySound("garrysmod/ui_click.wav")
		end
		local button = vgui.Create("DButton", submenu2)
		button:SetSize(submenu2:GetWide()*0.75,32)
		button:SetText("")
		button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),192)
		button.Paint = function()
			if button:IsHovered() then
				modelview = "models/police.mdl"
			end
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Metropolitan Police", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
		function button:OnCursorEntered()
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		button.DoClick = function()
			currPage = 5
			model = "models/player/police.mdl"
			menu:Close()
			timer.Simple(0.25, function()
				DrawMenu()
			end)
			surface.PlaySound("garrysmod/ui_click.wav")
		end
		local button = vgui.Create("DButton", submenu2)
		button:SetSize(submenu2:GetWide()*0.75,32)
		button:SetText("")
		button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),256)
		button.Paint = function()
			if button:IsHovered() then
				modelview = "models/combine_soldier_prisonguard.mdl"
			end
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined("Nova Prospekt", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
		function button:OnCursorEntered()
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		button.DoClick = function()
			currPage = 5
			model = "models/player/combine_soldier_prisonguard.mdl"
			menu:Close()
			timer.Simple(0.25, function()
				DrawMenu()
			end)
			surface.PlaySound("garrysmod/ui_click.wav")
		end
	end
end

local function PageFiveButtons()
	local statChoose = {"Strength", "Constitution", "Stamina", "Dexterity", "Intelligence", "Charisma"}	
	local spacer = 64
	for k,v in pairs(statChoose) do
		local button = vgui.Create("DButton", submenu2)
		button:SetSize(submenu2:GetWide()*0.75,32)
		button:SetText("")
		button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),spacer)
		button.Paint = function()
			if button:IsHovered() then
				stathovered = v
			end
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,120,120,255))
			draw.SimpleTextOutlined(v, "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
		function button:OnCursorEntered()
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		button.DoClick = function()
			currPage = 6
			statname = v
			menu:Close()
			timer.Simple(0.25, function()
				DrawMenu()
			end)
			surface.PlaySound("garrysmod/ui_click.wav")
		end
		spacer = spacer + 64
	end
end

local function PageSixButtons()
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),64)
	button.Paint = function()
		draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(120,255,120,255))
		draw.SimpleTextOutlined("ACCEPT", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	button.DoClick = function()
		menu:Close()
		surface.PlaySound("buttons/button14.wav")
		FinalSubmit()
	end
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()*0.75,32)
	button:SetText("")
	button:SetPos((submenu2:GetWide()/2)-(button:GetWide()/2),128)
	button.Paint = function()
		draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(255,120,120,255))
		draw.SimpleTextOutlined("START OVER", "ChatFont", button:GetWide()/2, button:GetTall()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
	button.DoClick = function()
		currPage 		= 1
		team_choice 	= 1
		gender			= false
		myGender		= nil
		model			= nil
		statboost		= nil
		statname		= nil
		team_name		= nil
		
		modelview		= "player/kleiner.mdl"
		
		menu:Close()
		timer.Simple(0.25, function()
			DrawMenu()
		end)
		surface.PlaySound("buttons/combine_button_locked.wav")
	end
end

local function TeamChoice()
	submenu1 = vgui.Create("DPanel", menu)
	submenu1:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu1:SetPos(128,196)
	submenu1.Paint = function()
		TeamDescription()
	end
	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu2:SetPos(ScrW()-(ScrW()*0.4)-128,196)
	submenu2.Paint = function()
	end
	PageTwoButtons()
end

local function GenderChoice()
	submenu1 = vgui.Create("DPanel", menu)
	submenu1:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu1:SetPos(128,196)
	submenu1.Paint = function()
		GenderDescription()
	end
	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu2:SetPos(ScrW()-(ScrW()*0.4)-128,196)
	submenu2.Paint = function()
	end
	PageThreeButtons()
end

local function ModelChoice()
	submenu1 = vgui.Create("DPanel", menu)
	submenu1:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu1:SetPos(128,196)
	local viewer = vgui.Create("DModelPanel", submenu1)
	viewer:SetSize(submenu1:GetWide(),submenu1:GetTall())
	viewer:SetAnimated(true)
	submenu1.Paint = function()
		viewer:SetModel(modelview)
	end
	
	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu2:SetPos(ScrW()-(ScrW()*0.4)-128,196)
	submenu2.Paint = function()
	end
	PageFourButtons()
end

local function StatsChoice()
	submenu1 = vgui.Create("DPanel", menu)
	submenu1:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu1:SetPos(128,196)
	submenu1.Paint = function()
		StatsDescription()
	end
	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu2:SetPos(ScrW()-(ScrW()*0.4)-128,196)
	submenu2.Paint = function()
	end
	PageFiveButtons()
end

local function LoadCharacter()

	local animation = "LineIdle02"
	
	if team_choice == 1 then
		team_name = "Rebellion Special Forces"
	elseif team_choice == 2 then
		team_name = "Combine Elite Squadron"
		animation = "Idle_Unarmed"
	end

	submenu1 = vgui.Create("DPanel", menu)
	submenu1:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu1:SetPos(128,196)
	
	local viewer = vgui.Create("DModelPanel", submenu1)
	viewer:SetSize(submenu1:GetWide(),submenu1:GetTall())
	viewer:SetPos(submenu1:GetWide()-(submenu1:GetWide()*0.75),0)
	viewer:SetAnimated(true)
	viewer:SetModel(modelview)
	local pose = viewer:GetEntity():LookupSequence(animation)
	viewer:GetEntity():SetSequence(pose)
	
	submenu1.Paint = function()
		Confirmation()
	end
	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu2:SetPos(ScrW()-(ScrW()*0.4)-128,196)
	submenu2.Paint = function()
	end
	PageSixButtons()
end
-- Page One
local function Welcome()
	submenu1 = vgui.Create("DPanel", menu)
	submenu1:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu1:SetPos(128,196)
	submenu1.Paint = function()
		Intro()
	end
	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize(ScrW()*.4,ScrH()*0.7)
	submenu2:SetPos(ScrW()-(ScrW()*0.4)-128,196)
	submenu2.Paint = function()
	end
	PageOneButtons()
end

-- Called to draw the menu each time
function DrawMenu()
	menu = vgui.Create("DFrame")
	menu:SetSize(ScrW(), ScrH())
	menu:ShowCloseButton(false)
	menu:SetDraggable(false)
	menu:SetDeleteOnClose(true)
	menu:SetTitle("")
	menu:Center()
	menu.Paint = function()
	
		-- General Background
		--draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(40,40,40,255))
		draw.RoundedBoxEx(24,4,4,ScrW()-8,132,Color(120,120,120,255),true,true,false,false)
		draw.RoundedBoxEx(24,6,6,ScrW()-12,128,Color(0,0,0,255),true,true,false,false)
		
		draw.SimpleTextOutlined("Catastrophe", "GameTitle", ScrW()/2, 64, Color(60, 140, 220, 255), 1, 1, 1, Color(120, 120, 120, 200))
		
		draw.SimpleTextOutlined("Character Initalization", "GameHeader1", ScrW()/2, 120, Color(255, 255, 255, 255), 1, 1, 1, Color(120, 120, 120, 200))
		draw.SimpleTextOutlined("Character Initalization", "GameHeader2", ScrW()/2, 120, Color(60, 140, 220, 255), 1, 1, 1, Color(120, 120, 120, 200))
		
		-- Info Panel Border (To be removed after everything is functional)
		draw.RoundedBox(4,126,194,(ScrW()*0.4)+4,(ScrH()*0.7)+4,Color(120,120,120,5))
		draw.RoundedBox(4,ScrW()-(ScrW()*0.4)-130,194,(ScrW()*0.4)+4,(ScrH()*0.7)+4,Color(120,120,120,5))
		
		-- Info Panel Background (To be removed after everything is functional)
		draw.RoundedBox(4,128,196,ScrW()*0.4,ScrH()*0.7,Color(20,20,20,40))
		draw.RoundedBox(4,ScrW()-(ScrW()*0.4)-128,196,ScrW()*0.4,ScrH()*0.7,Color(20,20,20,40))
		
		end
		
	print("[DEBUG] Welcome Screen Current Page: "..tostring(currPage))
	if 		currPage == 1 then Welcome()
	elseif 	currPage == 2 then TeamChoice()
	elseif 	currPage == 3 then GenderChoice()
	elseif 	currPage == 4 then ModelChoice()
	elseif 	currPage == 5 then StatsChoice()
	elseif 	currPage == 6 then LoadCharacter()
	else Welcome()
	end
	
	gui.EnableScreenClicker(true)
end

-- Identifies the player, displays basic server information
local function WelcomeScreen()
	if play_music then surface.PlaySound("music/catastrophe_intro.wav") end
	DrawMenu()
	
	if net.ReadInt(4) == 1 then 
		surface.PlaySound("buttons/button8.wav")
	end
	
end

net.Receive("MMO_CharCreate", WelcomeScreen)
net.Receive("MMO_CharDeny", DrawMenu)

-- Releasing all of our variables and freeing up memory
net.Receive("MMO_CharAccept", function()
    menu			= nil
    submenu1		= nil
    submenu2		= nil
	gui.EnableScreenClicker(false)
	
	timer.Simple(1, function()
		if LocalPlayer():Team() == 1 then
			local hev01 = CreateSound(LocalPlayer(), "hev/hev_logon.wav")
			local hev03 = CreateSound(LocalPlayer(), "hev/automedic_on.wav")
			local hev04 = CreateSound(LocalPlayer(), "hev/vitalsigns_on.wav")
			hev01:PlayEx(0.4, 100)
			timer.Simple(12, function() hev03:PlayEx(0.4, 100) end)
			timer.Simple(17, function() hev04:PlayEx(0.4, 100) end)
		else
			local radio01 = CreateSound(LocalPlayer(), "npc/overwatch/radiovoice/on1.wav")
			local radio02 = CreateSound(LocalPlayer(), "npc/overwatch/radiovoice/attention.wav")
			local radio03 = CreateSound(LocalPlayer(), "npc/overwatch/radiovoice/reportplease.wav")
			local radio04 = CreateSound(LocalPlayer(), "npc/overwatch/radiovoice/off2.wav")
			local radio05 = CreateSound(LocalPlayer(), "npc/metropolice/vo/on2.wav")
			local radio06 = CreateSound(LocalPlayer(), "npc/metropolice/vo/ten4.wav")
			local radio07 = CreateSound(LocalPlayer(), "npc/metropolice/vo/ten8standingby.wav")
			local radio08 = CreateSound(LocalPlayer(), "npc/metropolice/vo/off2.wav")
			radio01:PlayEx(0.4, 100)
			timer.Simple(0.75, function() radio02:PlayEx(0.4, 100) end)
			timer.Simple(2, function() radio03:PlayEx(0.4, 100) end)
			timer.Simple(3, function() radio04:PlayEx(0.4, 100) end)
			timer.Simple(5, function() radio05:PlayEx(0.4, 100) end)
			timer.Simple(5.75, function() radio06:PlayEx(0.4, 100) end)
			timer.Simple(7.5, function() radio07:PlayEx(0.4, 100) end)
			timer.Simple(9, function() radio08:PlayEx(0.4, 100) end)
		end
	end)
end)