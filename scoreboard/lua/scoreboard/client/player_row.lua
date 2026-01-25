include("player_infocard.lua")

local texGradient = surface.GetTextureID("gui/center_gradient")
local PANEL = {}
function PANEL:Paint(w, h)
	local color = Color(100, 100, 100, 255)
	if self.Selected then
		color = Color(125, 125, 125, 255)
	elseif self.Armed then
		color = Color(125, 125, 125, 255)
	end
	local ply = self.Player
	if IsValid(ply) then
		local is_builder = ply.IsBuilder and ply:IsBuilder()
		local is_fighter = ply.IsFighter and ply:IsFighter()
		if ply == LocalPlayer() and is_builder then
			color = Color(0, 0, 255, 255)
		elseif ply == LocalPlayer() and is_fighter then
			color = Color(255, 0, 0, 255)
		elseif is_builder then
			color = Color(0, 0, 200, 255)
		elseif is_fighter then
			color = Color(200, 0, 0, 255)
		else
			color = Color(255, 255, 100, 255)
		end
	end
	if self.Open or self.Size != self.TargetSize then
		draw.RoundedBox(4, 18, 16, w - 36, h - 16, color)
		draw.RoundedBox(4, 20, 16, w - 40, h - 18, Color(225, 225, 225, 150))
		surface.SetTexture(texGradient)
		surface.SetDrawColor(255, 255, 255, 100)
		surface.DrawTexturedRect(20, 16, w - 40, h - 18)
	end
	draw.RoundedBox(4, 18, 0, w - 36, 38, color)
	surface.SetTexture(texGradient)
	surface.SetDrawColor(255, 255, 255, 150)
	surface.DrawTexturedRect(0, 0, w - 36, 38)
	return true
end

function PANEL:SetPlayer(ply)
	self.Player = ply
	self.InfoCard:SetPlayer(ply)
	self:UpdatePlayerData()
	self.ImageAvatar:SetPlayer(ply)
end

function PANEL:UpdatePlayerData()
	local ply = self.Player
	if !IsValid(ply) then return false end
	self.lblName:SetText(ply:Name())
	local group = ply:GetUserGroup()
	if !group or group == "" then
		group = "BOT"
	end
	self.lblRank:SetText(group)
	self.lblHealth:SetText(math.max(ply:Health(), 0))
	self.lblFrags:SetText(ply:Frags())
	self.lblClass:SetText(team.GetName(ply:Team()) or "XXX")
	self.lblDeaths:SetText(ply:Deaths())
	self.lblPing:SetText(ply:Ping())
	if (!self.Muted or self.Muted != ply:IsMuted()) then
		self.Muted = ply:IsMuted()
		if self.Muted then
			self.lblMute:SetImage("icon32/muted.png")
		else
			self.lblMute:SetImage("icon32/unmuted.png")
		end
		self.lblMute.DoClick = function()
			ply:SetMuted(!self.Muted)
		end
	end	
	local k = ply:Frags()
	local d = ply:Deaths()
	local kdr = math.Round(math.max(1, k) / math.max(1, d), 2)
	if k == 0 then
		kdr = "0"
	end
	self.lblRatio:SetText(kdr)
	self.lblName:SizeToContents()
	self.lblRank:SizeToContents()
	self.lblClass:SizeToContents()
end

function PANEL:Init()
	self.Size = 38
	self:OpenInfo(false)	
	self.InfoCard = vgui.Create("Scoreboard_PlayerInfoCard", self)
	self.lblName = vgui.Create("DLabel", self)
	self.lblRank = vgui.Create("DLabel", self)
	self.lblHealth = vgui.Create("DLabel", self)
	self.lblFrags = vgui.Create("DLabel", self)
	self.lblClass = vgui.Create("DLabel", self)
	self.lblDeaths = vgui.Create("DLabel", self)
	self.lblRatio = vgui.Create("DLabel", self)
	self.lblPing = vgui.Create("DLabel", self)
	self.lblMute = vgui.Create("DImageButton", self)
	self.ImageAvatar = vgui.Create("AvatarImage", self)
	self.lblAvatarFix = vgui.Create("DLabel", self)
	self.lblAvatarFix:SetText("")
	self.lblAvatarFix:SetCursor("hand")
	self.lblAvatarFix.DoClick = function()
		self.Player:ShowProfile()
	end
	self.lblName:SetMouseInputEnabled(false)
	self.lblRank:SetMouseInputEnabled(false)
	self.lblHealth:SetMouseInputEnabled(false)
	self.lblFrags:SetMouseInputEnabled(false)
	self.lblClass:SetMouseInputEnabled(false)
	self.lblDeaths:SetMouseInputEnabled(false)
	self.lblRatio:SetMouseInputEnabled(false)
	self.lblPing:SetMouseInputEnabled(false)
	self.ImageAvatar:SetMouseInputEnabled(false)
	self.lblMute:SetMouseInputEnabled(true)
	self.lblAvatarFix:SetMouseInputEnabled(true)
end

function PANEL:ApplySchemeSettings()
	self.lblName:SetFont("scoreboard_playername")
	self.lblRank:SetFont("scoreboard_playername")
	self.lblHealth:SetFont("scoreboard_playername")
	self.lblFrags:SetFont("scoreboard_playername")
	self.lblClass:SetFont("scoreboard_playername")
	self.lblDeaths:SetFont("scoreboard_playername")
	self.lblRatio:SetFont("scoreboard_playername")
	self.lblPing:SetFont("scoreboard_playername")
	self.lblAvatarFix:SetFont("scoreboard_playername")
	self.lblName:SetColor(color_black)
	self.lblRank:SetColor(color_black)
	self.lblHealth:SetColor(color_black)
	self.lblFrags:SetColor(color_black)
	self.lblClass:SetColor(color_black)
	self.lblDeaths:SetColor(color_black)
	self.lblRatio:SetColor(color_black)
	self.lblPing:SetColor(color_black)
	self.lblAvatarFix:SetColor(color_black)
	self.lblName:SetFGColor(color_black)
	self.lblRank:SetFGColor(color_black)
	self.lblHealth:SetFGColor(color_black)
	self.lblFrags:SetFGColor(color_black)
	self.lblClass:SetFGColor(color_black)
	self.lblDeaths:SetFGColor(color_black)
	self.lblRatio:SetFGColor(color_black)
	self.lblPing:SetFGColor(color_black)
	self.lblAvatarFix:SetFGColor(Color(0, 0, 0, 0))
end

function PANEL:DoClick()
	if self.Open then
		surface.PlaySound("ui/buttonclickrelease.wav")
	else
		surface.PlaySound("ui/buttonclick.wav")
	end
	self:OpenInfo(!self.Open)
end

function PANEL:OpenInfo(bool)
	if bool then
		self.TargetSize = 154
	else
		self.TargetSize = 38
	end
	self.Open = bool
end

function PANEL:Think()
	local cur_time = CurTime()
	if self.Size != self.TargetSize then
		if (self.LastThink or 0) <= cur_time then
			self.Size = self.TargetSize
		else
			self.Size = math.Approach(self.Size, self.TargetSize, (math.abs(self.Size - self.TargetSize) + 1) * 10 * FrameTime())
		end
		self:PerformLayout()
		Scoreboard.vgui:InvalidateLayout()
	end
	self.LastThink = cur_time + 0.2
	if (self.PlayerUpdate or 0) < cur_time then	
		self.PlayerUpdate = cur_time + 0.1
		self:UpdatePlayerData()
	end
end

local column_size = 45
function PANEL:PerformLayout()
	local wide = self:GetWide()
	self:SetSize(wide, self.Size)
	self.lblName:SetPos(60, 3)
	self.lblMute:SetSize(32, 32)
	self.ImageAvatar:SetPos(21, 3)
 	self.ImageAvatar:SetSize(32, 32)
 	self.lblAvatarFix:SetPos(21, 3)
 	self.lblAvatarFix:SetSize(32, 32)
	self.lblMute:SetPos(wide - column_size - 8, 0)
	self.lblPing:SetPos(wide - column_size * 2, 0)
	self.lblRatio:SetPos(wide - column_size * 3.4, 0)
	self.lblClass:SetPos(wide - column_size * 9.15, 2)
	self.lblDeaths:SetPos(wide - column_size * 4.4, 0)
	self.lblFrags:SetPos(wide - column_size * 5.4, 0)
	self.lblHealth:SetPos(wide - column_size * 7, 0)
	self.lblRank:SetPos(wide - column_size * 12.15, 2)
	if self.Open or self.Size != self.TargetSize then
		self.InfoCard:SetVisible(true)
		self.InfoCard:SetPos(18, self.lblName:GetTall() + 27)
		self.InfoCard:SetSize(wide - 36, self:GetTall() - self.lblName:GetTall() + 5)
	else
		self.InfoCard:SetVisible(false)
	end
end

function PANEL:HigherOrLower(row)
	local ply = self.Player
	if !IsValid(ply) or !row or !row.Player then return false end
	local row_ply = row.Player
	if !IsValid(row_ply) then return false end
	local tm = ply:Team()
	if tm == TEAM_CONNECTING or tm == TEAM_UNASSIGNED then return false end
	local row_ply_tm = row_ply:Team()
	if tm != row_ply_tm then
		return tm < row_ply_tm
	end
	if ply:Frags() == row_ply:Frags() then
		return ply:Deaths() < row_ply:Deaths()
	end
	return ply:Frags() > row_ply:Frags()
end
vgui.Register("Scoreboard_PlayerRow", PANEL, "Button")