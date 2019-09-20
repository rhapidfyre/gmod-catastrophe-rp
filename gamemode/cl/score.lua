local card	= nil
local playerlist = nil
local scrollpanel = nil

-- Display player's ping
function GetLatency(num)
	if num < 50 then 							return Color(0,		255,	0,		255)
	elseif num > 49  	and num < 100 then		return Color(80,	255,	0,		255)
	elseif num > 99 	and num < 251 then 		return Color(120,	255,	150,	255)
	elseif num > 250 	and num < 400 then 		return Color(255,	255,	120,	255)
	else										return Color(255,	120,	120,	255)
	end
end

-- Returns background color of given team (side)
function TeamBackground(side)
	if side == 1 then return Color(255,200,0,120)
	else return team.GetColor(side)
	end
end

-- Draws the Informative Panel at the top
function InfoPanel()
	local infopanel = vgui.Create("DPanel", card)
	infopanel:SetSize(card:GetWide(), card:GetTall() / 8)
	infopanel.Paint = function()
		draw.RoundedBox(24, 0, 0, card:GetWide(), card:GetTall(), Color(40,40,40,200))
		draw.SimpleTextOutlined("CATASTROPHE RPG", "ChatFont", 12, 6, Color(0,180,255), 0, 0, 1, Color(0,0,0))
		draw.SimpleTextOutlined("CATASTROPHE RPG", "ChatFont", 12, 6, Color(0,255,255), 0, 0, 1, Color(0,0,0))
	end
end

-- Each individual player's panel
function DrawPlayer(ply)
	
	-- Setup for if a player's name is too long
	local trail = ""
	local cap_name = ply:GetName()
	if string.len(cap_name) > 18 then trail = "..." end
	
	cap_name = string.upper(cap_name)
	cap_name = string.Left(cap_name, 18)
	
	-- Calculate ktd to use in a future version
	local ktd = ply:Frags() / ply:Deaths()
	if ply:Deaths() == 0 then
		ktd = 0
	end
	ktd = math.Round(ktd, 0)
	
	-- Draw the player panel
	playerpanel = vgui.Create("DPanel", playerlist)
	playerpanel:SetSize(playerlist:GetWide(),40)		
	playerpanel:SetPos(0,0)
	playerpanel.Paint = function()
			draw.RoundedBox(12,0,0,playerpanel:GetWide(),playerpanel:GetTall()*0.75,TeamBackground(ply:Team()))
		if ply == LocalPlayer() then
			local trig = math.abs(math.sin(CurTime()*4)*255)
			draw.SimpleTextOutlined(ply:Name(),"ChatFont",playerlist:GetWide() * 0.1,playerpanel:GetTall()/3,Color(trig,255,trig,255),0,1,1,Color(0,0,0))
		
		else
			draw.SimpleTextOutlined(ply:Name(),"ChatFont",playerlist:GetWide() * 0.1,playerpanel:GetTall()/3,Color(255,255,255),0,1,1,Color(0,0,0))
		
		end
		if ply:Team() ~= 4 then
			draw.SimpleTextOutlined(ply:GetNWInt("level"),"ChatFont",playerlist:GetWide()*0.65,playerpanel:GetTall()/3,Color(255,255,255),1,1,1,Color(0,0,0))
			draw.SimpleTextOutlined(ply:Ping(),"ChatFont",playerlist:GetWide() - 12,playerpanel:GetTall()/3,GetLatency(ply:Ping()),2,1,1,Color(0,0,0))
		end
	end
end

-- Draws the playerlist
function DrawPanels()
	
	-- Create player table and sort it by team then points
	local player_table = player.GetAll()
	table.sort( player_table, function(a,b)
		local a_score = a:GetNWInt("level")
		local b_score = b:GetNWInt("level")
		if a_score == nil then a_score = 0 end
		if b_score == nil then b_score = 0 end
		return (a_score > b_score)
	end)
	
	-- Create the title panel first then create the players
	local playerpanel = vgui.Create("DPanel", playerlist)
	playerpanel:SetSize(playerlist:GetWide(),40)		
	playerpanel:SetPos(0,0)
	playerpanel.Paint = function()
		draw.SimpleTextOutlined("Name","ChatFont",playerlist:GetWide() * 0.1,playerpanel:GetTall()/3,Color(255,255,255),TEXT_ALIGN_LEFT,1,1,Color(0,0,0))
		draw.SimpleTextOutlined("Level","ChatFont",playerlist:GetWide()*0.65,playerpanel:GetTall()/3,Color(255,255,255),TEXT_ALIGN_CENTER,1,1,Color(0,0,0))
		draw.SimpleTextOutlined("Ping","ChatFont",playerlist:GetWide() - 6,playerpanel:GetTall()/3,Color(255,255,255),TEXT_ALIGN_RIGHT,1,1,Color(0,0,0))
	end
	
	-- Create each individual panel based on the sorted tables
	for _,ply in pairs(player_table) do DrawPlayer(ply) end
end

-- Draws the complete scoreboard to house all teams
function CreateBoard()
	card = vgui.Create("DFrame")
	card:SetSize(256, ScrH()*0.8)
	card:SetPos(ScrW()-384, 0)
	card:SetTitle("")
	card:SetDraggable(false)
	card:ShowCloseButton(false)
	card:CenterVertical()
	card.Paint = function()
		surface.SetDrawColor(180,180,180)
		surface.DrawOutlinedRect(1,24, card:GetWide()-2, card:GetTall()-25)
		draw.RoundedBoxEx(12, 1, 1, card:GetWide()-2, card:GetTall()-2, Color(40,40,40,120),true,true,false,false)
		draw.RoundedBoxEx(12, 0, 0, card:GetWide(), card:GetTall() * 0.125, Color(40,40,40,255),true,true,false,false)
	end
	
	-- Creates the scrolling panel so you can scroll down if the scoreboard gets too large
	scrollpanel = vgui.Create("DScrollPanel", card)
	scrollpanel:SetSize(card:GetWide() * 0.85, card:GetTall() * 0.875)
	scrollpanel:SetPos(card:GetWide()/2 - (card:GetWide() * 0.85)/2,card:GetTall() - card:GetTall() * 0.875)
	
	-- Creates a list to hold each player panel
	playerlist = vgui.Create("DListLayout", scrollpanel)
	playerlist:SetSize(scrollpanel:GetWide(), scrollpanel:GetTall())
	playerlist:SetPos(0,0)
	
end

function GM:ScoreboardShow()
	if !IsValid(card) then
		CreateBoard()	-- Draw the board
	end
	
	if IsValid(card) then
	
		playerlist:Clear()	-- Clear it each time to get the most accurate sort
		
		InfoPanel()
		DrawPanels()
		
		card:Show()
		card:MakePopup()
		card:SetKeyboardInputEnabled(false)
		card:SetMouseInputEnabled(false)
		
	end
end

function GM:ScoreboardHide()
	if IsValid(card) then
		card:Hide()
	end
end