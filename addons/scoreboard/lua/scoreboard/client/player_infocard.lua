include("admin_buttons.lua")
include("vote_button.lua")

surface.CreateFont("scoreboard_cardinfo", {font = "Verdana", size = 12, weight = 0, antialiasing = true})

local PANEL = {}
function PANEL:Init()
	self.InfoLabels = {}
	self.InfoLabels[1] = {}
	self.InfoLabels[2] = {}
	self.InfoLabels[3] = {}
	self.btnUTime = vgui.Create("Scoreboard_UTimeButton", self)
	self.btnStats = vgui.Create("Scoreboard_StatsButton", self)
	self.btnKick = vgui.Create("Scoreboard_KickButton", self)
	self.btnBan = vgui.Create("Scoreboard_BanButton", self)
	self.VoteButtons = {}
	self.VoteButtons[1] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[1]:SetUp("icon16/emoticon_smile", "smile", "Ich mag diesen Spieler.")
	self.VoteButtons[2] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[2]:SetUp("icon16/heart", "love", "Ich liebe diesen Spieler.")
	self.VoteButtons[3] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[3]:SetUp("icon16/palette", "artistic", "Dieser Spieler ist ein Künstler.")
	self.VoteButtons[4] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[4]:SetUp("icon16/star", "gold_star", "Wow! Hier ein Goldstern für dich.")
	self.VoteButtons[5] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[5]:SetUp("icon16/wrench", "builder", "Dieser Spieler ist gut im Bauen.")
	self.VoteButtons[6] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[6]:SetUp("games/16/garrysmod", "god", "Du bist mein Gott.")
	self.VoteButtons[7] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[7]:SetUp("icon16/newspaper", "stunter", "Dieser Spieler kann atemberaubende Stunts durchführen.")
	self.VoteButtons[8] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[8]:SetUp("icon16/flag_blue", "flying", "Dieser Spieler ist gut im Fliegen.")
	self.VoteButtons[9] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[9]:SetUp("icon16/car", "driving", "Dieser Spieler ist gut im Fahren.")
	self.VoteButtons[10] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[10]:SetUp("icon16/weather_rain", "toxic", "Dieser Spieler ist toxisch.")
	self.VoteButtons[11] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[11]:SetUp("icon16/rainbow", "gay", "Dieser Spieler ist schwul.")
	self.VoteButtons[12] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[12]:SetUp("icon16/money_dollar", "rich", "Dieser Spieler ist reich.")
	self.VoteButtons[13] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[13]:SetUp("icon16/emoticon_grin", "friendly", "Dieser Spieler ist sehr freundlich.")
	self.VoteButtons[14] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[14]:SetUp("icon16/information", "informative", "Dieser Spieler ist sehr informativ.")
	self.VoteButtons[15] = vgui.Create("Scoreboard_MenuVoteButton", self)
	self.VoteButtons[15]:SetUp("icon16/emoticon_happy", "lol", "Dieser Spieler ist witzig.")
end

function PANEL:SetInfo(column, k, v)
	if !v or v == "" then
		v = "N/A"
	end
	local column_ind = self.InfoLabels[column][k]
	if !column_ind then	
		self.InfoLabels[column][k] = {}
		column_ind = self.InfoLabels[column][k]
		column_ind.Key = vgui.Create("DLabel", self)
		column_ind.Value = vgui.Create("DLabel", self)
		column_ind.Key:SetText(k)
		column_ind.Key:SetColor(Color(0, 0, 0, 255))
		column_ind.Key:SetFont("scoreboard_cardinfo")
		self:InvalidateLayout()	
	end
	column_ind.Value:SetText(v)
	column_ind.Value:SetColor(Color(0, 0, 0, 255))
	column_ind.Value:SetFont("scoreboard_cardinfo")
	return true
end

function PANEL:SetPlayer(ply)
	self.Player = ply
	self:UpdatePlayerData()
end

function PANEL:UpdatePlayerData()
	local ply = self.Player
	if !IsValid(ply) then return end
	self:SetInfo(1, "Props:", ply:GetCount("props"))
	self:SetInfo(1, "Hoverballs:", ply:GetCount("hoverballs"))
	self:SetInfo(1, "Antriebe:", ply:GetCount("thrusters"))
	self:SetInfo(1, "Balloons:", ply:GetCount("balloons"))
	self:SetInfo(1, "Knöpfe:", ply:GetCount("buttons"))
	self:SetInfo(1, "Dynamit:", ply:GetCount("dynamite"))
	self:SetInfo(1, "Entities:", ply:GetCount("sents"))
	self:SetInfo(2, "Ragdolls:", ply:GetCount("ragdolls"))
	self:SetInfo(2, "Effekte:", ply:GetCount("effects"))
	self:SetInfo(2, "Autos:", ply:GetCount("vehicles"))
	self:SetInfo(2, "NPCs:", ply:GetCount("npcs"))
	self:SetInfo(2, "Emitter:", ply:GetCount("emitters"))
	self:SetInfo(2, "Lampen:", ply:GetCount("lamps"))
	self:SetInfo(2, "Keypads:", ply:GetCount("keypads"))
	self:InvalidateLayout()
end

function PANEL:ApplySchemeSettings()
	for _,column in pairs(self.InfoLabels) do
		for _,v in pairs(column) do
			v.Key:SetFGColor(50, 50, 50, 255)
			v.Value:SetFGColor(80, 80, 80, 255)
		end
	end
end

function PANEL:Think()
	if (self.PlayerUpdate or 0) > CurTime() then return end
	self.PlayerUpdate = CurTime() + 0.25
	self:UpdatePlayerData()
end

function PANEL:PerformLayout()
	local x = 5
	for _,column in pairs(self.InfoLabels) do
		local y = 0
		local RightMost = 0
		for _,v in pairs(column) do
			v.Key:SetPos(x, y)
			v.Key:SizeToContents()
			v.Value:SetPos(x + 60 , y)
			v.Value:SizeToContents()
			y = y + v.Key:GetTall() + 2
			RightMost = math.max(RightMost, v.Value.x + v.Value:GetWide())
		end
		if x < 100 then
			x = x + 205
		else
			x = x + 115
		end
	end
	local wide = self:GetWide()
	self.btnUTime:SetPos(wide - 225, 63)
	self.btnUTime:SetSize(46, 20)
	self.btnUTime.DoClick = function()
		Scoreboard.OpenUTime(self.Player)
	end
	self.btnStats:SetPos(wide - 225, 85)
	self.btnStats:SetSize(46, 20)
	self.btnStats.DoClick = function()
		Scoreboard.OpenStats(self.Player)
	end
	if !LocalPlayer():IsAdmin() then
		self.btnKick:SetVisible(false)
		self.btnBan:SetVisible(false)
	else
		self.btnKick:SetVisible(true)
		self.btnBan:SetVisible(true)
		self.btnKick:SetPos(wide - 175, 63)
		self.btnKick:SetSize(46, 20)
		self.btnBan:SetPos(wide - 175, 85)
		self.btnBan:SetSize(46, 20)
		self.btnKick.DoClick = function()
			Scoreboard.Kick(self.Player)
		end
		self.btnBan.DoClick = function()
			Scoreboard.Ban(self.Player)
		end		
	end
	for k,v in ipairs(self.VoteButtons) do
		v:InvalidateLayout()
		if k < 6 then
			v:SetPos(wide - k * 25, 0)
		elseif k < 11 then
			v:SetPos(wide - (k - 5) * 25, 36)
		else
			v:SetPos(wide - (k - 10) * 25, 72)
		end
		v:SetSize(20, 32)
	end
end

function PANEL:Paint(w,h)
	return true
end
vgui.Register("Scoreboard_PlayerInfoCard", PANEL, "Panel")