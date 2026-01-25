include("player_row.lua")
include("player_frame.lua")

surface.CreateFont("scoreboard_header", {font = "coolvetica", size = 28, weight = 100, antialiasing = true})
surface.CreateFont("scoreboard_subtitle", {font = "coolvetica", size = 20, weight = 100, antialiasing = true})
surface.CreateFont("scoreboard_logotext", {font = "coolvetica", size = 75, weight = 100, antialiasing = true})
surface.CreateFont("scoreboard_sctext", {font = "Verdana", size = 12, weight = 100, antialiasing = true})
surface.CreateFont("scoreboard_playername", {font = "Verdana", size = 16, weight = 5, antialiasing = true})
surface.CreateFont("scoreboard_adminbutton", {font = "Verdana", size = 12, weight = 1000, antialiasing = true})

local local_ply
local PANEL = {}
function PANEL:Init()
	Scoreboard.vgui = self
	self.HostName = vgui.Create("DLabel", self)
	self.HostName:SetText(GetHostName())
	self.GModLogo = vgui.Create("DLabel", self)
	self.GModLogo:SetText("g")
	self.Scoreboard = vgui.Create("DLabel", self)
	self.Scoreboard:SetText("Build & Fight")
	self.Scoreboard:SetCursor("hand")
	self.Description = vgui.Create("DLabel", self)
	self.Description:SetText(GAMEMODE.Name)
	self.PlayerFrame = vgui.Create("DScrollPanel", self)
	self.PlayerFrame:GetVBar().Paint = function(self)
	end
	self.PlayerFrame:GetVBar().btnGrip.Paint = function(self)
		draw.RoundedBox(0, 0, 1, self:GetWide(), self:GetTall() - 2, Color(150, 150, 150, 255))
	end
	self.PlayerFrame:GetVBar().btnUp.Paint = function(self)
	end
	self.PlayerFrame:GetVBar().btnDown.Paint = function(self)
	end
	self.PlayerFrame:GetVBar():SetWide(5)
	self.PlayerRows = {}
	self.lblPing = vgui.Create("DLabel", self)
	self.lblPing:SetText("Ping")
	self.lblKills = vgui.Create("DLabel", self)
	self.lblKills:SetText("Kills")
	self.lblDeaths = vgui.Create("DLabel", self)
	self.lblDeaths:SetText("Tode")
	self.lblRatio = vgui.Create("DLabel", self)
	self.lblRatio:SetText("K/D")
	self.lblHealth = vgui.Create("DLabel", self)
	self.lblHealth:SetText("Leben")
	self.lblRank = vgui.Create("DLabel", self)
	self.lblRank:SetText("Rang")
	self.lblClass = vgui.Create("DLabel", self)
	self.lblClass:SetText("Klasse")
	self.lblMute = vgui.Create("DImageButton", self)

	local_ply = local_ply or LocalPlayer()
	self:UpdateScoreboard()
	self:UpdatePlayerList()
end

function PANEL:AddPlayerRow(ply)
	local button = vgui.Create("Scoreboard_PlayerRow", self.PlayerFrame:GetCanvas())
	button:SetPlayer(ply)
	self.PlayerRows[ply] = button
end

function PANEL:GetPlayerRow(ply)
	return self.PlayerRows[ply]
end

local texGradient = surface.GetTextureID("gui/center_gradient")
local tColorGradientR
local tColorGradientG
local tColorGradientB
function PANEL:Paint(w, h)
	draw.RoundedBox(10, 0, 0, w, h, Color(50, 50, 50, 205))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(100, 100, 100, 155)
	surface.DrawTexturedRect(0, 0, w, h)
	draw.RoundedBox(6, 15, self.Description.y - 8, w - 30, h - self.Description.y - 6, Color(230, 230, 230, 100))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(255, 255, 255, 50)
	surface.DrawTexturedRect(15, self.Description.y - 8, w - 30, h - self.Description.y - 8)
	draw.RoundedBox(6, 108, self.Description.y - 4, w - 128, self.Description:GetTall() + 8, Color(100, 100, 100, 155))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(255, 255, 255, 50)
	surface.DrawTexturedRect(108, self.Description.y - 4, w - 128, self.Description:GetTall() + 8)
	if Scoreboard.PlayerColor.r < 255 then
		tColorGradientR = Scoreboard.PlayerColor.r + 15
	else
		tColorGradientR = Scoreboard.PlayerColor.r
	end
	if Scoreboard.PlayerColor.g < 255 then
		tColorGradientG = Scoreboard.PlayerColor.g + 15
	else
		tColorGradientG = Scoreboard.PlayerColor.g
	end
	if Scoreboard.PlayerColor.b < 255 then
		tColorGradientB = Scoreboard.PlayerColor.b + 15
	else
		tColorGradientB = Scoreboard.PlayerColor.b
	end
	draw.RoundedBox(8, 24, 12, 80, 80, Color(Scoreboard.PlayerColor.r, Scoreboard.PlayerColor.g, Scoreboard.PlayerColor.b, 255))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(tColorGradientR, tColorGradientG, tColorGradientB, 225)
	surface.DrawTexturedRect(24, 12, 80, 80)
end

local column_size = 45
function PANEL:PerformLayout()
	self:SetSize(ScrW() * 0.75, ScrH() * 0.65)
	local wide = self:GetWide()
	local tall = self:GetTall()
	self:SetPos((ScrW() - wide) / 2, (ScrH() - tall) / 2)
	self.HostName:SizeToContents()
	self.HostName:SetPos(115, 17)
	self.GModLogo:SetSize(80, 80)
	self.GModLogo:SetPos(45, 5)
	self.GModLogo:SetColor(Color(30, 30, 30, 255))
	self.Scoreboard:SetSize(200, 15)
	self.Scoreboard:SetPos((wide - 200), (tall - 15))
	self.Description:SizeToContents()
	self.Description:SetPos(115, 60)
	self.Description:SetColor(Color(30, 30, 30, 255))
	self.PlayerFrame:SetPos(5, self.Description.y + self.Description:GetTall() + 20)
	self.PlayerFrame:SetSize(wide - 10, tall - self.PlayerFrame.y - 20)
	local PlayerSorted = {}
	for _, v in pairs(self.PlayerRows) do
		if !IsValid(v) then continue end
		table.insert(PlayerSorted, v)
	end
	table.sort(PlayerSorted, function(a , b) return a:HigherOrLower(b) end)
	local y = 0
	for _,v in ipairs(PlayerSorted) do
		v:SetPos(0, y)
		local v_tall = v:GetTall()
		v:SetSize(self.PlayerFrame:GetWide(), v_tall)
		self.PlayerFrame:GetCanvas():SetSize(self.PlayerFrame:GetCanvas():GetWide(), y + v_tall)
		y = y + v_tall + 1
	end
	self.HostName:SetText(GetHostName())
	self.lblPing:SizeToContents()
	self.lblClass:SizeToContents()
	self.lblKills:SizeToContents()
	self.lblRatio:SizeToContents()
	self.lblDeaths:SizeToContents()
	self.lblHealth:SizeToContents()
	self.lblRank:SizeToContents()
	self.lblPing:SetPos(wide - column_size * 1.88 - self.lblPing:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3)
	self.lblRatio:SetPos(wide - column_size * 3.22 - self.lblDeaths:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3)
	self.lblClass:SetPos(wide - column_size * 8.95 - self.lblDeaths:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3)
	self.lblDeaths:SetPos(wide - column_size * 4.25 - self.lblDeaths:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3)
	self.lblKills:SetPos(wide - column_size * 5.23 - self.lblKills:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3 )
	self.lblHealth:SetPos(wide - column_size * 6.85 - self.lblKills:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3)
	self.lblRank:SetPos(wide - column_size * 11.98 - self.lblKills:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3)
end

function PANEL:ApplySchemeSettings()
	self.HostName:SetFont("scoreboard_header")
	self.Description:SetFont("scoreboard_subtitle")
	self.GModLogo:SetFont("scoreboard_logotext")
	self.Scoreboard:SetFont("scoreboard_sctext")
	self.HostName:SetFGColor(Color(0, 0, 0, 255))
	self.Description:SetFGColor(Color(55, 55, 55, 255))
	self.GModLogo:SetFGColor(Color(0, 0, 0, 255))
	self.Scoreboard:SetFGColor(Color(200, 200, 200, 200))
	self.lblPing:SetFont("scoreboard_sctext")
	self.lblClass:SetFont("scoreboard_sctext")
	self.lblKills:SetFont("scoreboard_sctext")
	self.lblDeaths:SetFont("scoreboard_sctext")
	self.lblRank:SetFont("scoreboard_sctext")
	self.lblHealth:SetFont("scoreboard_sctext")
	self.lblRatio:SetFont("scoreboard_sctext")
	self.lblPing:SetColor(Color(0, 0, 0, 255))
	self.lblClass:SetColor(Color(0, 0, 0, 255))
	self.lblKills:SetColor(Color(0, 0, 0, 255))
	self.lblDeaths:SetColor(Color(0, 0, 0, 255))
	self.lblRank:SetColor(Color(0, 0, 0, 255))
	self.lblHealth:SetColor(Color(0, 0, 0, 255))
	self.lblRatio:SetColor(Color(0, 0, 0, 255))
	self.lblPing:SetFGColor(Color(0, 0, 0, 255))
	self.lblClass:SetFGColor(Color(0, 0, 0, 255))
	self.lblKills:SetFGColor(Color(0, 0, 0, 255))
	self.lblDeaths:SetFGColor(Color(0, 0, 0, 255))
	self.lblRank:SetFGColor(Color(0, 0, 0, 255))
	self.lblHealth:SetFGColor(Color(0, 0, 0, 255))
	self.lblRatio:SetFGColor(Color(0, 0, 0, 255))
end

local plys = {}
local CurTime = CurTime
function PANEL:UpdateScoreboard(force)
	if !force and !self:IsVisible() then return false end
	for k, v in pairs(self.PlayerRows) do
		if !IsValid(k) then
			v:Remove()
			self.PlayerRows[k] = nil
			timer.Simple(0, function()
				if !IsValid(self) or !IsValid(self.PlayerFrame) then return end
				self.PlayerFrame:OnMouseWheeled(0)
			end)
		end
	end

	for _, ply in ipairs(plys) do
		local row = self:GetPlayerRow(ply)
		if !row or !row:IsValid() then
			self:AddPlayerRow(ply)
		end
	end

	self:InvalidateLayout()
end

function PANEL:UpdatePlayerList()
	plys = player.GetAll()
	local superadmin = local_ply:IsSuperAdmin()
	for k=1, #plys do
		local ply = plys[k]
		if !superadmin and ply != local_ply then
			plys[k] = nil
			local row = self:GetPlayerRow(ply)
			if row and row:IsValid() then
				row:Remove()
			end

			continue
		end
 	end

	timer.Create("MG_Scoreboard_UpdatePlayers", 1, 1, function()
		if !IsValid(self) or !self:IsVisible() then return end
		self:UpdatePlayerList()
	end)
end

function PANEL:Think()
	local_ply = local_ply or LocalPlayer()
	self:UpdateScoreboard()
	local found
	for _, ply in ipairs(player.GetAll()) do
		if !self:GetPlayerRow(ply) then
			self:AddPlayerRow(ply)
			found = true
		end
	end
	if found then
		self:InvalidateLayout()
	end
end
vgui.Register("Scoreboard", PANEL, "Panel")