local PS_Fonts = {
	["PS_Treb"] = system.IsWindows() and "Trebuchet MS" or "Verdana"
}

for a, b in pairs(PS_Fonts) do
	for k = 10, 100 do
		surface.CreateFont(a.."_S"..k, {font = b, size = k, weight = 700})
		surface.CreateFont(a.."Out_S"..k, {font = b, size = k, weight = 700, outline = true})
	end
end

surface.CreateFont("PS_Treb_TitlePS", {font = system.IsWindows() and "Trebuchet MS" or "Verdana", size = 200, weight = 700, outline = true})

local meta = FindMetaTable("Panel")
function meta:PS_DrawBoarder(width,col)
	width = width or 1
	col = col or PS.Style_Config.Col.MN.SCBarOutLine
	surface.SetDrawColor(col)
	surface.DrawRect(0, 0, self:GetWide(), width)
	surface.DrawRect(0, self:GetTall() - width, self:GetWide(), width)
	surface.DrawRect(0, 0, width, self:GetTall())
	surface.DrawRect(self:GetWide() - width, 0, width, self:GetTall())
end

function meta:PS_PaintListBar(bcol,icol)
	local bcol = bcol or PS.Style_Config.Col.MN.SCBarOutLine
	local icol = icol or Color(0, 0, 0, 255)
	self.VBar.btnDown.Paint = function(slf)
		surface.SetDrawColor(bcol.r, bcol.g, bcol.b, 255)
		surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
		surface.SetDrawColor(icol.r, icol.g, icol.b, 255)
		surface.DrawRect(1, 1, slf:GetWide() - 2, slf:GetTall() - 2)
	end
	self.VBar.btnUp.Paint = function(slf)
		surface.SetDrawColor(bcol.r, bcol.g, bcol.b, 255)
		surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
		surface.SetDrawColor(icol.r, icol.g, icol.b, 255)
		surface.DrawRect(1, 1, slf:GetWide() - 2, slf:GetTall() - 2)
	end
	self.VBar.btnGrip.Paint = function(slf)
		surface.SetDrawColor(bcol.r, bcol.g, bcol.b, 255)
		surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
		surface.SetDrawColor(icol.r, icol.g, icol.b, 255)
		surface.DrawRect(1, 1, slf:GetWide() - 2, slf:GetTall() - 2)
	end
	self.VBar.Paint = function()
	end
end