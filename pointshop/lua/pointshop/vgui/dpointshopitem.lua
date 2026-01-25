local PANEL = {}

local adminicon = Material("icon16/shield.png")
local groupicon = Material("icon16/star.png")

local canbuycolor = Color(0, 100, 0, 125)
local cantbuycolor = Color(100, 0, 0, 125)
local ownedcolor = Color(0, 0, 200, 125)

function PANEL:Init()
	self.Info = ""
	self.InfoHeight = 14
	self.BGCol = PS.Style_Config.Col.IC.BackGround
end

function PANEL:DoClick()
	local ply = LocalPlayer()
	local points = PS.Config.CalculateBuyPrice(ply, self.Data)
	if !ply:PS_HasItem(self.Data.ID) and !ply:PS_HasPoints(points) then
		PS:ShowNotice("Du hast nicht genug "..PS.Config.PointsName.." um dieses Item zu kaufen!")
	end
	local menu = DermaMenu(self)
	menu:SetSkin("PS_DermaMenu")
	if ply:PS_HasItem(self.Data.ID) then
		menu:AddOption("Item verkaufen", function()
			if !self.Data or !self.Data.Name then return end
			surface.PlaySound("ui/buttonclick.wav")
			PS:ShowAsker("Bist du sicher, dass du "..self.Data.Name.." verkaufen möchtest?", function()
				if !self.Data or !self.Data.ID then return end
				ply:PS_SellItem(self.Data.ID)
			end)
		end):SetIcon("icon16/money.png")
	elseif ply:PS_HasPoints(points) then
		menu:AddOption("Item kaufen", function()
			if !self.Data or !self.Data.Name then return end
			surface.PlaySound("ui/buttonclick.wav")
			PS:ShowAsker("Bist du sicher, dass du "..self.Data.Name.." kaufen möchtest?", function()
				if !self.Data or !self.Data.ID then return end
				ply:PS_BuyItem(self.Data.ID)
			end)
		end):SetIcon("icon16/cart.png")
	end
	if ply:PS_HasItem(self.Data.ID) then
		menu:AddSpacer()
		if ply:PS_HasItemEquipped(self.Data.ID) then
			menu:AddOption("Item ablegen", function()
				if !self.Data or !self.Data.ID then return end
				surface.PlaySound("ui/buttonclick.wav")
				ply:PS_HolsterItem(self.Data.ID)
			end):SetIcon("icon16/delete.png")
		else
			menu:AddOption("Item ausrüsten", function()
				if !self.Data or !self.Data.ID then return end
				surface.PlaySound("ui/buttonclick.wav")
				ply:PS_EquipItem(self.Data.ID)
			end):SetIcon("icon16/add.png")
		end
		if self.Data.Modify then
			menu:AddSpacer()
			menu:AddOption("Item modifizieren...", function()
				if !self.Data or !self.Data.ID then return end
				surface.PlaySound("ui/buttonclick.wav")
				PS.Items[self.Data.ID]:Modify(ply.PS_Items[self.Data.ID].Modifiers)
			end):SetIcon("icon16/wrench.png")
		end
	end
	menu:Open()
end

function PANEL:SetData(data)
	self.Data = data
	self.Info = data.Name
	if data.Model then
		local DModelPanel = vgui.Create("DModelPanel", self)
		DModelPanel:SetModel(data.Model)
		DModelPanel:Dock(FILL)
		if data.Skin then
			DModelPanel:SetSkin(data.Skin)
		end
		if !IsValid(DModelPanel.Entity) then return end
		local PrevMins, PrevMaxs = DModelPanel.Entity:GetRenderBounds()
		DModelPanel:SetCamPos(isfunction(data.ModelCamPos) and data.ModelCamPos(PrevMins, PrevMaxs) or PrevMins:Distance(PrevMaxs) * Vector(data.ModelCamPosX or 0.5, data.ModelCamPosY or 0.5, data.ModelCamPosZ or 0.5))
		DModelPanel:SetLookAt(isfunction(data.ModelLookAt) and data.ModelLookAt(PrevMins, PrevMaxs) or (PrevMaxs + PrevMins) / 2)

		function DModelPanel:LayoutEntity(ent)
			if isfunction(data.ModelImageCustomLayout) then return data.ModelImageCustomLayout(self, ent) end
			if self:GetParent().Hovered then
				if !data.ModelImageDisableSpin then
					local angles = ent:GetAngles()
					ent:SetAngles(Angle(data.ModelImageSpinPitch or angles.p, data.ModelImageSpinYaw or angles.y + (FrameTime() * (data.ModelImageSpinSpeed or 250)), data.ModelImageSpinRoll or angles.r))
				end
			else
				local angles = ent:GetAngles()
				ent:SetAngles(Angle(data.ModelImageSpinPitch or angles.p, data.ModelImageSpinYaw or angles.y, data.ModelImageSpinRoll or angles.r))
			end
			if !data.ModelImageIgnoreModification then
				data:ModifyClientsideModel(self.Entity, ent, Vector(), Angle(), self)
			end
			if !data.ModelImageKeepSize then
				local size = Vector(1, 1, 1)
				if data.ModelImageSize then
					size = data.ModelImageSize
				end
				local mat = Matrix()
				mat:Scale(size)
				ent:EnableMatrix("RenderMultiply", mat)
			end
			if !data.ModelImageIgnoreModification then
				data:PostModifyClientsideModel(self.Entity, ent, Vector(), Angle(), self)
			end
		end

		if data.ModelImageColor then
			DModelPanel:SetColor(data.ModelImageColor)
		end

		function DModelPanel:DoClick()
			self:GetParent():DoClick()
		end

		function DModelPanel:OnCursorEntered()
			self:GetParent():OnCursorEntered()
		end

		function DModelPanel:OnCursorExited()
			self:GetParent():OnCursorExited()
		end
	else
		local DImageButton = vgui.Create("DImageButton", self)
		DImageButton:SetMaterial(data.Material)
		DImageButton:Dock(FILL)

		function DImageButton:DoClick()
			self:GetParent():DoClick()
		end

		function DImageButton:OnCursorEntered()
			self:GetParent():OnCursorEntered()
		end

		function DImageButton:OnCursorExited()
			self:GetParent():OnCursorExited()
		end
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.BGCol)
	surface.DrawRect(0, 0, w, h)
end

function PANEL:PaintOver(w, h)
	local ply = LocalPlayer()
	if self.Data.AdminOnly then
		surface.SetMaterial(adminicon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(5, 5, 16, 16)
	end
	if self.Data.AllowedUserGroups and #self.Data.AllowedUserGroups > 0 then
		surface.SetMaterial(groupicon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(5, h - self.InfoHeight - 5 - 16, 16, 16)
	end
end

function PANEL:OnCursorEntered()
	self.Hovered = true
	PS:SetHoverItem(self.Data.ID)
end

function PANEL:OnCursorExited()
	self.Hovered = false
	PS:RemoveHoverItem()
end

vgui.Register("DPointShopItem", PANEL, "DPanel")