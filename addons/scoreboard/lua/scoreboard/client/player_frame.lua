local PANEL = {}
function PANEL:Init()
	self.pnlCanvas = vgui.Create("Panel", self)
	self.YOffset = 0
end

function PANEL:GetCanvas()
	return self.pnlCanvas
end

function PANEL:OnMouseWheeled(delta)
	local maxoffset = self.pnlCanvas:GetTall() - self:GetTall()
	if maxoffset > 0 then
		self.YOffset = math.Clamp(self.YOffset + delta * -100, 0, maxoffset)	
	else
		self.YOffset = 0
	end
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	self.pnlCanvas:SetPos(0, self.YOffset * -1)
	self.pnlCanvas:SetSize(self:GetWide(), self.pnlCanvas:GetTall())
end
vgui.Register("Scoreboard_PlayerFrame", PANEL, "Panel")