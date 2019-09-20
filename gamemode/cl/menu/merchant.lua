
local menu = nil
local submenu1 = nil
local submenu2 = nil
local submenu3 = nil
local sellslider = nil
local buyslider = nil
local selection = nil
local npc_type = nil
local npc_inventory = {}
local sel_type = "merch"
local their_offer = 0
local my_offer = 0
local buynumber = 1		-- How many items the NPC is buying
local sellnumber = 1	-- How many items the NPC is selling
local last_open = CurTime()

-- Merchant selling to the player
local function DoPurchase()
	net.Start("MMO_DoPurchase")
		net.WriteString(selection["name"])
		net.WriteString(npc_type)
		net.WriteInt(sellnumber, 32)
		net.SendToServer()
end

-- Player selling to the merchant
local function DoSale()
	net.Start("MMO_DoSale")
		net.WriteString(selection["name"])
		net.WriteInt(buynumber, 32)
		net.SendToServer()
end

-- Set refresh when player clicks on something
local function RefreshWindow()
	menu:Close()
	menu = nil
	timer.Simple(0.1, function() ToggleMerchant() end)
end

-- List the items that the MERCHANT has for sale
local function ListMerchant()
	local x = 4
	local y = 32
	for k,v in pairs(npc_inventory) do
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
		modelview:SetModel(npc_inventory[k]["model"])
		modelview:SetCamPos(Vector(96,96,96))
		modelview:SetLookAt(Vector(0,0,0))
		function modelview:LayoutEntity(Entity) return end
		modelview:SetFOV(20)
		
		local button = vgui.Create("DButton", submenu1)
		button:SetSize(96,96)
		button:SetPos(x, y)
		button:SetText("")
		button.Paint = function()
			if button:IsHovered() then
				draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(120,120,120,20))
			end
		end
		button.DoClick = function()
			selection = npc_inventory[k]
			sel_type = "merch"
			my_offer = npc_inventory[k]["price"] * sellnumber
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

-- Draw the items that the PLAYER possesses
local function ListPlayer()
	local x = 4
	local y = 32
	for k,v in pairs(inventory) do
		if inventory[k]["amount"] > 0 then
			local btnback = vgui.Create("DPanel", submenu2)
			btnback:SetSize(96, 96)
			btnback:SetPos(x, y)
			btnback.Paint = function()
				draw.RoundedBox(6, 0, 0, btnback:GetWide(), btnback:GetTall(), Color(120,120,120))
				draw.RoundedBox(0, 4, 4, btnback:GetWide()-8, btnback:GetTall()-8, Color(25,25,25))
			end
		
			local modelview = vgui.Create("DModelPanel", submenu2)
			modelview:SetSize(96,96)
			modelview:SetPos(x, y)
			modelview:SetModel(inventory[k]["model"])
			modelview:SetCamPos(Vector(96,96,96))
			modelview:SetLookAt(Vector(0,0,0))
			function modelview:LayoutEntity(Entity) return end
			modelview:SetFOV(20)
		
			local button = vgui.Create("DButton", submenu2)
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
				their_offer = inventory[k]["buy_low"] * buynumber
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			button.DoRightClick = function()
				ConsumeItem(inventory[k])
				RefreshMenu()
				surface.PlaySound("garrysmod/ui_click.wav")
			end
			function button:OnCursorEntered()
			end
			x = x + 100
			if x >= (submenu2:GetWide() - 96) then
				x = 4
				y = y + 100
			end
		end
	end
end

-- Draw the menu
local function DrawMerchant()
	-- Draws the title bar area
	menu = vgui.Create("DFrame")
	menu:SetSize(ScrW()/2,ScrH()/2)
	menu:SetPos((ScrW()/2)-(menu:GetWide()/2),(ScrH()/2)-(menu:GetTall()/2))
	menu:SetTitle("Trade Window")
	menu:SetDraggable(false)
	function menu:OnClose()
		menu:SetVisible(false)
		gui.EnableScreenClicker(false)
		menu = nil
	end
	
	submenu1 = vgui.Create("DScrollPanel", menu)
	submenu1:SetSize(menu:GetWide()*0.33, menu:GetTall()-26)
	submenu1:SetPos(2, 24)
	submenu1.Paint = function()
			draw.RoundedBoxEx(4,0,0,submenu1:GetWide(), submenu2:GetTall(), Color(0,0,0),false,false,true,false)
			draw.SimpleText("THEIR INVENTORY", "BudgetLabel", submenu1:GetWide()/2, 2, Color(255,255,255),TEXT_ALIGN_CENTER)
			draw.SimpleText("CREDIT OFFER: "..their_offer, "BudgetLabel", submenu1:GetWide()/2, 16, Color(80,255,80),TEXT_ALIGN_CENTER)
		end

	submenu2 = vgui.Create("DScrollPanel", menu)
	submenu2:SetSize(menu:GetWide()*0.33, menu:GetTall()-26)
	submenu2:SetPos(menu:GetWide() - submenu2:GetWide() - 2, 24)
	submenu2.Paint = function()
			draw.RoundedBoxEx(4,0,0,submenu2:GetWide(), submenu2:GetTall(), Color(0,0,0),false,false,false,true)
			draw.SimpleText("YOUR INVENTORY", "BudgetLabel", submenu2:GetWide()/2, 2, Color(255,255,255),TEXT_ALIGN_CENTER)
			draw.SimpleText("CREDIT OFFER: "..my_offer, "BudgetLabel", submenu2:GetWide()/2, 16, Color(80,255,80),TEXT_ALIGN_CENTER)
		end
		
	submenu3 = vgui.Create("DScrollPanel", menu)
	submenu3:SetSize(menu:GetWide()*0.33, menu:GetTall()-26)
	submenu3:SetPos(menu:GetWide()/2 - submenu3:GetWide()/2, 24)
	submenu3.Paint = function()
			draw.RoundedBox(0,0,0,submenu3:GetWide(), submenu3:GetTall(), Color(80,80,80))
			draw.RoundedBox(4,(submenu3:GetWide()/2)-(submenu3:GetWide()-48)/2,24,submenu3:GetWide()-48, 24, Color(0,0,0))
			draw.RoundedBox(4,(submenu3:GetWide()/2)-(submenu3:GetWide()-48)/2,72,submenu3:GetWide()-48, 24, Color(0,0,0))
			draw.SimpleText("SELECTION NAME", "Trebuchet24", submenu3:GetWide()/2, 0, Color(200,200,200),TEXT_ALIGN_CENTER)
			draw.SimpleText("DESCRIPTION", "Trebuchet24", submenu3:GetWide()/2, 48, Color(200,200,200),TEXT_ALIGN_CENTER)
			draw.SimpleText(sellnumber, "BudgetLabel", 88, submenu3:GetTall()-28, Color(200,200,200),TEXT_ALIGN_CENTER)
			draw.SimpleText(buynumber, "BudgetLabel", submenu3:GetWide()-88, submenu3:GetTall()-28, Color(200,200,200),TEXT_ALIGN_CENTER)
			if selection ~= nil then
				draw.SimpleText(selection["name"], "BudgetLabel", submenu3:GetWide()/2, 28, Color(40,255,40),TEXT_ALIGN_CENTER)
				draw.SimpleText(selection["desc"], "BudgetLabel", submenu3:GetWide()/2, 76, Color(40,255,40),TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Make a selection for info", "BudgetLabel", submenu3:GetWide()/2, 28, Color(120,120,120),TEXT_ALIGN_CENTER)
			end
		end
	
	local button = vgui.Create("DButton", submenu3)
	button:SetSize(196,24)
	button:SetPos(submenu3:GetWide()/2-(196/2),submenu3:GetTall()-102)
	button:SetText("")
	button.Paint = function()
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(255,80,80))
				draw.SimpleText("CANCEL", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,80,80))
				draw.SimpleText("CANCEL", "ChatFont", button:GetWide()/2, 2, Color(180,80,80), TEXT_ALIGN_CENTER)
			end
		end
	button.DoClick = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		menu:Close()
	end
	
	local button = vgui.Create("DButton", submenu3)
	button:SetSize(128,24)
	button:SetPos(submenu3:GetWide()-156,submenu3:GetTall()-64)
	button:SetText("")
	button.Paint = function()
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,180,80))
				draw.SimpleText("SELL", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,120,80))
				draw.SimpleText("SELL", "ChatFont", button:GetWide()/2, 2, Color(80,180,80), TEXT_ALIGN_CENTER)
			end
		end
	button.DoClick = function()
		DoSale()
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	
	local button = vgui.Create("DButton", submenu3)
	button:SetSize(128,24)
	button:SetPos(24,submenu3:GetTall()-64)
	button:SetText("")
	button.Paint = function()
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,180,80))
				draw.SimpleText("BUY", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,120,80))
				draw.SimpleText("BUY", "ChatFont", button:GetWide()/2, 2, Color(80,180,80), TEXT_ALIGN_CENTER)
			end
		end
	button.DoClick = function()
		DoPurchase()
		surface.PlaySound("garrysmod/ui_click.wav")
	end
	
	sellslider = vgui.Create("DButton", submenu3)
	sellslider:SetSize(24, 24)
	sellslider:SetPos(48, submenu3:GetTall()-32)
	sellslider:SetText("-")
	sellslider.DoClick = function()
		if (sellnumber - 1) > 0 then
			if selection ~= nil and sel_type == "merch" then
				sellnumber = sellnumber - 1
				my_offer = selection["price"] * sellnumber
			end
		end
	end
	sellslider.DoRightClick = function()
		if (sellnumber - 10) > 0 then
			if selection ~= nil and sel_type == "merch" then
				sellnumber = sellnumber - 10
				my_offer = selection["price"] * sellnumber
			end
		end
	end
	
	sellslider = vgui.Create("DButton", submenu3)
	sellslider:SetSize(24, 24)
	sellslider:SetPos(48+54, submenu3:GetTall()-32)
	sellslider:SetText("+")
	sellslider.DoClick = function()
		if selection ~= nil and sel_type == "merch" then
			sellnumber = sellnumber + 1
			my_offer = selection["price"] * sellnumber
		end
	end
	sellslider.DoRightClick = function()
		if selection ~= nil and sel_type == "merch" then
			sellnumber = sellnumber + 10
			my_offer = selection["price"] * sellnumber
		end
	end
	
	buyslider = vgui.Create("DButton", submenu3)
	buyslider:SetSize(24, 24)
	buyslider:SetPos(submenu3:GetWide()-128, submenu3:GetTall()-32)
	buyslider:SetText("-")
	buyslider.DoClick = function()
		if (buynumber - 1) > 0 then
			if selection ~= nil and sel_type == "merch" then
				buynumber = buynumber - 1
				their_offer = selection["buy_low"] * buynumber
			end
		end
	end
	buyslider.DoRightClick = function()
		if (buynumber - 10) > 0 then
			if selection ~= nil and sel_type == "merch" then
				buynumber = buynumber - 10
				their_offer = selection["buy_low"] * buynumber
			end
		end
	end
	
	buyslider = vgui.Create("DButton", submenu3)
	buyslider:SetSize(24, 24)
	buyslider:SetPos(submenu3:GetWide()-72, submenu3:GetTall()-32)
	buyslider:SetText("+")
	buyslider.DoClick = function()
		if selection ~= nil and sel_type == "merch" then
			buynumber = buynumber + 1
			their_offer = selection["buy_low"] * buynumber
		end
	end
	buyslider.DoRightClick = function()
		if selection ~= nil and sel_type == "merch" then
			buynumber = buynumber + 10
			their_offer = selection["buy_low"] * buynumber
		end
	end
	
	ListMerchant()
	ListPlayer()
	
end

function ToggleMerchant()

	if !IsValid(menu) then
		selection = nil
		sel_type = "merch"
		sellnumber = 20
		buynumber = 20
		DrawMerchant()
		gui.EnableScreenClicker(true)
		
	else
		
		if menu:IsVisible() then
			menu:SetVisible(false)
			gui.EnableScreenClicker(false)
			menu = nil
		else
			menu:SetVisible(true)
			gui.EnableScreenClicker(true)
		end
		
	end
	

end

-- Receive command to open menu
net.Receive("MMO_OpenMerchant", function()
	if (last_open + 1) < CurTime() then
		npc_inventory = net.ReadTable()
		npc_type = net.ReadString()
		last_open = CurTime()
		timer.Simple(0.1, function() ToggleMerchant() end)
	end
end)

net.Receive("MMO_SaleSuccess", function()
	RefreshWindow()
	chat.AddText(Color(80,180,80), "[NPC] Sale Successful!")
end)

net.Receive("MMO_SaleFailure", function()
	chat.AddText(Color(180,80,80), "[NPC] Sale Failed! Insufficient Funds.")
end)











