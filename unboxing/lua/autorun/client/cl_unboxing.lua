include("unboxing_config.lua")

unboxing_init = unboxing_init or nil

unboxing_stuff = unboxing_stuff or {}
unboxing_stuff.keys = unboxing_stuff.keys or 0
unboxing_stuff.crates = unboxing_stuff.crates or 0

surface.CreateFont("Unbox_NexaBold", {font = "Nexa Bold", size = 30, weight = 500, blursize = 0, scanlines = 0, antialias = true})
surface.CreateFont("Unbox_NexaBold2", {font = "Nexa Bold", size = 60, weight = 500, blursize = 0, scanlines = 0, antialias = true})
surface.CreateFont("Unbox_NexaBold3", {font = "Nexa Bold", size = 20, weight = 500, blursize = 0, scanlines = 0, antialias = true})
surface.CreateFont("Unbox_Arial", {font = "Arial", size = 15, weight = 1000, blursize = 0, scanlines = 0, antialias = true})

local Unbox_ItemsList = {}

local Unbox_IsSpinning
local Unbox_IsOpened
local Unbox_DoGenerateItems

local Unbox_Frame
local Unbox_Line
local Unbox_CloseButton
local Unbox_Icon
local Unbox_BuyCrate
local Unbox_GiftCrate
local Unbox_OpenCrate
local Unbox_BuyKey

local glass = Material("mg_unboxing/glass.png", "smooth noclamp")
local glass2 = Material("mg_unboxing/glass_2.png", "smooth noclamp")
local crate = Material("mg_unboxing/icon_crate.png")
local padlock = Material("mg_unboxing/icon_padlock.png")
local key = Material("mg_unboxing/icon_key.png")

local reward_key = Material("mg_unboxing/key.png", "smooth noclamp")
local reward_points = Material("mg_unboxing/points.png", "smooth noclamp")
local reward_xp = Material("mg_unboxing/xp.png", "smooth noclamp")
function Unbox_OpenStore()
	if !unboxing_init then
		surface.PlaySound("buttons/button2.wav")
		notification.AddLegacy("Unboxing-Daten noch nicht synchronisiert.\nBitte versuche es später erneut!", NOTIFY_ERROR, 4)
		return
	end
	if IsValid(Unbox_Frame) then Unbox_Frame:Close() end
	local ply = LocalPlayer()
	Unbox_Frame = vgui.Create("DFrame")
	Unbox_Frame:SetSize(700, 640)
	Unbox_Frame:Center()
	Unbox_Frame:SetVisible(true)
	Unbox_Frame:MakePopup()
	Unbox_Frame:SetDeleteOnClose(true)
	Unbox_Frame:ShowCloseButton(false)
	Unbox_Frame:SetTitle("")
	Unbox_Frame:ParentToHUD()
	Unbox_Frame.Paint = function(self, w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 255))
	end
	Unbox_Frame.OnClose = function(self)
		Unbox_IsOpened = false
		self:Remove()
	end
	Unbox_CloseButton = vgui.Create("DButton", Unbox_Frame)
	Unbox_CloseButton:SetSize(30, 18)
	Unbox_CloseButton:SetPos(665, 5)
	Unbox_CloseButton:SetText("")
	Unbox_CloseButton.Paint = function(self, w, h)
		if !Unbox_DoGenerateItems then
			draw.RoundedBox(0, 0, 0, w, h, Color(192, 57, 43))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("X") / 2
		surface.SetTextPos((w / 2)- x, 2)
		surface.DrawText("X")
	end
	Unbox_CloseButton.DoClick = function(self)
		if !Unbox_DoGenerateItems then
			surface.PlaySound("ui/buttonclick.wav")
			Unbox_Frame:Close()
		end
	end
	local Unbox_CashDisplay = vgui.Create("DPanel", Unbox_Frame)
	Unbox_CashDisplay:SetSize(100, 20)
	Unbox_CashDisplay:SetPos(350, 5)
	Unbox_CashDisplay:SetText("")
	Unbox_CashDisplay.Paint = function(self, w, h)
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_NexaBold3")
		local t = "Cash: "..string.Comma(ply:PS_GetPoints())
		local x = surface.GetTextSize(t)
		self:SetSize(x + 20, 20)
		self:SetPos(Unbox_Frame:GetWide() / 2 - self:GetWide() / 2, 5)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		surface.SetTextPos(10, 1)
		surface.DrawText(t)
	end
	Unbox_Icon = vgui.Create("DPanel", Unbox_Frame)
	Unbox_Icon:SetSize(700, 380)
	Unbox_Icon:SetPos(0, 20)
	Unbox_Icon.Paint = function(self, w, h)
		surface.SetMaterial(crate)
		surface.SetDrawColor(120, 120, 120)
		surface.DrawTexturedRect(85, 40, 92, 92)
		surface.SetTextColor(Color(120, 120, 120))
		surface.SetFont("Unbox_NexaBold2")
		local x = surface.GetTextSize(unboxing_stuff.crates) / 2
		surface.SetTextPos(132 - x, 150)
		surface.DrawText(unboxing_stuff.crates)
		surface.SetMaterial(padlock)
		surface.SetDrawColor(120, 120, 120)
		surface.DrawTexturedRect(288, 67, 128, 128)
		surface.SetMaterial(key)
		surface.SetDrawColor(120, 120, 120)
		surface.DrawTexturedRect(530, 40, 92, 92)
		surface.SetTextColor(Color(120, 120, 120))
		surface.SetFont("Unbox_NexaBold2")
		local x = surface.GetTextSize(unboxing_stuff.keys) / 2
		surface.SetTextPos(578 - x, 150)
		surface.DrawText(unboxing_stuff.keys)
	end
	Unbox_BuyCrate = vgui.Create("DButton", Unbox_Icon)
	Unbox_BuyCrate:SetSize(200, 30)
	Unbox_BuyCrate:SetPos(20, 230)
	Unbox_BuyCrate:SetText("")
	Unbox_BuyCrate.Paint = function(self, w, h)
		if ply:PS_HasPoints(UnboxConfig.CratePrice) then
			draw.RoundedBox(0, 0, 0, w, h, Color(85, 125, 37))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("KISTE KAUFEN ("..string.Comma(UnboxConfig.CratePrice)..")") / 2
		surface.SetTextPos(w / 2 - x , h / 4)
		surface.DrawText("KISTE KAUFEN ("..string.Comma(UnboxConfig.CratePrice)..")")
	end
	Unbox_BuyCrate.DoClick = function()
		if ply:PS_HasPoints(UnboxConfig.CratePrice) then
			surface.PlaySound("buttons/button15.wav")
			Unbox_CreateBuyCrateMenu()
		end
	end
	Unbox_GiftCrate = vgui.Create("DButton", Unbox_Icon)
	Unbox_GiftCrate:SetSize(200, 30)
	Unbox_GiftCrate:SetPos(20, 270)
	Unbox_GiftCrate:SetText("")
	Unbox_GiftCrate.Paint = function(self, w, h)
		if unboxing_stuff.crates > 0 and !Unbox_IsSpinning and player.GetCount() > 1 then
			draw.RoundedBox(0, 0, 0, w, h, Color(85, 125, 37))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("KISTE SCHENKEN") / 2
		surface.SetTextPos(w / 2 - x , h / 4)
		surface.DrawText("KISTE SCHENKEN")
	end
	Unbox_GiftCrate.DoClick = function()
		if unboxing_stuff.crates > 0 and !Unbox_IsSpinning and player.GetCount() > 1 then
			surface.PlaySound("buttons/button15.wav")
			Unbox_CreateGiftCrateMenu()
		end
	end
	Unbox_OpenCrate = vgui.Create("DButton", Unbox_Icon)
	Unbox_OpenCrate:SetSize(140, 30)
	Unbox_OpenCrate:SetPos(280, 230)
	Unbox_OpenCrate:SetText("")
	Unbox_OpenCrate.Paint = function(self, w, h)
		if unboxing_stuff.crates > 0 and unboxing_stuff.keys > 0 and !Unbox_DoGenerateItems then
			draw.RoundedBox(0, 0, 0, w, h, Color(85, 125, 37))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("KISTE ÖFFNEN") / 2
		surface.SetTextPos(w / 2 - x , h / 4)
		surface.DrawText("KISTE ÖFFNEN")
	end
	Unbox_OpenCrate.DoClick = function()
		if unboxing_stuff.crates > 0 and unboxing_stuff.keys > 0 and !Unbox_DoGenerateItems then
			surface.PlaySound("buttons/button15.wav")
			net.Start("Unbox_OpenCrate")
			net.SendToServer()
		end
	end
	Unbox_GiftCrate = vgui.Create("DButton", Unbox_Icon)
	Unbox_GiftCrate:SetSize(140, 30)
	Unbox_GiftCrate:SetPos(280, 270)
	Unbox_GiftCrate:SetText("")
	Unbox_GiftCrate.Paint = function(self, w, h)
		if unboxing_stuff.crates > 0 and unboxing_stuff.keys > 0 and !Unbox_DoGenerateItems then
			draw.RoundedBox(0, 0, 0, w, h, Color(85, 125, 37))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("UNBOX STIFTEN") / 2
		surface.SetTextPos(w / 2 - x , h / 4)
		surface.DrawText("UNBOX STIFTEN")
	end
	Unbox_GiftCrate.DoClick = function()
		if unboxing_stuff.crates > 0 and unboxing_stuff.keys > 0 and !Unbox_DoGenerateItems then
			surface.PlaySound("buttons/button15.wav")
			net.Start("Unbox_OpenCrateGift")
			net.SendToServer()
		end
	end
	Unbox_BuyKey = vgui.Create("DButton", Unbox_Icon)
	Unbox_BuyKey:SetSize(200, 30)
	Unbox_BuyKey:SetPos(480, 230)
	Unbox_BuyKey:SetText("")
	Unbox_BuyKey.Paint = function(self, w, h)
		if ply:PS_HasPoints(UnboxConfig.KeyPrice) then
			draw.RoundedBox(0, 0, 0, w, h, Color(85, 125, 37))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180, 180, 180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("SCHLÜSSEL KAUFEN ("..string.Comma(UnboxConfig.KeyPrice)..")") / 2
		surface.SetTextPos(w / 2 - x , h / 4)
		surface.DrawText("SCHLÜSSEL KAUFEN ("..string.Comma(UnboxConfig.KeyPrice)..")")
	end
	Unbox_BuyKey.DoClick = function()
		if ply:PS_HasPoints(UnboxConfig.KeyPrice) then
			surface.PlaySound("buttons/button15.wav")
			Unbox_CreateBuyKeyMenu()
		end
	end
	Unbox_GiftKey = vgui.Create("DButton", Unbox_Icon)
	Unbox_GiftKey:SetSize(200, 30)
	Unbox_GiftKey:SetPos(480, 270)
	Unbox_GiftKey:SetText("")
	Unbox_GiftKey.Paint = function(self, w, h)
		if unboxing_stuff.keys> 0 and !Unbox_IsSpinning and player.GetCount() > 1 then
			draw.RoundedBox(0, 0, 0, w, h, Color(85, 125, 37))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end
		surface.SetTextColor(Color(180,180,180))
		surface.SetFont("Unbox_Arial")
		local x = surface.GetTextSize("SCHLÜSSEL SCHENKEN") / 2
		surface.SetTextPos(w / 2 - x , h / 4)
		surface.DrawText("SCHLÜSSEL SCHENKEN")
	end
	Unbox_GiftKey.DoClick = function()
		if unboxing_stuff.keys > 0 and !Unbox_IsSpinning and player.GetCount() > 1 then
			surface.PlaySound("buttons/button15.wav")
			Unbox_CreateGiftKeyMenu()
		end
	end
	Unbox_CreateWindow()
	Unbox_GenerateItems(Unbox_GenerateSpinList())
	Unbox_ShiftItems()
end

function Unbox_GenerateSpinList()
	local totalChance = 0
	for _,v in pairs(UnboxItems) do
		totalChance = totalChance + v.ItemChance
	end
	local itemList = {}
	for i = 0 , 99 do
		local num = math.random(1, totalChance)
		local prevCheck = 0
		local curCheck = 0
		local item
		for _,v in pairs(UnboxItems) do
			if num >= prevCheck and num <= prevCheck + v.ItemChance then
				item = v
			end
			prevCheck = prevCheck + v.ItemChance
		end
		itemList[i] = item
	end
	return itemList
end

function Unbox_ShiftItems()
	for _,v in pairs(Unbox_ItemsList) do
		if !IsValid(v.panel) then continue end
		v.panel:SetPos(v.xPos + 2000, 10)
	end
end

local function Buy(typ, amount)
	net.Start(typ)
		net.WriteUInt(amount, 16)
	net.SendToServer()
end

local function AddSubMenu(menu, text, amount, typ)
	local temp = menu:AddOption(text)
	temp.DoClick = function(self)
		surface.PlaySound("buttons/button15.wav")
		Buy(typ, amount)
	end
end

local function AddPlayerSubMenu(menu, text, amount, typ, single)
	local submenu = single and menu or menu:AddSubMenu(text)
	local players = player.GetAll()
	local available
	for _,v in ipairs(players) do
		if v == LocalPlayer() then continue end
		available = true
		local temp = submenu:AddOption(v:Name())
		temp.ply = v
		temp.DoClick = function(self)
			surface.PlaySound("buttons/button15.wav")
			net.Start(typ)
				net.WriteEntity(self.ply)
				net.WriteUInt(amount, 16)
			net.SendToServer()
		end
	end
	if !available then
		submenu:AddOption("Niemand verfügbar!")
	end
end

function Unbox_CreateBuyCrateMenu()
	local ply = LocalPlayer()
	local menu = vgui.Create("DMenu")
	if ply:PS_HasPoints(UnboxConfig.CratePrice) and !ply:PS_HasPoints(UnboxConfig.CratePrice * 2) then
		Buy("Unbox_BuyCrate", 1)
	else
		AddSubMenu(menu, "1x", 1, "Unbox_BuyCrate")
		if ply:PS_HasPoints(UnboxConfig.CratePrice * 2) then
			AddSubMenu(menu, "2x", 2, "Unbox_BuyCrate")
		end
		if ply:PS_HasPoints(UnboxConfig.CratePrice * 3) then
			AddSubMenu(menu, "3x", 3, "Unbox_BuyCrate")
		end
		if ply:PS_HasPoints(UnboxConfig.CratePrice * 4) then
			AddSubMenu(menu, "4x", 4, "Unbox_BuyCrate")
		end
		if ply:PS_HasPoints(UnboxConfig.CratePrice * 5) then
			AddSubMenu(menu, "5x", 5, "Unbox_BuyCrate")
		end
		if ply:PS_HasPoints(UnboxConfig.CratePrice * 10) then
			AddSubMenu(menu, "10x", 10, "Unbox_BuyCrate")
		end
	end
	menu:Open()
end

function Unbox_CreateBuyKeyMenu()
	local ply = LocalPlayer()
	local menu = vgui.Create("DMenu")
	if ply:PS_HasPoints(UnboxConfig.KeyPrice) and !ply:PS_HasPoints(UnboxConfig.KeyPrice * 2) then
		Buy("Unbox_BuyKey", 1)
	else
		AddSubMenu(menu, "1x", 1, "Unbox_BuyKey")
		if ply:PS_HasPoints(UnboxConfig.KeyPrice * 2) then
			AddSubMenu(menu, "2x", 2, "Unbox_BuyKey")
		end
		if ply:PS_HasPoints(UnboxConfig.KeyPrice * 3) then
			AddSubMenu(menu, "3x", 3, "Unbox_BuyKey")
		end
		if ply:PS_HasPoints(UnboxConfig.KeyPrice * 4) then
			AddSubMenu(menu, "4x", 4, "Unbox_BuyKey")
		end
		if ply:PS_HasPoints(UnboxConfig.KeyPrice * 5) then
			AddSubMenu(menu, "5x", 5, "Unbox_BuyKey")
		end
		if ply:PS_HasPoints(UnboxConfig.KeyPrice * 10) then
			AddSubMenu(menu, "10x", 10, "Unbox_BuyKey")
		end
	end
	menu:Open()
end

function Unbox_CreateGiftCrateMenu()
	local menu = vgui.Create("DMenu")
	if unboxing_stuff.crates == 1 then
		AddPlayerSubMenu(menu, "1x", 1, "Unbox_GiftCrate", true)
	else
		AddPlayerSubMenu(menu, "1x", 1, "Unbox_GiftCrate")
		if unboxing_stuff.crates >= 2 then
			AddPlayerSubMenu(menu, "2x", 2, "Unbox_GiftCrate")
		end
		if unboxing_stuff.crates >= 3 then
			AddPlayerSubMenu(menu, "3x", 3, "Unbox_GiftCrate")
		end
		if unboxing_stuff.crates >= 4 then
			AddPlayerSubMenu(menu, "4x", 4, "Unbox_GiftCrate")
		end
		if unboxing_stuff.crates >= 5 then
			AddPlayerSubMenu(menu, "5x", 5, "Unbox_GiftCrate")
		end
		if unboxing_stuff.crates >= 10 then
			AddPlayerSubMenu(menu, "10x", 10, "Unbox_GiftCrate")
		end
	end
	menu:Open()
end

function Unbox_CreateGiftKeyMenu()
	local menu = vgui.Create("DMenu")
	if unboxing_stuff.crates == 1 then
		AddPlayerSubMenu(menu, "1x", 1, "Unbox_GiftKey", true)
	else
		AddPlayerSubMenu(menu, "1x", 1, "Unbox_GiftKey")
		if unboxing_stuff.keys >= 2 then
			AddPlayerSubMenu(menu, "2x", 2, "Unbox_GiftKey")
		end
		if unboxing_stuff.keys >= 3 then
			AddPlayerSubMenu(menu, "3x", 3, "Unbox_GiftKey")
		end
		if unboxing_stuff.keys >= 4 then
			AddPlayerSubMenu(menu, "4x", 4, "Unbox_GiftKey")
		end
		if unboxing_stuff.keys >= 5 then
			AddPlayerSubMenu(menu, "5x", 5, "Unbox_GiftKey")
		end
		if unboxing_stuff.keys >= 10 then
			AddPlayerSubMenu(menu, "10x", 10, "Unbox_GiftKey")
		end
	end
	menu:Open()
end

function Unbox_CreateWindow()
	Unbox_IsOpened = true
	Unbox_SpinPanel = vgui.Create("DPanel", Unbox_Frame)
	Unbox_SpinPanel:SetPos(10, 330)
	Unbox_SpinPanel:SetSize(680, 300)
	Unbox_SpinPanel.Paint = function(self, w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30))
	end
end

function Unbox_GenerateItems(DataTable)
	local random_items = DataTable
	if !random_items then return end
	for i = 0, 99 do
		local rand_item = random_items[i]
		if !rand_item then return end
		local typ = rand_item.Type
		Unbox_ItemsList[i] = {}
		local itemlist = Unbox_ItemsList[i]
		itemlist.xPos = (((292 * i) * -1) + 145) - 80
		itemlist.panel = vgui.Create("DPanel", Unbox_SpinPanel)
		itemlist.panel.id = i
		itemlist.panel.item = rand_item
		itemlist.panel:SetPos((290 * i * -1) + 235,10)
		itemlist.panel:SetSize(280, 280)
		itemlist.panel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(180, 180, 180))
			if self.item then
				draw.RoundedBox(0, 0, h - 80, w, 80, self.item.ItemColor)
				draw.SimpleText(self.item.ItemName, "Unbox_NexaBold", 5, 205, color_white)
			end
			if rand_item then
				if typ == "PITEM" then
					draw.SimpleText("Kategorie: "..self.item.ItemCategory, "Unbox_Arial", 5, 235, color_white)
					draw.SimpleText("Wert: "..string.Comma(self.item.ItemPrice), "Unbox_Arial", 5, 250, color_white)
				elseif typ == "POINTS" then
					draw.SimpleText("Shopwährung", "Unbox_Arial", 5, 235, color_white)
				elseif typ == "XP" then
					draw.SimpleText("Erfahrung", "Unbox_Arial", 5, 235, color_white)
				end
			end
		end
		if rand_item then
			if typ == "PITEM" then
				if rand_item.ItemUseModel then
					local ITEM = PS.Items and PS.Items[itemlist.panel.item.ItemClassName]
					if ITEM then
						itemlist.ModelView = vgui.Create("DModelPanel", itemlist.panel)
						itemlist.ModelView:SetSize(280, 200)
						itemlist.ModelView:SetModel(ITEM.Model)

						if ITEM.Skin then
							itemlist.ModelView:SetSkin(ITEM.Skin)
						end
						if IsValid(itemlist.ModelView.Entity) then
							local PrevMins, PrevMaxs = itemlist.ModelView.Entity:GetRenderBounds()
							itemlist.ModelView:SetCamPos(isfunction(ITEM.ModelCamPos) and ITEM.ModelCamPos(PrevMins, PrevMaxs) or PrevMins:Distance(PrevMaxs) * Vector(ITEM.ModelCamPosX or 0.7, ITEM.ModelCamPosY or 0.7, ITEM.ModelCamPosZ or 0.7))
							itemlist.ModelView:SetLookAt(isfunction(ITEM.ModelLookAt) and ITEM.ModelLookAt(PrevMins, PrevMaxs) or (PrevMaxs + PrevMins) / 2)

							function itemlist.ModelView:LayoutEntity(ent)
								if isfunction(ITEM.ModelImageCustomLayout) then return ITEM.ModelImageCustomLayout(self, ent) end
								if self:GetParent().Hovered then
									if !ITEM.ModelImageDisableSpin then
										local angles = ent:GetAngles()
										ent:SetAngles(Angle(ITEM.ModelImageSpinPitch or angles.p, ITEM.ModelImageSpinYaw or angles.y + (FrameTime() * (ITEM.ModelImageSpinSpeed or 250)), ITEM.ModelImageSpinRoll or angles.r))
									end
								else
									local angles = ent:GetAngles()
									ent:SetAngles(Angle(ITEM.ModelImageSpinPitch or angles.p, ITEM.ModelImageSpinYaw or angles.y, ITEM.ModelImageSpinRoll or angles.r))
								end
								if !ITEM.ModelImageIgnoreModification then
									ITEM:ModifyClientsideModel(self.Entity, ent, Vector(), Angle(), self)
								end
								if !ITEM.ModelImageKeepSize then
									local size = Vector(1, 1, 1)
									if ITEM.ModelImageSize then
										size = ITEM.ModelImageSize
									end
									local mat = Matrix()
									mat:Scale(size)
									ent:EnableMatrix("RenderMultiply", mat)
								end
								if !ITEM.ModelImageIgnoreModification then
									ITEM:PostModifyClientsideModel(self.Entity, ent, Vector(), Angle(), self)
								end
							end

							if ITEM.ModelImageColor then
								itemlist.ModelView:SetColor(ITEM.ModelImageColor)
							end
						end
					else
						itemlist.ModelView = vgui.Create("DModelPanel", itemlist.panel)
						itemlist.ModelView:SetSize(280, 200)
						itemlist.ModelView:SetModel(itemlist.panel.item.ItemModel)
						local ent = itemlist.ModelView.Entity
						if IsValid(ent) then
							local min, max = ent:GetRenderBounds()
							itemlist.ModelView:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
							itemlist.ModelView:SetLookAt((max + min) / 2)
						end
					end
				else
					itemlist.ModelView = vgui.Create("DImage", itemlist.panel)
					itemlist.ModelView:SetImage(itemlist.panel.item.ItemMateral)
					itemlist.ModelView:SetSize(120, 120)
					itemlist.ModelView:SetPos(80, 40)
				end
			else
				itemlist.ModelView = vgui.Create("DImage", itemlist.panel)
				itemlist.ModelView:SetSize(200, 200)
				itemlist.ModelView:SetPos(40, 0)
				if typ == "POINTS" then
					itemlist.ModelView:SetMaterial(reward_points)
				elseif typ == "XP" then
					itemlist.ModelView:SetMaterial(reward_xp)
				elseif typ == "KEY" then
					itemlist.ModelView:SetMaterial(reward_key)
				else
					itemlist.ModelView:SetImage("mg_unboxing/trail.png")
				end
			end
		end
	end
	Unbox_Line = vgui.Create("DPanel", Unbox_SpinPanel)
	Unbox_Line:SetSize(680, 300)
	Unbox_Line.Paint = function(self, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(glass)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(glass2)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, w, h)
		draw.RoundedBox(0, 680 / 2 - 2, 0, 4, h, Color(244, 129, 0, 150))
	end
end

local Unbox_SpeedMultiplier = 7500
local Unbox_EndPosition = (500 * 3) + math.Rand(220, 490)
net.Receive("Unbox_InitSpin", function()
	local data = net.ReadTable()
	Unbox_Spin(data)
end)

local Unbox_LastSysTime = SysTime()
function Unbox_Spin(data)
	Unbox_CreateWindow()
	for k in pairs(Unbox_ItemsList) do
		local panel = Unbox_ItemsList[k].panel
		if IsValid(panel) then
			panel:Remove()
		end
		panel = Unbox_ItemsList[k].ModelView
		if IsValid(panel) then
			panel:Remove()
		end
	end
	Unbox_DoGenerateItems = true
	Unbox_GenerateItems(data)
	Unbox_SpeedMultiplier = 7500
	Unbox_EndPosition = (500 * 3) + math.Rand(220, 490)
	Unbox_LastSysTime = SysTime()
	Unbox_IsSpinning = true
end

local Unbox_PreviousItem = 0
function Unbox_SpinItems()
	local sys_time = SysTime()
	Unbox_SpeedMultiplier = Lerp(sys_time - Unbox_LastSysTime, Unbox_SpeedMultiplier, Unbox_EndPosition)
	Unbox_LastSysTime = sys_time
	if math.floor(Unbox_SpeedMultiplier / 290) != Unbox_PreviousItem then
		LocalPlayer():EmitSound("mg_unboxing/next_item.wav")
	end
	for _,v in pairs(Unbox_ItemsList) do
		if IsValid(v.panel) then
			v.panel:SetPos(v.xPos + Unbox_SpeedMultiplier, 10)
		end
	end
	if Unbox_SpeedMultiplier < Unbox_EndPosition + 30 and Unbox_IsSpinning and Unbox_DoGenerateItems then
		Unbox_IsSpinning = false
		net.Start("Unbox_FinishedUnbox")
		net.SendToServer()
		surface.PlaySound("buttons/lever6.wav")
		Unbox_DoGenerateItems = false
	end
	Unbox_PreviousItem = math.floor(Unbox_SpeedMultiplier / 290)
end

hook.Add("Think", "Unbox_SpinItems", function()
	if Unbox_IsSpinning then
		Unbox_SpinItems()
	end
end)

net.Receive("Unbox_Update", function(len)
	unboxing_stuff.keys = net.ReadInt(32)
	unboxing_stuff.crates = net.ReadInt(32)
	unboxing_init = true
end)

net.Receive("Unbox_Found", function()
	local ply = net.ReadEntity()
	local item = net.ReadString()
	local color = net.ReadColor()
	if !IsValid(ply) then return end
	chat.AddText((CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())), ply:Name(), color_white, " hat ", color, item, color_white, " aus dem Unboxing gezogen.")
end)

net.Receive("Unbox_SomeoneFoundGift", function()
	local ply = net.ReadEntity()
	local receiver = net.ReadEntity()
	local item = net.ReadString()
	local color = net.ReadColor()
	if !IsValid(ply) or !IsValid(receiver) then return end
	chat.AddText((CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())), ply:Name(), color_white, " hat ", color, item, color_white, " aus dem Unboxing gezogen und ", (CORPSE and Color(255, 255, 150) or team.GetColor(receiver:Team())), receiver:Name(), color_white, " geschenkt.")
end)

net.Receive("Unbox_SomeoneGiftedCrate", function()
	local ply = net.ReadEntity()
	local receiver = net.ReadEntity()
	if !IsValid(ply) or !IsValid(receiver) then return end
	local crates = net.ReadUInt(16)
	chat.AddText((CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())), ply:Name(), color_white, " hat ", (CORPSE and Color(255, 255, 150) or team.GetColor(receiver:Team())), receiver:Name(), Color(0, 156, 0), " "..(crates == 1 and "1 Kiste" or crates.." Kisten"), color_white, " geschenkt.")
end)

net.Receive("Unbox_SomeoneGiftedKey", function()
	local ply = net.ReadEntity()
	local receiver = net.ReadEntity()
	if !IsValid(ply) or !IsValid(receiver) then return end
	local keys = net.ReadUInt(16)
	chat.AddText((CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())), ply:Name(), color_white, " hat ", (CORPSE and Color(255, 255, 150) or team.GetColor(receiver:Team())), receiver:Name(), Color(255, 153, 0), " "..keys, " Schlüssel ", color_white, "geschenkt.")
end)

concommand.Add("unboxing", Unbox_OpenStore)