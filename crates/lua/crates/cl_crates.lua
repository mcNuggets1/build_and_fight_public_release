local CRATE_RESULTS = {"Kiste erfolgreich entpackt!", "Entpacken fehlgeschlagen..."}

net.Receive("Crates.SendMessage", function()
	local tab = net.ReadTable()
	chat.AddText(unpack(tab))
end)

local PANEL = {}
function PANEL:Init()
	self:SetSize(400, 70)
	self:Center()
	self.y = self.y - 100
	self:SetTime(CurTime(), CurTime() + 5)
	surface.PlaySound("crates/chest_opening.wav")
end

function PANEL:SetTime(starttime, endtime)
	self.StartTime = starttime or self.StartTime
	self.EndTime = endtime or self.EndTime
	self.RemoveTime = self.EndTime + 1.5
	self.Result = 0
end

function PANEL:SetResult(res)
	if (res > 0) then
		self.Result = res
		self.OverrideText = CRATE_RESULTS[res] or "Irgendetwas ist fehlgeschlagen..."
		self.RemoveTime = CurTime() + 2.5
	end
end

function PANEL:Think()
	if !LocalPlayer():Alive() and self.Result == 0 then
		self:SetResult(2)
	end
	if self.Result != 0 and !self.OverrideTime then
		self.OverrideTime = CurTime()
	end
	if CurTime() > self.RemoveTime then
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	local bar_width = 260
	local bar_height = 10
	local bar_w = (w - bar_width) * 0.5
	local bar_h = (h * 0.7) - bar_height * 0.5
	surface.SetDrawColor(Color(50, 50, 50, 200))
	surface.DrawRect(bar_w, bar_h, bar_width, bar_height)
	surface.DrawOutlinedRect(bar_w, bar_h, bar_width, bar_height)
	local total_time = self.EndTime - self.StartTime
	local time_left = math.Clamp(self.EndTime - (self.OverrideTime or CurTime()), 0, total_time)
	local time_percent = 1 - time_left / total_time
	surface.SetDrawColor(Color(150, 180, 255, 220))
	if self.Result == 1 then
		surface.SetDrawColor(Color(100, 220, 100, 200))
	elseif self.Result == 2 then
		surface.SetDrawColor(Color(100, 100, 100, 220))
	end
	surface.DrawRect(bar_w + 1, bar_h + 1, (bar_width - 2) * time_percent, bar_height - 2)
	local status = "Entpacke, bitte warten..."
	if self.OverrideText then
		status = self.OverrideText
	end
	draw.SimpleTextOutlined(status, "DermaLarge", w / 2, h * 0.3, Color(230, 230, 230, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(50, 50, 50, 255))
end
vgui.Register("Crates.Uncrate", PANEL)

net.Receive("Crates.Uncrate", function(len)
	local starttime = net.ReadFloat()
	local endtime = net.ReadFloat()
	Crates.ShowCratePanel(starttime, endtime)
end)

net.Receive("Crates.UncrateResult", function(len)
	local res = net.ReadInt(4)
	Crates.ShowCrateResult(res)
end)

function Crates.ShowCratePanel(starttime, endtime)
	if IsValid(Crates.CratePanel) then Crates.CratePanel:Remove() end
	Crates.CratePanel = vgui.Create("Crates.Uncrate")
	Crates.CratePanel:SetTime(starttime, endtime)
end

function Crates.ShowCrateResult(res)
	if IsValid(Crates.CratePanel) then
		Crates.CratePanel:SetResult(res)
	end
end