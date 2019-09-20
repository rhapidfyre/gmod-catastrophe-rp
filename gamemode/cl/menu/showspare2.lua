
-- F4 Menu will serve as the player's inventory
-- KEEP THE INVENTORY SERVER SIDE!

local menu = nil
local submenu1 = nil
local submenu2 = nil
local selection = nil
local myWeight = 140	-- Base player weight (fatness... 140 seems like a good low value for extremely atheletic players)

local itemcount = 0
local itempos = 0

local function ConsumeItem(item_info)
	print("[DEBUG] Consuming Item...")
	net.Start("MMO_Consume")
		net.WriteString(item_info["name"])
		net.SendToServer()
end

local function CalcWeight()
	local add = 140
	for y,z in pairs(inventory) do
		add = add + (inventory[y]["weight"] * inventory[y]["amount"])
	end
	myWeight = add
end

-- Set refresh when player clicks on something
local function RefreshMenu()
	menu:Close()
	menu = nil
	timer.Simple(0.1, function() ToggleInventory() end)
end

local function DeleteItem()
	net.Start("MMO_InvDelete")
		net.WriteString(selection["name"])
		net.SendToServer()
	RefreshMenu()
end

local function DropItem(amount)
	net.Start("MMO_InvDrop")
		net.WriteString(selection["name"])
		net.WriteInt(amount, 32)
		net.SendToServer()
	RefreshMenu()
end

-- Draw the items that the player possesses
local function ListInventory()
	local x = 4
	local y = 4
	for k,v in pairs(inventory) do
		if inventory[k]["amount"] > 0 then
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
			if x >= (submenu1:GetWide() - 96) then
				x = 4
				y = y + 100
			end
		end
	end
end

-- Draw the menu
local function DrawInventory()
	menu = vgui.Create("DFrame")
	menu:SetSize(ScrW()/2,ScrH()/2)
	menu:SetPos((ScrW()/2)-(menu:GetWide()/2),(ScrH()/2)-(menu:GetTall()/2))
	menu:SetTitle("Inventory - Press F4 to Close")
	menu:SetDraggable(false)
	function menu:OnClose()
		menu:SetVisible(false)
		gui.EnableScreenClicker(false)
		menu = nil
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
			draw.RoundedBox(4,16,submenu2:GetTall()-142,submenu2:GetWide()-32,24,Color(0,0,0))
			draw.SimpleText("SELECTION NAME", "Trebuchet24", submenu2:GetWide()/2, 4, Color(200,200,200), 1)
			draw.SimpleText("ITEM DESCRIPTION", "Trebuchet24", submenu2:GetWide()/2, 68, Color(200,200,200), 1)
			draw.SimpleText("TOTAL WEIGHT", "Trebuchet24", submenu2:GetWide()/2, 132, Color(200,200,200), 1)
			draw.SimpleText("CREDITS", "Trebuchet24", submenu2:GetWide()/2, submenu2:GetTall()-164, Color(200,200,200), 1)
			if selection ~= nil then
				draw.SimpleText(selection["name"], "BudgetLabel", submenu2:GetWide()/2, 30, Color(40,255,40), 1)
				draw.SimpleText(selection["desc"], "BudgetLabel", submenu2:GetWide()/2, 94, Color(40,255,40), 1)
				draw.SimpleText(math.Round(selection["weight"]*selection["amount"], 2), "BudgetLabel", submenu2:GetWide()/2, 158, Color(40,255,40), 1)
			end
				draw.SimpleText(string.Comma(LocalPlayer():GetMoney()), "BudgetLabel", submenu2:GetWide()/2, submenu2:GetTall()-138, Color(40,255,40), 1)
		end
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-112)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(125,125,125))
				draw.SimpleText("DROP 1", "ChatFont", button:GetWide()/2, 2, Color(200,200,200), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,80,80))
				draw.SimpleText("DROP 1", "ChatFont", button:GetWide()/2, 2, Color(120,120,120), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("DROP 1", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	button.DoClick = function()
		DropItem(1)
	end
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-84)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(125,125,125))
				draw.SimpleText("DROP ALL", "ChatFont", button:GetWide()/2, 2, Color(200,200,200), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(80,80,80))
				draw.SimpleText("DROP ALL", "ChatFont", button:GetWide()/2, 2, Color(120,120,120), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("DROP ALL", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	button.DoClick = function()
		DropItem(selection["amount"])
	end
	
	local button = vgui.Create("DButton", submenu2)
	button:SetSize(submenu2:GetWide()-24, 24)
	button:SetPos(submenu2:GetWide()/2 - button:GetWide()/2, submenu2:GetTall()-56)
	button:SetText("")
	button.Paint = function()
		if selection ~= nil then
			if button:IsHovered() then
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(255,80,80))
				draw.SimpleText("DESTROY ALL", "ChatFont", button:GetWide()/2, 2, Color(255,255,255), TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
				draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,80,80))
				draw.SimpleText("DESTROY ALL", "ChatFont", button:GetWide()/2, 2, Color(180,80,80), TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(4,0,0,button:GetWide(),button:GetTall(),Color(180,180,180))
			draw.RoundedBox(4,2,2,button:GetWide()-4,button:GetTall()-4,Color(120,120,120))
			draw.SimpleText("DESTROY ALL", "ChatFont", button:GetWide()/2, 2, Color(80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	
	button.DoClick = function()
		DeleteItem()
	end
	local capacity = vgui.Create("DPanel", submenu2)
	capacity:SetSize(submenu2:GetWide(), 24)
	capacity:SetPos(0, submenu2:GetTall()-28)
	capacity.Paint = function()
		draw.SimpleText("WEIGHT   "..math.Round((myWeight), 2).." / 450", "DermaDefault", capacity:GetWide()/2, 4, Color(255,255,255), TEXT_ALIGN_CENTER)
	end
	
	ListInventory()
end

function ToggleInventory()

	if !IsValid(menu) then
		CalcWeight()
		DrawInventory()
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
concommand.Add("mmo_inventory", ToggleInventory)

-- net.Receive to update player's inventory
	-- Every time an item is picked up
	-- Every time a quest is completed
	-- Every time the player respawns
	-- Every time the player closes a loot window
	-- Every time the player closes a boss chest
	
net.Receive("MMO_InvAdd", function()
	local iName  = net.ReadString()
	local iCount = net.ReadInt(32)
	print("(DEBUG) Received "..iCount.." "..iName)
	local this_item = {}
		this_item["name"] = iName
		this_item["amount"] = iCount
	PrintTable(this_item)
	table.insert(inventory, this_item)
	PrintTable(inventory)
end)

net.Receive("MMO_InvRemove", function()
	table.Empty(inventory)
end)


net.Receive("MMO_InvUpdate", function()
	inventory = net.ReadTable()
end)















