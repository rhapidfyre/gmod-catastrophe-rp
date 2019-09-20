
-- Gunsmithing Menu Drawing (Keep productivity Server-side)

-- Handles object selection for menus (tradeskilling, merchants)
local last_combine = CurTime()
local menu 		= nil
local submenu1  = nil
local submenu2  = nil
local submenu3  = nil
local menu_type = nil
local selection = nil
local sel_type  = nil
local countdown = nil
local invstring = {}


local function DoCombination()
	if sel_type == "recipe" and selection ~= nil then
		net.Start("MMO_DoCombination")
			net.WriteTable(selection)
			net.WriteString(menu_type)
			net.SendToServer()
	end
end

local function RefreshWindow()
	menu:Close()
	menu = nil
	timer.Simple(0.1, function() InteractiveMenu() end)
end

local function DrawButtons()
	local selbutton = vgui.Create("DButton", submenu3)
	selbutton:SetSize(196,24)
	selbutton:SetText("")
	selbutton:SetPos(submenu3:GetWide()/2 - selbutton:GetWide()/2, submenu3:GetTall()-64)
	selbutton.Paint = function()
		if sel_type == "recipe" and (last_combine + 2 < CurTime()) then
			if selbutton:IsHovered() then
				draw.RoundedBox(4,0,0,selbutton:GetWide(),selbutton:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,selbutton:GetWide()-4,selbutton:GetTall()-4,Color(125,225,125))
				draw.SimpleText("CRAFT", "ChatFont", selbutton:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,selbutton:GetWide(),selbutton:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,selbutton:GetWide()-4,selbutton:GetTall()-4,Color(80,120,80))
				draw.SimpleText("CRAFT", "ChatFont", selbutton:GetWide()/2, 2, Color(120,180,120), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,selbutton:GetWide(),selbutton:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,selbutton:GetWide()-4,selbutton:GetTall()-4,Color(120,120,120))
			draw.SimpleText("CRAFT", "ChatFont", selbutton:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	selbutton.DoClick = function()
		if last_combine + 2 < CurTime() then
			last_combine = CurTime()
			surface.PlaySound("garrysmod/ui_click.wav")
			DoCombination()
		end
	end
	function selbutton:OnCursorEntered()
		if sel_type == "recipe" and (last_combine + 2 < CurTime()) then
			surface.PlaySound("buttons/lightswitch2.wav")
		end
	end
	local button = vgui.Create("DButton", submenu3)
	button:SetSize(196,24)
	button:SetText("")
	button:SetPos(submenu3:GetWide()/2 - button:GetWide()/2, submenu3:GetTall()-32)
	button.Paint = function()
		if button:IsHovered() then
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(125,125,125))
			draw.SimpleText("CLOSE", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,80,80))
			draw.SimpleText("CLOSE", "ChatFont", button:GetWide()/2, 2, Color(180,180,180), TEXT_ALIGN_CENTER)
		end
	end
	button.DoClick = function()
		menu:Close()
		gui.EnableScreenClicker(false)
		menu = nil
	end
	function button:OnCursorEntered()
		surface.PlaySound("buttons/lightswitch2.wav")
	end
end

local function DrawMenus()
	local title = vgui.Create("DPanel", menu)
	title:SetSize(1016, 64)
	title:SetPos(0,0)
	title.Paint = function()
		if menu_type == "Gunsmithing" then
			draw.SimpleTextOutlined("Gunsmithing - "..LocalPlayer():GetGunsmithing(), "MenuTitle", title:GetWide()/2, title:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
		elseif menu_type == "Demolitions" then
			draw.SimpleTextOutlined("Demolitions - "..LocalPlayer():GetDemolitions(), "MenuTitle", title:GetWide()/2, title:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
		elseif menu_type == "Researching" then
			draw.SimpleTextOutlined("Researching - "..LocalPlayer():GetResearching(), "MenuTitle", title:GetWide()/2, title:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
		elseif menu_type == "Engineering" then
			draw.SimpleTextOutlined("Engineering - "..LocalPlayer():GetEngineering(), "MenuTitle", title:GetWide()/2, title:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
		elseif menu_type == "Baking" then
			draw.SimpleTextOutlined("Baking - "..LocalPlayer():GetEngineering(), "MenuTitle", title:GetWide()/2, title:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
		elseif menu_type == "Brewing" then
			draw.SimpleTextOutlined("Brewing - "..LocalPlayer():GetEngineering(), "MenuTitle", title:GetWide()/2, title:GetTall()/2, Color(255,255,255), 1, 1, 1, Color(0,0,0))
		end
	end
	
	submenu1 = vgui.Create("DScrollPanel", menu)
	submenu1:SetSize(416, 670)
	submenu1:SetPos(4, 94)
	submenu1.Paint = function()
		draw.RoundedBoxEx(0, 0, 0, submenu1:GetWide(), submenu1:GetTall(), Color(40,40,40,255),false,false,true,false)
	end
	
	submenu2 = vgui.Create("DScrollPanel", menu)
	submenu2:SetSize(320, 670)
	submenu2:SetPos(424, 94)
	submenu2.Paint = function()
		draw.RoundedBoxEx(0, 0, 0, submenu2:GetWide(), submenu2:GetTall(), Color(40,40,40,255),false,false,true,false)
	end
	
	submenu3 = vgui.Create("DPanel", menu)
	submenu3:SetSize(272, 670)
	submenu3:SetPos(748, 94)
	submenu3.Paint = function()
		local count
		local amount
		if sel_type == "inv" then
			count = "COUNT"
			amount = "WEIGHT"
		else
			count = "TRIVIAL"
			amount = "CREATES"		
		end
		draw.RoundedBoxEx(8, 0, 0, submenu3:GetWide(), submenu3:GetTall(), Color(40,40,40,255),false,false,false,true)
		draw.RoundedBoxEx(8, 2, 2, submenu3:GetWide()-4, submenu3:GetTall()-4, Color(108,108,108,255),false,false,false,true)
		draw.SimpleText("SELECTION NAME", "Trebuchet24", submenu3:GetWide()/2, 24, Color(180,180,180), TEXT_ALIGN_CENTER)
		draw.RoundedBox(8, 8, 48, 256, 24, Color(0,0,0))
		draw.SimpleText("DESCRIPTION", "Trebuchet24", submenu3:GetWide()/2, 88, Color(180,180,180), TEXT_ALIGN_CENTER)
		draw.RoundedBox(8, 8, 112, 256, 24, Color(0,0,0))
		draw.SimpleText(count, "Trebuchet24", submenu3:GetWide()/2, 152, Color(180,180,180), TEXT_ALIGN_CENTER)
		draw.RoundedBox(8, 8, 176, 256, 24, Color(0,0,0))
		draw.SimpleText(amount, "Trebuchet24", submenu3:GetWide()/2, 218, Color(180,180,180), TEXT_ALIGN_CENTER)
		draw.RoundedBox(8, 8, 240, 256, 24, Color(0,0,0))
		draw.SimpleText("REQUIRES", "Trebuchet24", submenu3:GetWide()/2, 282, Color(180,180,180), TEXT_ALIGN_CENTER)
		draw.RoundedBox(8, 8, 304, 256, 128, Color(0,0,0))
		
		if selection ~= nil then
			draw.SimpleText(selection["name"], "BudgetLabel", submenu3:GetWide()/2, 52, Color(0,255,0), TEXT_ALIGN_CENTER)
			draw.SimpleText(selection["desc"], "BudgetLabel", submenu3:GetWide()/2, 116, Color(0,255,0), TEXT_ALIGN_CENTER)
			
			if sel_type == "inv" then
				draw.SimpleText(selection["amount"], "BudgetLabel", submenu3:GetWide()/2, 180, Color(0,255,0), TEXT_ALIGN_CENTER)
				draw.SimpleText(selection["weight"], "BudgetLabel", submenu3:GetWide()/2, 244, Color(0,255,0), TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(selection["amount"], "BudgetLabel", submenu3:GetWide()/2, 244, Color(255,255,0), TEXT_ALIGN_CENTER)
				draw.SimpleText(selection["trivial"], "BudgetLabel", submenu3:GetWide()/2, 180, Color(255,255,0), TEXT_ALIGN_CENTER)
			local spacer = 304
			for k,v in pairs(selection["recipe"]) do
				local hasitem = false
				for a,b in pairs(inventory) do
					if inventory[a]["name"] == k and inventory[a]["amount"] >= v then
						hasitem = true
					end
				end
				if hasitem then draw.SimpleText(v.." "..k, "BudgetLabel", submenu3:GetWide()/2, spacer, Color(80,255,80), TEXT_ALIGN_CENTER)
				else draw.SimpleText(v.." "..k, "BudgetLabel", submenu3:GetWide()/2, spacer, Color(255,80,80), TEXT_ALIGN_CENTER)
				end
				spacer = spacer + 12
			end
			end
		
		end
	end
	
	local recipeTable
	if menu_type == "Gunsmithing" then recipeTable = recipes_gunsmithing
	elseif menu_type == "Demolitions" then recipeTable = recipes_demolitions
	elseif menu_type == "Researching" then recipeTable = recipes_researching
	elseif menu_type == "Engineering" then recipeTable = recipes_engineering
	end
	print(item_pistol)
	local x = 4
	local y = 4
	for k,v in pairs(recipeTable) do
	
		local btnback = vgui.Create("DPanel", submenu1)
		btnback:SetSize(96, 96)
		btnback:SetPos(x, y)
		btnback.Paint = function()
			draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(120,120,120))
			draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(25,25,25))
		end
	
		local modelview = vgui.Create("DModelPanel", submenu1)
		modelview:SetSize(96,96)
		modelview:SetPos(x, y)
		modelview:SetModel(recipeTable[k]["model"])
		modelview:SetCamPos(Vector(64,64,64))
		modelview:SetLookAt(Vector(0,0,0))
		function modelview:LayoutEntity(Entity) return end
		modelview:SetFOV(20)
	
		local button = vgui.Create("DButton", submenu1)
		button:SetSize(96,96)
		button:SetPos(x, y)
		button:SetText("")
		button.Paint = function()
			draw.SimpleTextOutlined(recipeTable[k]["amount"], "Trebuchet24", btnback:GetWide()-6, 14, Color(80,80,180), TEXT_ALIGN_RIGHT, 1, 1, Color(0,0,0))
			if button:IsHovered() then
				draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(120,120,120,20))
			end
		end
		button.DoClick = function()
			selection = recipeTable[k]
			sel_type = "recipe"
			surface.PlaySound("garrysmod/ui_click.wav")
		end
		function button:OnCursorEntered()
		end
		x = x + 100
		if x >= (submenu1:GetWide() - 96) then
			x = 4
			y = y + 100
		end
	end
	local x = 4
	local y = 4
	for k,v in pairs(inventory) do
		if inventory[k]["amount"] > 0 then
		local btnback = vgui.Create("DPanel", submenu2)
		btnback:SetSize(96, 96)
		btnback:SetPos(x, y)
		btnback.Paint = function()
			if selection ~= nil and sel_type == "recipe" then
			
				local key_found = false
				for key,v in pairs(selection["recipe"]) do
					if key == inventory[k]["name"] then
						key_found = true
					end
				end
				
				if key_found then
					draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(120,255,120))
				else
					draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(255,120,120))
				end
			else
				draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(120,120,120))
			end
			draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(25,25,25))
		end
	
		local modelview = vgui.Create("DModelPanel", submenu2)
		modelview:SetSize(96,96)
		modelview:SetPos(x, y)
		modelview:SetModel(inventory[k]["model"])
		modelview:SetCamPos(Vector(64,64,64))
		modelview:SetLookAt(Vector(0,0,0))
		function modelview:LayoutEntity(Entity) return end
		modelview:SetFOV(20)
	
		local button = vgui.Create("DButton", submenu2)
		button:SetSize(96,96)
		button:SetPos(x, y)
		button:SetText("")
		button.Paint = function()
			draw.SimpleTextOutlined(inventory[k]["amount"], "Trebuchet24", btnback:GetWide()-6, 14, Color(80,80,180), TEXT_ALIGN_RIGHT, 1, 1, Color(0,0,0))
			if button:IsHovered() then
				draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(120,120,120,20))
			end
		end
		button.DoClick = function()
			selection = inventory[k]
			sel_type = "inv"
			surface.PlaySound("garrysmod/ui_click.wav")
		end
		x = x + 100
		if x >= (submenu2:GetWide() - 96) then
			x = 4
			y = y + 100
		end
		end
	end
	
	DrawButtons()
	
end

function InteractiveMenu(menu_type)
	if (menu == nil) then
		menu = vgui.Create("DFrame")
		menu:SetSize(1024,768)
		menu:Center()
		menu:SetVisible(true)
		menu:ShowCloseButton(false)
		menu:SetDeleteOnClose(false)
		menu:SetDraggable(false)
		menu:SetTitle("Press (E) again to close.")
		menu.Paint = function()
			draw.RoundedBox(8, 0, 0, menu:GetWide(), menu:GetTall(), Color(40,40,40,200))
			draw.RoundedBox(8, 2, 2, menu:GetWide()-4, menu:GetTall()-4, Color(120,120,120,120))
			draw.RoundedBoxEx(8, 4, 4, menu:GetWide()-8, 64, Color(40,40,40,120),true,true,false,false)
			draw.SimpleTextOutlined("Recipe List", "ChatFont", 210, 80, Color(200,200,200), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0))
			draw.SimpleTextOutlined("Inventory", "ChatFont", 584, 80, Color(200,200,200), TEXT_ALIGN_CENTER, 1, 1, Color(0,0,0))
			end
		menu.OnClose = function()
			menu:SetVisible(false)
			gui.EnableScreenClicker(false)
			end

		DrawMenus()
		
		gui.EnableScreenClicker(true)
		
	else
	
		if (menu:IsVisible()) then
			menu:SetVisible(false)
			gui.EnableScreenClicker(false)
			menu = nil
			
		else
		
			menu:SetVisible(true)
			gui.EnableScreenClicker(true)
			
		end
		
	end
	
end
hook.Add("KeyPress", "TradeskillMenuCL", function(ply, key)
	if key == IN_USE then
		net.Start("MMO_RequestMenu")
			net.SendToServer()
	end
end)

net.Receive("MMO_InteractMenu", function()
	print("[DEBUG] Received Command to open Interactive Menu.")
	menu_type = net.ReadString()
	InteractiveMenu()
end)

net.Receive("MMO_Fail", function()
	local reason = net.ReadString()
	
	if reason == "insufficient" then
		surface.PlaySound("buttons/button8.wav")
		chat.AddText(Color(180,120,120), "[Tradeskill] You do not have all the requirements to make that item!")
	elseif reason == "skill" then
		chat.AddText(Color(180,120,120), "[Tradeskill] You failed to create that item. Try again.")
	elseif reason == "moved" then
		chat.AddText(Color(180,120,120), "[Tradeskill] You moved... Crafting was canceled!")
	elseif reason == "exists" then
		chat.AddText(Color(180,120,120), "[Tradeskill] That recipe does not exist! (Bug?)")
	end
	RefreshWindow()
end)

net.Receive("MMO_CountDown", function()
	-- When you go to make the countdown timer on the window, do something like "if coundown ~= nil", use CurTime() to calculate, then countdown = nil when < 0
	countdown = net.ReadInt(8)
end)

net.Receive("MMO_Pass", function()
	local item_name = net.ReadString()
	chat.AddText(Color(120,180,120), "[Tradeskill] Success! "..item_name.." has been added to your inventory.")	
	RefreshWindow()
end)

net.Receive("MMO_SkillUp", function()
	local skill_name = net.ReadString()
	chat.AddText(Color(180,180,120), "[Tradeskill] You have become better at "..skill_name.."!")	
end)