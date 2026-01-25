local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self.Status = "idle"
	self.Text = " "
	self.Font = "DermaDefault"
	self.BoarderWidth = 1
	self.BoarderCol = PS.Style_Config.Col.MN.DSWBoarderCol
	self.TextCol = PS.Style_Config.Col.MN.DSWTextCol
	self.Anim_Hover = 1
	self.Anim_Exit = 1
	self.Anim_Click = 1
	self.EventTime = nil
	self.HoverAnimTime = 0.3
	self.FXCol = PS.Style_Config.Col.MN.DSWClickFX
	self.AlignX = TEXT_ALIGN_CENTER
	self.AlignY = TEXT_ALIGN_CENTER
	self.BGCol = PS.Style_Config.BGCol.DSWButton
end

function PANEL:CursorEnter()
end

function PANEL:CursorExit()
end

function PANEL:OnCursorEntered()
	if self:GetDisabled() then return end
	self.EventTime = {Time = SysTime(), Mode = "HoverPer"}
	self:CursorEnter()
end

function PANEL:OnCursorExited()
	if self:GetDisabled() then return end
	self:CursorExit()
	local Time = SysTime() + self.HoverAnimTime
	if self.EventTime and self.EventTime.Time then
		if SysTime() - self.EventTime.Time < self.HoverAnimTime then
			Time = SysTime() + (SysTime() - self.EventTime.Time)
		end
	end
	self.EventTime = {Time = Time, Mode = "HoverPer_Exit"}
end

function PANEL:DoClick()
	surface.PlaySound("ui/buttonclick.wav")
	self.ClickTime = SysTime()
	self.EventTime = {Time = SysTime(), Mode = "Click"}
	self:Click()
	return
end

function PANEL:SetTextAlign(X, Y)
	if X then
		self.AlignX = X
	end
	if Y then
		self.AlignY = Y
	end
end

function PANEL:SetTexts(name)
	self.Text = name
end

function PANEL:SetBoarderWidth(int)
	self.BoarderWidth = int
end
function PANEL:SetBoarderColor(color)
	self.BoarderCol = color
end

function PANEL:SetHoverAnim(int)
	self.Anim_Hover = int
end

function PANEL:SetExitAnim(int)
	self.Anim_Exit = int
end

function PANEL:SetClickAnim(int)
	self.Anim_Click = int
end

function PANEL:PaintBackGround(w, h)
end

function PANEL:PaintOverlay(w, h)
end

function PANEL:Paint(w, h)
	self:PaintBackGround(w, h)
	local function DrawBoarder()
		surface.DrawRect(0, 0, w, self.BoarderWidth)
		surface.DrawRect(0, h - self.BoarderWidth, w, self.BoarderWidth)
		surface.DrawRect(0, 0, self.BoarderWidth, h)
		surface.DrawRect(w - self.BoarderWidth, 0, self.BoarderWidth, h)
	end
	surface.SetDrawColor(self.BGCol)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(self.BoarderCol or Color(255, 255, 255, 255))
	if self.BoarderCol.a > 0 then
		DrawBoarder()
	end
	local col = self.FXCol
	if self.EventTime and self.EventTime.Time and self.EventTime.Mode then
		local Mode = self.EventTime.Mode
		if Mode == "HoverPer" then
			local Per = SysTime() - self.EventTime.Time
			local D = math.min(Per, self.HoverAnimTime) * 4
			surface.SetDrawColor(Color(col.r, col.g, col.b, D * 30))
			surface.DrawRect(1, 1, (w - 2), h - 2)
		end
		if Mode == "HoverPer_Exit" then
			local Per = self.EventTime.Time - SysTime()
			local D = math.max(Per, 0) * 4
			surface.SetDrawColor(Color(col.r, col.g, col.b, D * 30))
			surface.DrawRect(1, 1, (w - 2), h - 2)
	 	end
		if Mode == "Click" then
			local Per = SysTime() - self.EventTime.Time
			local D = 1 - math.min(Per * 4, 1)
			surface.SetDrawColor(Color(col.r, col.g, col.b, D * 50))
			surface.DrawRect(1, 1, (w - 2), h - 2)
		end
	end
	if self.Text and self.Text != "" then
		local pos_x = w / 2
		local pos_y = h / 2
		local align_x = self.AlignX
		if align_x == TEXT_ALIGN_LEFT then
			pos_x = 10
		end
		if align_x == TEXT_ALIGN_RIGHT then
			pos_x = w - 10
		end
		if align_x == TEXT_ALIGN_TOP then
			pos_y = 1
		end
		if align_x == TEXT_ALIGN_BOTTOM then
			pos_y = height - 1
		end
		draw.SimpleText(self.Text, self.Font, pos_x, pos_y, self.TextCol, align_x, self.AlignY)
	end
	self:PaintOverlay(w, h)
end

function PANEL:Click()
end

vgui.Register("PS_DSWButton", PANEL, "DButton")