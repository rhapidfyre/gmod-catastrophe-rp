
local CMenu 	  = nil
local scrollpanel = nil
local buttonlist  = nil
local statPoints  = 0
local stats_table = {
	["str"] = 0,
	["con"] = 0,
	["sta"] = 0,
	["dex"] = 0,
	["int"] = 0,
	["cha"] = 0,
	["dem"] = 0,
	["eng"] = 0,
	["bre"] = 0,
	["bak"] = 0,
	["gun"] = 0,
	["res"] = 0,
	["exp"] = 0,
	["sca"] = 0,
	["nxt"] = 0,
	["lvl"] = 0,
	["end"] = 0,
	["hun"] = 0,
	["thr"] = 0,
	["hp"] = 0,
	["mxh"] = 0
}

local function UpdateStats()
	stats_table["str"] = LocalPlayer():GetStrength()
	stats_table["con"] = LocalPlayer():GetConstitution()
	stats_table["sta"] = LocalPlayer():GetStamina()
	stats_table["dex"] = LocalPlayer():GetDexterity()
	stats_table["int"] = LocalPlayer():GetIntelligence()
	stats_table["cha"] = LocalPlayer():GetCharisma()
	stats_table["dem"] = LocalPlayer():GetDemolitions()
	stats_table["eng"] = LocalPlayer():GetEngineering()
	stats_table["gun"] = LocalPlayer():GetGunsmithing()
	stats_table["res"] = LocalPlayer():GetResearching()
	stats_table["bre"] = LocalPlayer():GetBrewing()
	stats_table["bak"] = LocalPlayer():GetBaking()
	stats_table["sca"] = LocalPlayer():GetScavenging()
	stats_table["exp"] = LocalPlayer():GetExperience()
	stats_table["nxt"] = LocalPlayer():GetNextLevel()
	stats_table["lvl"] = LocalPlayer():GetLevel()
	stats_table["end"] = LocalPlayer():GetEndurance()
	stats_table["hun"] = LocalPlayer():GetHunger()
	stats_table["thr"] = LocalPlayer():GetThirst()
	stats_table["hp"] = LocalPlayer():Health()
	stats_table["mxh"] = LocalPlayer():GetMaxHealth()
end

-- Healthbar Size (x = max size, y = current exp, z = next level)
local function GetSize(x)
	return (x * stats_table["exp"] / stats_table["nxt"])
end

local function PlayerInfoPanel()
	local myTeam = LocalPlayer():Team()
	
	if myTeam == 1 then myTeam = "Rebel"
	else myTeam = "Combine"
	end

	local player_info = vgui.Create("DPanel", CMenu)
	player_info:SetSize(CMenu:GetWide(),64)
	player_info:SetPos(0,0)
	player_info.Paint = function()
		draw.SimpleTextOutlined(LocalPlayer():Name(), "DermaLarge", player_info:GetWide()/2, player_info:GetTall()/2 - 8, Color(80,204,102,255), 1, 1, 1, Color(0,0,0))
		draw.SimpleText("Level", "Trebuchet24", player_info:GetWide()/2 - 24, player_info:GetTall()/2 + 20, Color(200,200,200,255), TEXT_ALIGN_RIGHT, 1)
		draw.SimpleText(stats_table["lvl"], "Trebuchet24", player_info:GetWide()/2, player_info:GetTall()/2 + 20, Color(255,200,0,255), TEXT_ALIGN_CENTER, 1)
		draw.SimpleText(myTeam, "Trebuchet24", player_info:GetWide()/2 + 24, player_info:GetTall()/2 + 20, Color(200,200,200,255), TEXT_ALIGN_LEFT, 1)
	end
end

local function PlayerStats()
	local spread = 32
	local player_stats = vgui.Create("DPanel", CMenu)
	player_stats:SetSize(CMenu:GetWide()-24,CMenu:GetTall()-108)
	player_stats:SetPos(12,128)
	player_stats.Paint = function()
		--draw.RoundedBox(0,0,0,player_stats:GetWide(),player_stats:GetTall(),Color(0,0,0,255))
		draw.SimpleText("Strength",		"ChatFont", 	spread, 6, 		Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 6)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Craft Time & Melee Damage", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Constitution",	"ChatFont", 	spread, 32, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 32)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Modifies Maximum Hitpoints", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Stamina",		"ChatFont", 	spread, 58, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 58)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Affects HP Regen", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Dexterity",	"ChatFont", 	spread, 84, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 84)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Movement Speed & Gun Dmg", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Intelligence",	"ChatFont", 	spread, 110, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 110)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Crafting Success & Skill-ups", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Charisma",		"ChatFont", 	spread, 136, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 136)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Prices & Loot Chances", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		
		draw.SimpleText(stats_table["str"],	"ChatFont", 	player_stats:GetWide()-spread, 6, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["con"],	"ChatFont", 	player_stats:GetWide()-spread, 32, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["sta"],	"ChatFont", 	player_stats:GetWide()-spread, 58, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["dex"],	"ChatFont", 	player_stats:GetWide()-spread, 84, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["int"],	"ChatFont", 	player_stats:GetWide()-spread, 110, Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["cha"],	"ChatFont", 	player_stats:GetWide()-spread, 136, Color(0,255,255), 2, 0)
		
		draw.SimpleText("Demolitions",	"ChatFont", 	spread, 188, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 188)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Create Explosives & C4", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Engineering",	"ChatFont", 	spread, 214, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 214)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Create Vehicles & Turrets", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Gunsmithing",	"ChatFont", 	spread, 240, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 240)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Create Weapons & Ammo", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Researching",	"ChatFont", 	spread, 266, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 266)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Create Medical Supplies", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Brewing",	"ChatFont", 	spread, 292, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 292)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Create Drinks", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Baking",	"ChatFont", 	spread, 318, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 318)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Create Food", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		draw.SimpleText("Scavenging",	"ChatFont", 	spread, 344, 	Color(255,255,255))
			local trig = math.abs(math.tan(CurTime()*2)*255)
			local hintpanel = vgui.Create("DPanel", player_stats)
			hintpanel:SetSize(212,18)
			hintpanel:SetPos(30, 344)
			hintpanel.Paint = function()
					if hintpanel:IsHovered() then
						draw.RoundedBox(0,0,0,hintpanel:GetWide(),hintpanel:GetTall(),Color(80,80,80,trig))
						draw.SimpleText("Find Loot & Junk Items", "HudHintTextLarge", hintpanel:GetWide()/2, 2, Color(255,255,255,trig), 1, 0)
					end
				end
		
		draw.SimpleText(stats_table["dem"],	"ChatFont", 	player_stats:GetWide()-spread, 188, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["eng"],	"ChatFont", 	player_stats:GetWide()-spread, 214, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["gun"],	"ChatFont", 	player_stats:GetWide()-spread, 240, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["res"],	"ChatFont", 	player_stats:GetWide()-spread, 266, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["bre"],	"ChatFont", 	player_stats:GetWide()-spread, 292, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["bak"],	"ChatFont", 	player_stats:GetWide()-spread, 318, 	Color(0,255,255), 2, 0)
		draw.SimpleText(stats_table["sca"],	"ChatFont", 	player_stats:GetWide()-spread, 344, 	Color(0,255,255), 2, 0)
		

	end

end

local function ExperienceBar()
	local exp_bar = vgui.Create("DPanel", CMenu)
	exp_bar:SetSize(256,40)
	exp_bar:SetPos((CMenu:GetWide()/2)-(exp_bar:GetWide()/2),72)
	exp_bar.Paint = function()
		draw.RoundedBoxEx(12,0,0,exp_bar:GetWide(),exp_bar:GetTall(),Color(40,40,40,255),true,true,false,false)
		draw.RoundedBoxEx(12,1,1,exp_bar:GetWide()-2,exp_bar:GetTall()-2,Color(120,120,120,255),true,true,false,false)
		draw.RoundedBox(0,2,18,exp_bar:GetWide()-4,exp_bar:GetTall()-20,Color(200,200,200,255))   -- Brighter Backdrop
		draw.RoundedBox(0,12,21,exp_bar:GetWide()-24,exp_bar:GetTall()-24,Color(40,40,40,255)) -- Black Bar
		
		
		draw.RoundedBox(0,13,22,GetSize(230),exp_bar:GetTall()-26,Color(255,180,0,255))
		
		surface.SetDrawColor(255,255,255,255)
		surface.DrawLine(exp_bar:GetWide()*0.2,exp_bar:GetTall()-3,exp_bar:GetWide()*0.2 - 1,exp_bar:GetTall()-8)
		surface.DrawLine(exp_bar:GetWide()*0.4,exp_bar:GetTall()-3,exp_bar:GetWide()*0.4 - 1,exp_bar:GetTall()-8)
		surface.DrawLine(exp_bar:GetWide()*0.6,exp_bar:GetTall()-3,exp_bar:GetWide()*0.6 - 1,exp_bar:GetTall()-8)
		surface.DrawLine(exp_bar:GetWide()*0.8,exp_bar:GetTall()-3,exp_bar:GetWide()*0.8 - 1,exp_bar:GetTall()-8)
		
		draw.SimpleText("EXPERIENCE","TargetID",exp_bar:GetWide()/2,10,Color(255,255,255),1,1)
		draw.SimpleText(math.Round(stats_table["exp"],0).."/"..math.Round(stats_table["nxt"],0),"TargetIDSmall",exp_bar:GetWide()/2,28,Color(255,255,255),1,1)
	end
end

local function UpgradeButtons()
	if LocalPlayer():GetStatPoints() > 0 then
	local upBtn = vgui.Create("DButton", CMenu)
	upBtn:SetSize(24,24)
	upBtn:SetPos(CMenu:GetWide()-42, 130)
	upBtn:SetText("")
	upBtn.DoClick = function()
		net.Start("MMO_RaiseStat")
			net.WriteString("str")
			net.SendToServer()
		timer.Simple(0.25, function() UpdateStats() end)
		end
	upBtn.Paint = function()
			if upBtn:IsHovered() then
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(255,255,255),1,1)
			else
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(0,255,0), 1,1)
			end
		end
	local upBtn = vgui.Create("DButton", CMenu)
	upBtn:SetSize(24,24)
	upBtn:SetPos(CMenu:GetWide()-42, 156)
	upBtn:SetText("")
	upBtn.DoClick = function()
		net.Start("MMO_RaiseStat")
			net.WriteString("con")
			net.SendToServer()
		timer.Simple(0.25, function() UpdateStats() end)
		end
	upBtn.Paint = function()
			if upBtn:IsHovered() then
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(255,255,255),1,1)
			else
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(0,255,0), 1,1)
			end
		end
	local upBtn = vgui.Create("DButton", CMenu)
	upBtn:SetSize(24,24)
	upBtn:SetPos(CMenu:GetWide()-42, 182)
	upBtn:SetText("")
	upBtn.DoClick = function()
		net.Start("MMO_RaiseStat")
			net.WriteString("sta")
			net.SendToServer()
		timer.Simple(0.25, function() UpdateStats() end)
		end
	upBtn.Paint = function()
			if upBtn:IsHovered() then
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(255,255,255),1,1)
			else
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(0,255,0), 1,1)
			end
		end
	local upBtn = vgui.Create("DButton", CMenu)
	upBtn:SetSize(24,24)
	upBtn:SetPos(CMenu:GetWide()-42, 208)
	upBtn:SetText("")
	upBtn.DoClick = function()
		net.Start("MMO_RaiseStat")
			net.WriteString("dex")
			net.SendToServer()
		timer.Simple(0.25, function() UpdateStats() end)
		end
	upBtn.Paint = function()
			if upBtn:IsHovered() then
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(255,255,255),1,1)
			else
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(0,255,0), 1,1)
			end
		end
	local upBtn = vgui.Create("DButton", CMenu)
	upBtn:SetSize(24,24)
	upBtn:SetPos(CMenu:GetWide()-42, 234)
	upBtn:SetText("")
	upBtn.DoClick = function()
		net.Start("MMO_RaiseStat")
			net.WriteString("int")
			net.SendToServer()
		timer.Simple(0.25, function() UpdateStats() end)
		end
	upBtn.Paint = function()
			if upBtn:IsHovered() then
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(255,255,255),1,1)
			else
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(0,255,0), 1,1)
			end
		end
	local upBtn = vgui.Create("DButton", CMenu)
	upBtn:SetSize(24,24)
	upBtn:SetPos(CMenu:GetWide()-42, 260)
	upBtn:SetText("")
	upBtn.DoClick = function()
		net.Start("MMO_RaiseStat")
			net.WriteString("cha")
			net.SendToServer()
		timer.Simple(0.25, function() UpdateStats() end)
		end
	upBtn.Paint = function()
			if upBtn:IsHovered() then
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(255,255,255),1,1)
			else
				draw.SimpleText("+", "HUDText0", upBtn:GetWide()/2,upBtn:GetTall()/2, Color(0,255,0), 1,1)
			end
		end
	end
end

local function Statistics()
	local displaybox = vgui.Create("DPanel", CMenu)
	displaybox:SetSize(CMenu:GetWide()*0.8, CMenu:GetTall()*0.275)
	displaybox:SetPos(CMenu:GetWide()*0.1, CMenu:GetTall()*0.8)
	local healthy = math.Round((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 100, 2)
	if healthy > 100 then healthy = 100 end
	displaybox.Paint = function()
		draw.SimpleText("Health: ", "TargetIDSmall", (displaybox:GetWide()/2)-32, 12, Color(255,255,255),TEXT_ALIGN_RIGHT,1)
		draw.SimpleText("   "..healthy.."%", "TargetIDSmall", (displaybox:GetWide()/2)-8, 12, Color(180,255,180),TEXT_ALIGN_CENTER,1)
		draw.SimpleText(stats_table["hp"].."/"..stats_table["mxh"], "TargetIDSmall", (displaybox:GetWide()/2)+32, 12, Color(180,180,180),TEXT_ALIGN_LEFT,1)
		
		draw.SimpleText("Endurance: ", "TargetIDSmall", (displaybox:GetWide()/2)-32, 42, Color(255,255,255),TEXT_ALIGN_RIGHT,1)
		draw.SimpleText("   100%", "TargetIDSmall", (displaybox:GetWide()/2)-8, 42, Color(255,255,180),TEXT_ALIGN_CENTER,1)
		draw.SimpleText(stats_table["end"].."/100", "TargetIDSmall", (displaybox:GetWide()/2)+32, 42, Color(180,180,180),TEXT_ALIGN_LEFT,1)
		
		draw.SimpleText("Hunger: ", "TargetIDSmall", (displaybox:GetWide()/2)-32, 72, Color(255,255,255),TEXT_ALIGN_RIGHT,1)
		draw.SimpleText("   100%", "TargetIDSmall", (displaybox:GetWide()/2)-8, 72, Color(255,180,180),TEXT_ALIGN_CENTER,1)
		draw.SimpleText(stats_table["hun"].."/1000", "TargetIDSmall", (displaybox:GetWide()/2)+32, 72, Color(180,180,180),TEXT_ALIGN_LEFT,1)
		
		draw.SimpleText("Thirst: ", "TargetIDSmall", (displaybox:GetWide()/2)-32, 102, Color(255,255,255),TEXT_ALIGN_RIGHT,1)
		draw.SimpleText("   100%", "TargetIDSmall", (displaybox:GetWide()/2)-8, 102, Color(180,180,255),TEXT_ALIGN_CENTER,1)
		draw.SimpleText(stats_table["thr"].."/1000", "TargetIDSmall", (displaybox:GetWide()/2)+32, 102, Color(180,180,180),TEXT_ALIGN_LEFT,1)
		
	end
end

function GM:ContextMenuOpen()

end

function GM:OnContextMenuOpen()

	local myself = LocalPlayer()
	local height = 640--ScrH()*0.75
	local width = 296--ScrW() * 0.2
	
	local my_team = LocalPlayer():Team()
		
	if !IsValid(CMenu) then
		CMenu = vgui.Create("DFrame")
		CMenu:SetSize(width,height)
		CMenu:SizeToContents(true)
		CMenu:SetPos(12,ScrH()/2 - (height)/2)
		CMenu:SetTitle("")
		CMenu:SetDraggable(false)
		CMenu:ShowCloseButton(false)
		CMenu:SetDeleteOnClose(true)
		CMenu.Paint = function()
			--surface.SetDrawColor(200,200,200,200)
			--surface.DrawOutlinedRect(0,0,CMenu:GetWide(),CMenu:GetTall())
			--exp_bar:SetSize(256,40)
			--exp_bar:SetPos((CMenu:GetWide()/2)-(exp_bar:GetWide()/2),72)
			draw.RoundedBox(12,(CMenu:GetWide()/2)-(238/2),72,238,CMenu:GetTall()-72,Color(0,0,0,255))
			draw.RoundedBox(12,(CMenu:GetWide()/2)-(234/2),73,234,CMenu:GetTall()-74,Color(125,125,125,255))
			--draw.RoundedBox(0,0,0,CMenu:GetWide(),CMenu:GetTall(),Color(60,60,60,140),false,true,false,true)
			draw.SimpleText("[Hover stats for details]",		"DebugFixed", 	CMenu:GetWide()/2, 116, 		Color(255,255,255), 1, 0)
			end
		
		scrollpanel = vgui.Create("DScrollPanel", CMenu)
		scrollpanel:SetSize(CMenu:GetWide(), CMenu:GetTall())
		scrollpanel:SetPos(0,12)
		
		buttonlist = vgui.Create("DListLayout", scrollpanel)
		buttonlist:SetSize(scrollpanel:GetWide()/2, scrollpanel:GetTall())
		buttonlist:SetPos(0,0)
		
	end
	if IsValid(CMenu) then
	
		buttonlist:Clear()
		
		UpdateStats()
		PlayerInfoPanel()
		PlayerStats()
		ExperienceBar()
		UpgradeButtons()
		Statistics()
	
		CMenu:Show()
		CMenu:MakePopup()
		surface.PlaySound("garrysmod/content_downloaded.wav")
		
	end
	
end

function GM:OnContextMenuClose()

	if IsValid(CMenu) then
		CMenu:Remove()
		surface.PlaySound("garrysmod/ui_return.wav")
	end
	
end

net.Receive("MMO_UDStat", function()
    statPoints = LocalPlayer():GetStatPoints()
end)