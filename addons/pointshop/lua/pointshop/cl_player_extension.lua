local meta = FindMetaTable("Player")

function meta:PS_GetItems()
	return self.PS_Items or {}
end

function meta:PS_HasItem(item_id)
	local items = self.PS_Items
	if !items then return false end
	return items[item_id] and true or false
end

function meta:PS_HasItemEquipped(item_id)
	if !self:PS_HasItem(item_id) then return false end
	return self.PS_Items[item_id].Equipped or false
end

function meta:PS_BuyItem(item_id)
	if self:PS_HasItem(item_id) then return false end
	if !self:PS_HasPoints(PS.Config.CalculateBuyPrice(self, PS.Items[item_id])) then return false end
	net.Start("PS_BuyItem")
		net.WriteString(item_id)
	net.SendToServer()
	return true
end

function meta:PS_SellItem(item_id)
	if !self:PS_HasItem(item_id) then return false end
	net.Start("PS_SellItem")
		net.WriteString(item_id)
	net.SendToServer()
	return true
end

function meta:PS_EquipItem(item_id)
	if !self:PS_HasItem(item_id) then return false end
	net.Start("PS_EquipItem")
		net.WriteString(item_id)
	net.SendToServer()
	return true
end

function meta:PS_HolsterItem(item_id)
	if !self:PS_HasItem(item_id) then return false end
	net.Start("PS_HolsterItem")
		net.WriteString(item_id)
	net.SendToServer()
	return true
end

function meta:PS_GetPoints()
	return self.PS_Points or 0
end

function meta:PS_HasPoints(points)
	return self:PS_GetPoints() >= points
end

local function CleanupOldModels()
	for ply, items in pairs(PS.ClientsideModels) do
		if !IsValid(ply) then
			for item_id, model in pairs(items or {}) do
				if IsValid(model) then
					model:Remove()
				end
			end
			PS.ClientsideModels[ply] = nil
			continue
		end
	end
end

function meta:PS_AddClientsideModel(item_id)
	if !PS.Items[item_id] then return false end
	CleanupOldModels()
	PS.ClientsideModels[self] = PS.ClientsideModels[self] or {}
	local old_model = PS.ClientsideModels[self][item_id]
	if IsValid(old_model) then
		old_model:Remove()
	end
	local ITEM = PS.Items[item_id]
	local mdl = ClientsideModel(ITEM.Model, ITEM.RenderGroup or RENDERGROUP_OPAQUE)
	if !IsValid(mdl) then return false end
	mdl:SetNoDraw(true)
	PS.ClientsideModels[self][item_id] = mdl
	return true
end

function meta:PS_RemoveClientsideModel(item_id)
	if !PS.Items[item_id] then return false end
	local cl_models = PS.ClientsideModels[self]
	if !cl_models then return false end
	local old_model = cl_models[item_id]
	if !old_model then return false end
	if IsValid(old_model) then
		old_model:Remove()
	end
	PS.ClientsideModels[self][item_id] = nil
	return true
end

function meta:PS_RemoveAllClientsideModels()
	local cl_models = PS.ClientsideModels[self]
	if !cl_models then return false end
	for _, model in pairs(cl_models) do
		if IsValid(model) then
			model:Remove()
		end
	end
	PS.ClientsideModels[self] = nil
	return true
end

local PANEL = {}
function PANEL:Init()
	if IsValid(PS_GiveMenuPanel) then
		PS_GiveMenuPanel:Remove()
		PS_GiveMenuPanel = nil
	end
	self:SetTitle(PS.Config.PointsName.." versenden")
	self:SetSize(300, 144)
	self:SetDraggable(false)
	self:SetDeleteOnClose(true)
	local TopBar = vgui.Create("DPanel",self)
	TopBar:SetSize(self:GetWide() - 2, 25)
	TopBar:SetPos(1, 1)
	TopBar.Paint = function(slf)
		surface.SetDrawColor(PS.Style_Config.BGCol.GP_TitleBG)
		surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
		surface.SetDrawColor(PS.Style_Config.Col.PG.Main_Outline)
		surface.DrawRect(0, slf:GetTall() - 1, slf:GetWide(), 1)
		draw.SimpleText(PS.Config.PointsName.." versenden", "PS_Treb_S22", 10, 1, PS.Style_Config.Col.PG.Main_TitleText)
	end
	local Button = vgui.Create("PS_DSWButton",TopBar)
	Button:SetSize(50, 24)
	Button:SetPos(TopBar:GetWide() - 50,0)
	Button.BoarderCol = Color(0, 0, 0, 0)
	Button:SetTexts("X")
	Button.Click = function(slf)
		self:Remove()
	end
	Button.PaintBackGround = function(slf)
		local COL = Color(25, 25, 25, 200)
		surface.SetDrawColor(COL)
		surface.DrawRect(1, 1, slf:GetWide() - 2, slf:GetTall() - 2)
	end
	local l1 = vgui.Create("DLabel", self)
	l1:SetText("Spieler:")
	l1:Dock(TOP)
	l1:DockMargin(4, 0, 4, 4)
	l1:SizeToContents()
	local pselect = vgui.Create("DComboBox", self)
	pselect:SetValue("Wähle einen Spieler aus")
	pselect:SetTall(24)
	pselect:Dock(TOP)
	self.playerselect = pselect
	self:FillPlayers()
	local l2 = vgui.Create("DLabel", self)
	l2:SetText(PS.Config.PointsName.." angeben:")
	l2:Dock(TOP)
	l2:DockMargin(4, 2, 4, 4)
	l2:SizeToContents()
	local pointsselector = vgui.Create("DNumberWang", self)
	pointsselector:SetTextColor(Color(0, 0, 0, 255))
	pointsselector:SetTall(24)
	pointsselector:Dock(TOP)
	self.pselector = pointsselector
	local btnlist = vgui.Create("DPanel", self)
	btnlist:SetDrawBackground(false)
	btnlist:DockMargin(0, 5, 0, 0)
	btnlist:Dock(BOTTOM)
	local cancel = vgui.Create("PS_DSWButton", btnlist)
	cancel:SetSize(80, 40)
	cancel:SetTexts("Abbrechen")
	cancel.Font = "PS_Treb_S18"
	cancel:DockMargin(4, 0, 0, 0)
	cancel:Dock(RIGHT)
	self.cancel = cancel
	local done = vgui.Create("PS_DSWButton", btnlist)
	self.done = done
	self.done.BoarderCol = Color(100, 100, 100, 255)
	self.done.TextCol = Color(100, 100, 100, 255)
	done:SetSize(80, 40)
	done:SetTexts("Bestätigen")
	done.Font = "PS_Treb_S18"
	done:SetDisabled(true)
	done:DockMargin(0, 0, 4, 0)
	done:Dock(RIGHT)
	self.submit = done
	self.selected_uid = nil
	pselect.OnSelect = function(s, idx, val, data)
		if data then
			self.selected_uid = data
		end
		self:Update()
	end
	pointsselector.OnValueChanged = function()
		self:Update()
	end
	done.DoClick = function()
		self:Submit()
		self:Close()
	end
	cancel.DoClick = function()
		self:Close()
	end
	self:Center()
	self:MakePopup()
	PS_GiveMenuPanel = self
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(PS.Style_Config.BGCol.GP_BodyBG)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(PS.Style_Config.Col.PG.Main_Outline)
	surface.DrawRect(0, 0, w, 1)
	surface.DrawRect(0, h - 1, w, 1)
	surface.DrawRect(0, 0, 1, h)
	surface.DrawRect(w - 1, 0, 1, h)
end

function PANEL:FillPlayers()
	local local_ply = LocalPlayer()
	local cnt = 0
	for _, ply in ipairs(player.GetAll()) do
		if local_ply == ply then continue end
		self.playerselect:AddChoice(ply:Name(), ply:EntIndex())
		cnt = cnt + 1
	end
	if cnt == 0 then
		self.playerselect:AddChoice("Niemand verfügbar!")
	end
end

function PANEL:Submit()
	local other
	for _, ply in ipairs(player.GetAll()) do
		if tonumber(ply:EntIndex()) == tonumber(self.selected_uid) then
			other = ply
			break
		end
	end
	if !other then return end
	net.Start("PS_GiftPoints")
		net.WriteEntity(other)
		net.WriteUInt(tonumber(self.pselector:GetValue()), 32)
	net.SendToServer()
end

function PANEL:Update()
	local disabled = false
	if !self.selected_uid then
		disabled = true
	end
	if (self.pselector:GetValue() == 0) or (self.pselector:GetValue() > LocalPlayer():PS_GetPoints()) then
		disabled = true
		self.pselector:SetTextColor(Color(180, 0, 0, 255))
	else
		self.pselector:SetTextColor(Color(0, 0, 0, 255))
	end
	self.submit:SetDisabled(disabled)
	self.done.BoarderCol = disabled and Color(100, 100, 100, 255) or PS.Style_Config.Col.MN.DSWBoarderCol
	self.done.TextCol = disabled and Color(100, 100, 100, 255) or PS.Style_Config.Col.MN.DSWBoarderCol
end

vgui.Register("DPointShopGivePoints", PANEL, "DFrame")