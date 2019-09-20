
local menu 		= nil
local submenu1	= nil
local submenu2	= nil
local items 	= 0
local menu_type = nil
local selection = nil
local sel_type  = nil

-- Combined Withdrawal and Deposit into the same function. deposit = false -> Withdrawal
local function Transaction(deposit, count)
	print("[DEBUG] INCOMING COUNT: "..tostring(count))
	net.Start("MMO_BankTransaction")
		net.WriteBool(deposit)
		net.WriteString(selection["name"])
		net.WriteInt(count, 32)
		net.SendToServer()
	menu:Close()
	menu = nil
	timer.Simple(0.25, function() DrawBanking() end)
end

local function ListAccount()
	local x = 4
	local y = 4
	for k,v in pairs(inventory) do
		if inventory[k]["amount"] > 0 then 
		local btnback = vgui.Create("DPanel", submenu1)
		btnback:SetSize(96, 96)
		btnback:SetPos(x, y)
		btnback.Paint = function()
			draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(180,120,120))
			draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(25,25,25))
		end
	
		local modelview = vgui.Create("DModelPanel", submenu1)
		modelview:SetSize(96,96)
		modelview:SetPos(x, y)
		modelview:SetModel(inventory[k]["model"])
		modelview:SetCamPos(Vector(64,64,64))
		modelview:SetLookAt(Vector(0,0,0))
		function modelview:LayoutEntity(Entity) return end
		modelview:SetFOV(20)
	
		local button = vgui.Create("DButton", submenu1)
		button:SetSize(96,96)
		button:SetPos(x, y)
		button:SetText("")
		button.Paint = function()
			draw.SimpleTextOutlined(inventory[k]["amount"], "Trebuchet24", btnback:GetWide()-6, 14, Color(80,80,180), TEXT_ALIGN_RIGHT, 1, 1, Color(0,0,0))
			--draw.SimpleTextOutlined(inventory[k]["name"], "TargetIDSmall", btnback:GetWide()/2, btnback:GetTall()-12, Color(180,180,180), 1, 1, 1, Color(0,0,0))
			if button:IsHovered() then
				draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(120,120,120,20))
			end
		end
		button.DoClick = function()
			selection = inventory[k]
			sel_type = "inv"
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
	end
	for k,v in pairs(bankinv) do
	
		local btnback = vgui.Create("DPanel", submenu1)
		btnback:SetSize(96, 96)
		btnback:SetPos(x, y)
		btnback.Paint = function()
			draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(120,180,120))
			draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(25,25,25))
		end
	
		local modelview = vgui.Create("DModelPanel", submenu1)
		modelview:SetSize(96,96)
		modelview:SetPos(x, y)
		modelview:SetModel(bankinv[k]["model"])
		modelview:SetCamPos(Vector(64,64,64))
		modelview:SetLookAt(Vector(0,0,0))
		function modelview:LayoutEntity(Entity) return end
		modelview:SetFOV(20)
	
		local button = vgui.Create("DButton", submenu1)
		button:SetSize(96,96)
		button:SetPos(x, y)
		button:SetText("")
		button.Paint = function()
			draw.SimpleTextOutlined(bankinv[k]["amount"], "Trebuchet24", btnback:GetWide()-6, 14, Color(80,80,180), TEXT_ALIGN_RIGHT, 1, 1, Color(0,0,0))
			--draw.SimpleTextOutlined(inventory[k]["name"], "TargetIDSmall", btnback:GetWide()/2, btnback:GetTall()-12, Color(180,180,180), 1, 1, 1, Color(0,0,0))
			if button:IsHovered() then
				draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(255,120,120,20))
			end
		end
		button.DoClick = function()
			selection = bankinv[k]
			sel_type = "bank"
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
end


function DrawBanking()

	gui.EnableScreenClicker(true)
	menu = vgui.Create("DFrame")
	menu:SetSize(ScrW()/2,ScrH()/2)
	menu:SetPos((ScrW()/2)-(menu:GetWide()/2),(ScrH()/2)-(menu:GetTall()/2))
	menu:SetTitle("Terminal - Press USE to Close")
	menu:SetDraggable(false)
	function menu:OnClose()
		menu = nil
		gui.EnableScreenClicker(false)
	end
	
	submenu1 = vgui.Create("DScrollPanel", menu)
	submenu1:SetSize(menu:GetWide()*0.75, menu:GetTall()-26)
	submenu1:SetPos(2, 24)
	submenu1.Paint = function()
			draw.RoundedBox(0,0,0,menu:GetWide(),menu:GetTall(),Color(40,40,40))
		end

	submenu2 = vgui.Create("DPanel", menu)
	submenu2:SetSize((menu:GetWide()*0.25)-6, menu:GetTall()-26)
	submenu2:SetPos(menu:GetWide() - submenu2:GetWide() - 2, 24)
	submenu2.Paint = function()
			draw.RoundedBox(0,0,0,menu:GetWide(),menu:GetTall(),Color(40,40,40))
			draw.RoundedBox(0,2,2,submenu2:GetWide()-4,menu:GetTall()-30,Color(100,100,100))
			draw.RoundedBox(4,16,26,submenu2:GetWide()-32,24,Color(0,0,0))
			draw.RoundedBox(4,16,90,submenu2:GetWide()-32,24,Color(0,0,0))
			draw.RoundedBox(4,16,154,submenu2:GetWide()-32,24,Color(0,0,0))
			draw.SimpleText("SELECTION NAME", "Trebuchet24", submenu2:GetWide()/2, 4, Color(200,200,200), 1)
			draw.SimpleText("ITEM DESCRIPTION", "Trebuchet24", submenu2:GetWide()/2, 68, Color(200,200,200), 1)
			draw.SimpleText("TOTAL WEIGHT", "Trebuchet24", submenu2:GetWide()/2, 132, Color(200,200,200), 1)
			if selection ~= nil then
				draw.SimpleText(selection["name"], "BudgetLabel", submenu2:GetWide()/2, 30, Color(40,255,40), 1)
				draw.SimpleText(selection["desc"], "BudgetLabel", submenu2:GetWide()/2, 94, Color(40,255,40), 1)
				draw.SimpleText(math.Round(selection["weight"]*selection["amount"], 2), "BudgetLabel", submenu2:GetWide()/2, 158, Color(40,255,40), 1)
			end
		end
	
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-150)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil and sel_type == "inv"  then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(125,125,125))
				draw.SimpleText("DEPOSIT 1", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,80,80))
				draw.SimpleText("DEPOSIT 1", "ChatFont", button:GetWide()/2, 2, Color(180,180,180), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("DEPOSIT 1", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	button.DoClick = function()
		if selection ~= nil and sel_type == "inv" then
			Transaction(true, 1)
		end
	end
	function button:OnCursorEntered()
		if selection ~= nil then
			surface.PlaySound("buttons/lightswitch2.wav")
		end
	end
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-122)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil and sel_type == "inv"  then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(125,125,125))
				draw.SimpleText("DEPOSIT STACK", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,80,80))
				draw.SimpleText("DEPOSIT STACK", "ChatFont", button:GetWide()/2, 2, Color(180,180,180), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("DEPOSIT STACK", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	button.DoClick = function()
		if selection ~= nil and sel_type == "inv" then
			Transaction(true, selection["amount"])
		end
	end
	function button:OnCursorEntered()
		if selection ~= nil then
			surface.PlaySound("buttons/lightswitch2.wav")
		end
	end
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-84)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil and sel_type == "bank" then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(255,80,80))
				draw.SimpleText("WITHDRAW 1", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,80,80))
				draw.SimpleText("WITHDRAW 1", "ChatFont", button:GetWide()/2, 2, Color(180,80,80), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("WITHDRAW 1", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	button.DoClick = function()
		if selection ~= nil and sel_type == "bank" then
			Transaction(false, 1)
		end
	end
	function button:OnCursorEntered()
		if bank_selection ~= nil then
			surface.PlaySound("buttons/lightswitch2.wav")
		end
	end
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-56)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil and sel_type == "bank"  then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(255,80,80))
				draw.SimpleText("WITHDRAW STACK", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,80,80))
				draw.SimpleText("WITHDRAW STACK", "ChatFont", button:GetWide()/2, 2, Color(180,80,80), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("WITHDRAW STACK", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	
	button.DoClick = function()
		if selection ~= nil and sel_type == "bank" then
			Transaction(false, selection["amount"])
		end
	end
	function button:OnCursorEntered()
		if bank_selection ~= nil then
			surface.PlaySound("buttons/lightswitch2.wav")
		end
	end
	local capacity = vgui.Create("DPanel", submenu2)
	capacity:SetSize(submenu2:GetWide(), 24)
	capacity:SetPos(0, submenu2:GetTall()-28)
	capacity.Paint = function()
		draw.SimpleText("SLOTS   "..tostring(#bankinv).." / 120", "DermaDefault", capacity:GetWide()/2, 4, Color(255,255,255), TEXT_ALIGN_CENTER)
	end
	
	ListAccount()
	
end

local function BankingMenu()
	if (menu == nil) then
	
		DrawBanking()
		
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

net.Receive("MMO_OpenBank", function()
	bankinv 	= net.ReadTable()
	inventory 	= net.ReadTable()
	BankingMenu()
end)
net.Receive("MMO_BankUpdate", function()
	bankinv 	= net.ReadTable()
end)
