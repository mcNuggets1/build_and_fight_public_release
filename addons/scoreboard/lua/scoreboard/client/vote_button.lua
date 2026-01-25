local PANEL = {}

PANEL.VoteName = "none"
PANEL.MaterialName = "icon16/exclamation"

function PANEL:Init()
	self.Label = vgui.Create("DLabel", self)
	self:ApplySchemeSettings()
	self:SetCursor("hand")
end

function PANEL:DoClick()
	local ply = self:GetParent().Player
	if !IsValid(ply) or ply == LocalPlayer() then return false end
	LocalPlayer():ConCommand("scoreboard_rateuser "..ply:EntIndex().." "..self.VoteName.."\n")
end

function PANEL:ApplySchemeSettings()
	self.Label:SetFont("scoreboard_cardinfo")
	self.Label:SetColor(Color(0, 0, 0, 255))
	self.Label:SetFGColor(0, 0, 0, 150)
	self.Label:SetMouseInputEnabled(false)
end

function PANEL:PerformLayout()
	local parent = self:GetParent()
	if IsValid(parent.Player) then
		self.Label:SetText(parent.Player:GetNWInt("Rating_"..self.VoteName, 0))
	end
	self.Label:SizeToContents()
	self.Label:SetPos((self:GetWide() - self.Label:GetWide()) / 2, self:GetTall() - self.Label:GetTall())
end

function PANEL:SetUp(mat, votename, nicename)
	self.MaterialName = mat
	self.VoteName = votename
	self.NiceName = nicename
	self:SetTooltip(self.NiceName)
end

function PANEL:Paint(w, h)
	if !self.Material then
		self.Material = Material(self.MaterialName..".png")
	end
	draw.RoundedBox(4, 0, 0, w, h, Color(200, 200, 200, 100))
	surface.SetMaterial(self.Material)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(w / 2 - 8, w / 2 - 8, 16, 16)
	return true
end
vgui.Register("Scoreboard_MenuVoteButton", PANEL, "Button")