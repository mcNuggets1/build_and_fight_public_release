local SKIN = {}
local function surface_DrawBolder(x, y, w, h, w2)
	surface.DrawRect(x, y, w, w2)
	surface.DrawRect(x, h - w2, w, w2)
	surface.DrawRect(x, y, w2, h)
	surface.DrawRect(w - w2, y, w2, h)
end

local function surface_DrawOutlinedBox(x, y, w, h, col, bordercol, thickness)
	surface.SetDrawColor(col)
	surface.DrawRect(x + 1, y + 1, w - 2, h - 2)
	surface.SetDrawColor(bordercol)
	surface_DrawBolder(x, y, w, h, thickness or 1)
end

function SKIN:PaintMenu()
end

function SKIN:PaintMenuOption(self, w, h)
	if !self.FontSet then
		self:SetFont("PS_Treb_S20")
		self:SetTextInset(5, 0)
		self.FontSet = true
	end
	self:SetTextColor(color_white)
	surface_DrawOutlinedBox(0, 0, w, h, PS.Style_Config.BGCol.CC_Canvas, PS.Style_Config.Col.MN.DSWBoarderCol)
	if self.m_bBackground and (self:IsHovered() or self.Highlight) then
		local col = Color(PS.Style_Config.Col.MN.DSWBoarderCol.r, PS.Style_Config.Col.MN.DSWBoarderCol.g, PS.Style_Config.Col.MN.DSWBoarderCol.b, PS.Style_Config.Col.MN.DSWBoarderCol.a or 255)
		col.a = 25
		surface_DrawOutlinedBox(0, 0, w, h, col, PS.Style_Config.Col.MN.DSWBoarderCol)
	end
end

derma.DefineSkin("PS_DermaMenu", "PointShop DermaMenu Skin", SKIN)