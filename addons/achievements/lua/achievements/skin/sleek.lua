VIEW = {}

VIEW.ParentFrame = nil
VIEW.TabList = nil
VIEW.Categories = {}

local use_font = system.IsWindows() and "Tahoma" or "Verdana"
surface.CreateFont("achv_close", {font = use_font, size = 14, weight = 500})
surface.CreateFont("achv_boxtitle", {font = "Calibri", size = 19, weight = 600, antialias = true})
surface.CreateFont("achv_boxmain", {font = "Calibri", size = 16, weight = 200, antialias = true})

local textOpen = false
function VIEW:Init(settings)
	local frame = vgui.Create("DFrame")
	frame:SetSize(640, 462)
	frame:SetSizable(true)
	frame:Center()
	frame:MakePopup()
	frame:ParentToHUD()
	frame:SetTitle("")
	frame:DockPadding(0, 31, 0, 0)
	frame:ShowCloseButton(false)
	frame.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
		draw.RoundedBox(0, 0, 0, w, h, Color(250, 250, 250, 255))
		draw.RoundedBox(0, 0, 0, w, 31, Color(44, 62, 80))
		draw.SimpleText(tostring(settings["WindowTitle"]), "achv_boxtitle", 8, 5, Color(255, 255, 255, 255))
	end
	local cl = frame.btnClose
	cl:SetVisible(true)
	cl:SetText("X")
	cl:SetFont("achv_close")
	cl:SetTextColor(Color(255, 255, 255, 255))
	cl.Paint = function(self, w, h)
		local kcol = self:IsHovered() and Color(255, 150, 150) or Color(175, 100, 100)
		draw.RoundedBox(0, 4, 4, w - 8, h - 8, kcol)
	end
	local tabList = vgui.Create("DPropertySheet", frame)
	tabList:Dock(FILL)
	tabList.Paint = function(s, w, h)
		surface.SetDrawColor(80, 80, 80, 255)
		surface.DrawRect(0, 0, w, 22)
	end
	tabList:SetPadding(0)
	tabList.tabScroller:SetOverlap(0)
	self.ParentFrame = frame
	self.TabList = tabList
end

function VIEW:CreateCategoryTab()
	local catPanel = vgui.Create("DPanel")
	catPanel:DockPadding(4, 4, 4, 4)
	catPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(250, 250, 250, 255))
	end
	local topPnl = vgui.Create("DPanel", catPanel)
	topPnl:SetTall(24)
	topPnl:Dock(TOP)
	topPnl:SetDrawBackground(false)
	topPnl:DockPadding(4, 0, 4, 4)
	local progBar = vgui.Create("ACHProgressBar", topPnl)
	progBar:Dock(FILL)
	progBar:DockMargin(0, 0, 0, 0)
	progBar.Paint = function(self, w, h)
		local fDelta = 0
		if (self.m_iMax - self.m_iMin != 0) then
			fDelta = (self.m_iValue - self.m_iMin) / (self.m_iMax-self.m_iMin)
		end
		draw.RoundedBox(4, 0, 0, w, h, Color(44, 62, 80, 255))
		if fDelta != 0 then
			draw.RoundedBox(4, 0, 0, w * fDelta, h, Color(52, 73, 94, 255))
		end
	end
	progBar.Label:SetColor(Color(250, 250, 250))
	local scrollPnl = vgui.Create("DScrollPanel", catPanel)
	scrollPnl:Dock(FILL)
	local pnl = vgui.Create("DListLayout")
	pnl:Dock(FILL)
	scrollPnl:AddItem(pnl)
	catPanel.ProgBar = progBar
	catPanel.Content = pnl
	return catPanel
end

local rewardTooltip
function VIEW:CreateAchievement(parent, data)
	local pnl = vgui.Create("DPanel", parent)
	pnl.IsMarked = self:IsAchievementMarked(data)
	pnl:SetTall(64 + 8)
	pnl:DockMargin(0, 0, 4, 4)
	pnl:DockPadding(4, 4, 4, 4)
	pnl.PaintOver = function(p, w, h)
		if data.Completed then
			local str = os.date("Erledigt am %d.%m.%y", tonumber(data.CompletedOn))
			draw.SimpleText(str, "DermaDefault", w - (data.Rewards and 68 or 36), 6, Color(80, 80, 80), draw.TEXT_ALIGN_RIGHT, draw.TEXT_ALIGN_TOP)
		end

		if pnl.IsMarked then
			surface.SetDrawColor(80, 80, 80, 255)
			surface.DrawOutlinedRect(0, 0, w, h, 2)
		end
	end
	pnl.OnCursorEntered = function(pnl)
		if IsValid(pnl.achvTooltip) then return end
		timer.Create("AchvInfo_" .. data.ID, 3, 1, function()
			if IsValid(pnl.achvTooltip) or !IsValid(pnl) then return end
			pnl.achvTooltip = self:CreateMarkTooltip(pnl, math.Round((GetGlobal2Int("Achv_" .. data.ID .. "_count", 0) / GetGlobal2Int("Achv_Total", 0)) * 100, 3) .. "% aller Spieler haben dieses Achievement.")
		end)
	end
	pnl.OnCursorExited = function(pnl)
		timer.Remove("AchvInfo_" .. data.ID)
		if !IsValid(pnl.achvTooltip) then return end
		pnl.achvTooltip:Remove()
	end
	pnl:SetAlpha(data.Completed and 255 or 200)
	local imgicon = vgui.Create("DImage", pnl)
	imgicon:Dock(LEFT)
	imgicon:SetWide(64)
	imgicon:SetImage((!data.Completed and data.Hidden) and "gui/achievements/hidden.png" or data.Icon)
	imgicon:DockMargin(0, 0, 4, 0)
	function imgicon:Paint(w, h)
		self:PaintAt(0, 0, w, h)
	end
	local function CreateLabel(text, font, color)
		local lbl = vgui.Create("DLabel", pnl)
		lbl:SetText(text)
		lbl:SetFont(font)
		lbl:SetColor(color)
		lbl:SizeToContents()
		return lbl
	end
	local lblname = CreateLabel((!data.Completed and data.Hidden) and "???" or data.Name, "DermaDefaultBold", Color(0, 0, 0))
	local lbldesc = CreateLabel((!data.Completed and data.Hidden) and "???" or data.Description, "DermaDefault", Color(60, 60, 60))
	lblname:Dock(TOP)
	lbldesc:Dock(TOP)
	lblname:DockMargin(4, 4, 0, 0)
	lbldesc:DockMargin(4, 4, 0, 0)
	local progress
	if (data.Type == ACHIEVEMENT_PROGRESS) then
		progress = vgui.Create("ACHProgressBar", pnl)
		progress:SetTall(16)
		progress:Dock(BOTTOM)
		progress:SetMax(data.Target)
		progress:SetValue(data.Value)
	elseif (data.Type == ACHIEVEMENT_ONEOFF) then
		progress = 0
	end

	local mark_btn = vgui.Create("DImageButton", pnl) -- Mark button
	mark_btn:SetImage(pnl.IsMarked and "gui/achievements/unmark.png" or "gui/achievements/mark.png")
	mark_btn:SetSize(32, 32)
	mark_btn.OnCursorEntered = function(btn)
		if IsValid(btn.hintTooltip) then return end
		btn.hintTooltip = self:CreateMarkTooltip(mark_btn, pnl.IsMarked and "Unpin Achievement" or "Pin Achievement")
	end
	mark_btn.OnCursorExited = function(btn)
		if !IsValid(btn.hintTooltip) then return end
		btn.hintTooltip:Remove()
	end
	mark_btn.DoClick = function(btn)
		pnl.IsMarked = !pnl.IsMarked
		cookie.Set("MG_TDM_MarkedAchievement_" .. data.ID, pnl.IsMarked and "1" or "0")
		btn:SetImage(pnl.IsMarked and "gui/achievements/unmark.png" or "gui/achievements/mark.png")
		if IsValid(btn.hintTooltip) then
			btn.hintTooltip:Remove()
			btn.hintTooltip = self:CreateMarkTooltip(mark_btn, pnl.IsMarked and "Unpin Achievement" or "Pin Achievement")
		end
	end

	local reward_btn
	if data.Rewards then
		reward_btn = vgui.Create("DImageButton", pnl)
		reward_btn:SetImage("gui/achievements/gift.png")
		reward_btn:SetSize(32, 32)
		reward_btn:SetDisabled(data.Completed)
		reward_btn.rewardTooltip = nil
		reward_btn.OnCursorEntered = function(btn)
			if IsValid(btn.rewardTooltip) then return end
			btn.rewardTooltip = self:CreateRewardTooltip(reward_btn, data.Rewards)
		end
		reward_btn.OnCursorExited = function(btn)
			if !IsValid(btn.rewardTooltip) then return end
			btn.rewardTooltip:Remove()
		end
	end
	pnl.PerformLayout = function(p)
		if reward_btn then
			reward_btn:SetPos(p:GetWide() - 32, 0)
			mark_btn:SetPos(p:GetWide() - 64, 0)
		else
			mark_btn:SetPos(p:GetWide() - 32, 0)
		end
	end
	return pnl
end

local tooltipCol = Color(40, 40, 40, 255)
local tooltipChildCol = Color(80, 80, 80, 255)
function VIEW:CreateRewardTooltip(target, rewards)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(#rewards * 80 + 4, 40 + 4)
	pnl:SetDrawOnTop(true)
	function pnl:PositionTooltip()
		if !IsValid(self.TargetPanel) then return self:Remove() end
		self:PerformLayout()
		local x, y = 0, 0
		if system.HasFocus() then
			x, y = input.GetCursorPos() -- This function fails, if GMod is not focused.
		else
			local parent = self.TargetPanel:GetParent()
			if parent then
				x, y = self.TargetPanel:GetPos()
				x, y = parent:LocalToScreen(x, y)
			end
		end
		local w, h = self:GetSize()
		y = y - h - 12
		if (y < 2) then y = 2 end
		self:SetPos(math.Clamp(x - w * 0.5, 0, ScrW() - self:GetWide()), math.Clamp(y, 0, ScrH() - self:GetTall()))
	end
	function pnl:Paint(w, h)
		self:PositionTooltip()
		draw.RoundedBox(4, 0, 0, w, h, tooltipCol)
	end
	pnl.TargetPanel = target
	pnl:PositionTooltip()
	for k, reward in pairs(rewards) do
		local rewardPnl = vgui.Create("DPanel", pnl)
		rewardPnl:SetSize(80, 40)
		rewardPnl:SetPos(2 + (k - 1) * 80, 2)
		rewardPnl:DockPadding(4, 4, 4, 4)
		rewardPnl:SetDrawBackground(false)
		rewardPnl.Paint = function(p, w, h)
			draw.RoundedBox(2, 2, 2, w-4, h-4, tooltipChildCol)
		end
		if reward["money"] then
			local rewardText = vgui.Create("DLabel", rewardPnl)
			rewardText:SetText(string.Comma(reward["money"]).." Cash")
			rewardText:SetFont("Default")
			rewardText:SizeToContents()
			rewardText:Dock(FILL)
			rewardText:SetContentAlignment(5)
		end
	end
	return pnl
end

function VIEW:IsAchievementMarked(data) -- Cookie is set in "mark_btn.DoClick"
	return cookie.GetString("MG_TDM_MarkedAchievement_" .. data.ID, "0") == "1"
end

function VIEW:CreateMarkTooltip(target, text)
	local approximateLength = string.len(text) * 5
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(30 + 4 + approximateLength, 40 + 4)
	pnl:SetDrawOnTop(true)
	function pnl:PositionTooltip()
		if !IsValid(self.TargetPanel) then return self:Remove() end
		self:PerformLayout()
		local x, y = 0, 0
		if system.HasFocus() then
			x, y = input.GetCursorPos()
		else
			local parent = self.TargetPanel:GetParent()
			if parent then
				x, y = self.TargetPanel:GetPos()
				x, y = parent:LocalToScreen(x, y)
			end
		end
		local w, h = self:GetSize()
		y = y - h - 12
		if (y < 2) then y = 2 end
		self:SetPos(math.Clamp(x - w * 0.5, 0, ScrW() - self:GetWide()), math.Clamp(y, 0, ScrH() - self:GetTall()))
	end
	function pnl:Paint(w, h)
		self:PositionTooltip()
		draw.RoundedBox(4, 0, 0, w, h, tooltipCol)
	end
	pnl.TargetPanel = target
	pnl:PositionTooltip()
	local hintPnl = vgui.Create("DPanel", pnl)
	hintPnl:SetSize(30 + approximateLength, 40)
	hintPnl:SetPos(2, 2)
	hintPnl:DockPadding(4, 4, 4, 4)
	hintPnl:SetDrawBackground(false)
	hintPnl.Paint = function(p, w, h)
		draw.RoundedBox(2, 2, 2, w-4, h-4, tooltipChildCol)
	end

	local hintText = vgui.Create("DLabel", hintPnl)
	hintText:SetText(text)
	hintText:SetFont("Default")
	hintText:SizeToContents()
	hintText:Dock(FILL)
	hintText:SetContentAlignment(5)

	return pnl
end

function VIEW:AddCategory(name, material, progress, max)
	local category = achievements.GetCategories()[name]
	if category and category.Hidden and !achievements.HasCategoryAchievement(name) then return end

	self.Categories[name] = self.TabList:AddSheet(tostring(name), self:CreateCategoryTab(), tostring(material))
	local progPanel = self.Categories[name].Panel.ProgBar
	progPanel:SetValue(progress)
	progPanel:SetMax(max)
	self.Categories[name].Panel:SetPos(0, 22)
	local tab = self.Categories[name].Tab
	tab.Paint = function(s, w, h)
		if (self.TabList:GetActiveTab() == tab) then
			surface.SetDrawColor(40, 40, 40, 255)
		else
			surface.SetDrawColor(80, 80, 80, 255)
		end
		surface.DrawRect(0, 0, w, h)
	end
	tab.ApplySchemeSettings = function(self)
		local ExtraInset = 12 + self.Image:GetWide()
		local Active = self:GetPropertySheet():GetActiveTab() == self
		self:SetTextInset(ExtraInset, 2)
		local w, h = self:GetContentSize()
		self:SetSize(w + 10, 22)
		DLabel.ApplySchemeSettings(self)
	end
	tab.DoClick = function(self)
		self:GetPropertySheet():SetActiveTab(self)
	end
	tab:SetFont("achv_boxmain")
end

function VIEW:AddAchievement(data)
	local dat = self.Categories[data.Category]
	if !dat then return end

	local cat = dat.Panel
	self:CreateAchievement(cat.Content, data)
end