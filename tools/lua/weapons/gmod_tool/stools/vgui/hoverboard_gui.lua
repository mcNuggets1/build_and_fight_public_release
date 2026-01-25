function PANEL:Init()
	self.Attributes = {}
	self.BoardSelect = vgui.Create("PropSelect", self)
	self.BoardSelect:SetConVar("hoverboard_model")
	self.BoardSelect.Label:SetText("Modell auswählen")
	self:AddAttribute("Geschwindigkeit", "Speed")
	self:AddAttribute("Sprungkraft", "Jump")
	self:AddAttribute("Drehgeschw..", "Turn")
	self:AddAttribute("Flipgeschw.", "Flip")
	self:AddAttribute("Twistgeschw.", "Twist")
end

function PANEL:PerformLayout()
	local vspacing = 10
	local ypos = 0
	self.BoardSelect:SetPos(0, ypos)
	self.BoardSelect:SetSize(self:GetWide(), 165)
	ypos = self.BoardSelect.Y + self.BoardSelect:GetTall() + vspacing
	for _, panel in pairs(self.Attributes) do
		panel:SetPos(0, ypos)
		panel:SetSize(self:GetWide(), panel:GetTall())
		ypos = panel.Y + panel:GetTall() + vspacing
	end
	self:SetHeight(ypos)
	self:UpdatePoints()
end

function PANEL:Think()
	if self.HoverboardTable then
		local selected = GetConVar(self.BoardSelect:ConVar()):GetString()
		if (selected != self.LastSelectedBoard) then
			self.LastSelectedBoard = selected
			for name, panel in pairs(self.Attributes) do
				panel:SetText(name)
				panel.Label:SetTextColor(panel.OldFontColor)
			end
		end
	end
end

function PANEL:PopulateBoards(tbl)
	for _, board in pairs(tbl) do
		self.BoardSelect:AddModel(board["model"])
		self.BoardSelect.Controls[#self.BoardSelect.Controls]:SetTooltip(board["name"] or "Unbekannt")
	end
	self.HoverboardTable = tbl
end

function PANEL:GetUsedPoints()
	local count = 0
	return count
end

function PANEL:UpdatePoints()
end

function PANEL:AddAttribute(name, convar)
	local panel = vgui.Create("DNumSlider", self)
	panel:SetText(name)
	panel:SetMin(4)
	panel:SetMax(16)
	panel:SetDark(true)
	panel:SetDecimals(0)
	panel:SetConVar(("hoverboard_%s"):format(convar:lower()))
	panel.Attribute = name:lower()
	panel.OnValueChanged = function(slider, val)
		val = math.Clamp(tonumber(val), 0, 16)
		slider:SetValue(val)
	end
	panel.OldFontColor = panel.Label:GetTextColor()
	self.Attributes[name] = panel
end