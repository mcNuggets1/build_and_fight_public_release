local PANEL = {}
function PANEL:DoClick()
	local parent = self:GetParent()
	if !parent.Player or LocalPlayer() == parent.Player then return end
	self:DoCommand(parent.Player)
	Scoreboard.vgui.UpdateScoreboard()
end

function PANEL:Paint(w, h)
	local bgcolor = Color(200, 200, 200, 100)
	if self.Selected then
		bgcolor = Color(135, 135, 135, 100)
	elseif self.Armed then
		bgcolor = Color(175, 175, 175, 100)
	end
	draw.RoundedBox(4, 0, 0, w, h, bgcolor)	
	draw.SimpleText(self.Text, "scoreboard_adminbutton", w / 2, h / 2, Color(0, 0, 0, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	return true
end
vgui.Register("scoreboard_adminbutton", PANEL, "Button")

PANEL = {}
PANEL.Text = "UTime"
vgui.Register("Scoreboard_UTimeButton", PANEL, "scoreboard_adminbutton")

PANEL = {}
PANEL.Text = "Stats"
vgui.Register("Scoreboard_StatsButton", PANEL, "scoreboard_adminbutton")

PANEL = {}
PANEL.Text = "Kick"
vgui.Register("Scoreboard_KickButton", PANEL, "scoreboard_adminbutton")

PANEL = {}
PANEL.Text = "Ban"
vgui.Register("Scoreboard_BanButton", PANEL, "scoreboard_adminbutton")