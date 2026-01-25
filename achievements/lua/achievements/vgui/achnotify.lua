local use_font = system.IsWindows() and "Tahoma" or "Verdana"
surface.CreateFont("achv_notify12", {font = use_font, size = 12, weight = 700, antialias = false})
surface.CreateFont("achv_notify13", {font = use_font, size = 13, weight = 700, antialias = false})
surface.CreateFont("achv_notify14", {font = use_font, size = 14, weight = 700, antialias = true})

local PANEL = {}
local Achievements = {}
function PANEL:Init()
	self.Offset = 0
	self.Direction = 1
	self.Speed = 3
	self.Slot = 1
	self.Text = ""
	self.Queried = false
end

sound.Add({
	name = "achievement_sound",
	channel = CHAN_STATIC,
	volume = 0.75,
	level = 75,
	pitch = 100,
	sound = "baf/achievement.wav",
})

function PANEL:SetAchievement(text, image)
	self.Text = text
	self.Image = image or "achievements/generic.png"
	self.Material = Material(self.Image, "unlitgeneric")
	if !self.Material then self.Image = nil end

	local slot = self:GetFreeSlot()
	if slot == 0 then
		self.Queried = true
	else
		self:SetSlot(slot)
	end
end

function PANEL:OnRemove()
	if Achievements[self.Slot] == self then
		Achievements[self.Slot] = nil
	end
end

function PANEL:GetFreeSlot()
	local i = 0
	for k=1, 4 do
		local pnl = Achievements[k]
		if pnl and pnl:IsValid() then continue end
		i = k
		break
	end

	return i
end

function PANEL:SetSlot(slot)
	LocalPlayer():EmitSound("achievement_sound")
	Achievements[slot] = self
	self.Queried = false
	self.Slot = slot
end

function PANEL:Think()
	if self.Queried then
		local slot = self:GetFreeSlot()
		if slot != 0 then
			self:SetSlot(slot)
		end
		return
	end

	local old_offset = self.Offset
	self.Offset = math.Clamp(self.Offset + (self.Direction * FrameTime() * self.Speed), 0, 1)
	if (old_offset != self.Offset) then
		self:InvalidateLayout()
	end
	if (self.Direction == 1 and self.Offset == 1) then
		self.Direction = 0
		self.Down = CurTime() + 5
	end
	if (self.Down != nil and CurTime() > self.Down) then
		self.Direction = -1
		self.Down = nil
	end
	if (self.Offset == 0) then
		self.Removed = true
		self:Remove()
	end
end

function PANEL:PerformLayout()
	local w, h = 240, 94
	self:SetSize(w, h)
	self:SetPos(ScrW() - (w * self.Offset), ScrH() - (h * self.Slot))
end

local gradient = Material("gui/gradient_down")
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	local a = self.Offset * 255
	surface.SetDrawColor(23, 22, 20, a)
	surface.DrawRect(0, 0, w, h)
	surface.SetMaterial(gradient)
	surface.SetDrawColor(255, 255, 255, a/32)
	surface.DrawTexturedRect(0, 0, w, h)
	surface.SetDrawColor(26, 26, 26, a)
	surface.DrawOutlinedRect(0, 0, w+1, h+1)
	surface.SetDrawColor(255, 255, 255, a)
	if self.Image then
		surface.SetMaterial(self.Material)
		surface.DrawTexturedRect(14, 14, 64, 64)
	end
	draw.DrawText("Errungenschaft freigeschaltet!", "achv_notify12", 88, 30, Color(255, 255, 255, a), TEXT_ALIGN_LEFT)
	draw.DrawText(self.Text, "achv_notify12", 88, 50, Color(180, 180, 180, a), TEXT_ALIGN_LEFT)
end

vgui.Register("AchievementsNotify", PANEL)