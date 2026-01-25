local PANEL = {}

local function MakeNiceName(str)
	local newname = {}
	for _, s in pairs(string.Explode("_", str)) do
		if (string.len(s) == 1) then
			table.insert(newname, string.upper(s))
			continue
		end
		table.insert(newname, string.upper(string.Left(s, 1))..string.Right(s, string.len(s) - 1))
	end
	return string.Implode(" ", newname)
end

function PANEL:Init()
	if !self.Initialized then return end
	if IsValid(PS_SkinPanel) then
		PS_SkinPanel:Remove()
	end
	self:SetTitle("")
	self:SetSize(800, 500)
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:SetDeleteOnClose(true)
	local TopBar = vgui.Create("DPanel",self)
	TopBar:SetSize(self:GetWide() - 2, 25)
	TopBar:SetPos(1, 1)
	TopBar.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.GP_TitleBG)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(PS.Style_Config.Col.PG.Main_Outline)
		surface.DrawRect(0, h - 1, w, 1)
		draw.SimpleText("Shop: Skin/Bodygroup-Auswahl", "PS_Treb_S22", 10, 1, PS.Style_Config.Col.PG.Main_TitleText)
	end
	local Button = vgui.Create("PS_DSWButton", TopBar)
	Button:SetSize(50, 24)
	Button:SetPos(TopBar:GetWide() - 50,0)
	Button.BoarderCol = Color(0, 0, 0, 0)
	Button:SetTexts("X")
	Button.Click = function(slf)
		self:Remove()
	end
	Button.PaintBackGround = function(slf, w, h)
		local COL = Color(25, 25, 25, 200)
		surface.SetDrawColor(COL)
		surface.DrawRect(1, 1, w - 2, h - 2)
	end
	self.scrollpanel = vgui.Create("DScrollPanel", self)
	self.scrollpanel:PS_PaintListBar()
	self.scrollpanel:Dock(FILL)
	self.playermodel = vgui.Create("DModelPanel", self)
	self.playermodel:SetModel(self.PlayerModel)
	self.playermodel:SetSize(400, 430)
	self.playermodel:SetPos(435, 25)
	self.playermodel:SetFOV(55)
	self.playermodel.Angles = Angle(0, 45, 0)
	function self.playermodel:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end

	function self.playermodel:DragMouseRelease()
		self.Pressed = false
	end

	function self.playermodel:LayoutEntity(ent)
		if self.bAnimated then self:RunAnimation() end
		if self.Pressed then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle(0, (self.PressX or mx) - mx, 0)
			self.PressX, self.PressY = gui.MousePos()
		end
		ent:SetAngles(self.Angles)
	end
	local iv = 0
	local nskins = self.playermodel.Entity:SkinCount() - 1
	if (nskins > 0) then
		local bg = vgui.Create("DPanel", self.scrollpanel)
		bg:SetSize(445, 20)
		bg:SetPos(10, 15)
		bg:SetBackgroundColor(Color(60, 60, 60))
		self.skins = vgui.Create("DNumSlider", self.scrollpanel)
		self.skins:SetSize(465, 10)
		self.skins:SetPos(15, 0)
		self.skins:SetText("Skin")
		self.skins:SetTall(50)
		self.skins:SetDecimals(0)
		self.skins:SetMax(nskins)
		self.skins:SetValue(0)
		self.skins.OnValueChanged = function(slf, val)
			self.playermodel.Entity:SetSkin(val)
		end
		iv = iv + 30
	end
	self.bgpanels = {}
	for i=0, self.playermodel.Entity:GetNumBodyGroups() - 1 do
		if (self.playermodel.Entity:GetBodygroupCount(i) <= 1) then continue end
		local bg = vgui.Create("DPanel", self.scrollpanel)
		bg:SetSize(445, 20)
		bg:SetPos(10, 15 + iv)
		bg:SetBackgroundColor(Color(60, 60, 60))
		local bodygroups = vgui.Create("DNumSlider", self.scrollpanel)
		bodygroups:SetSize(465, 10)
		bodygroups:SetPos(15, 0 + iv)
		bodygroups:SetText(MakeNiceName(self.playermodel.Entity:GetBodygroupName(i)))
		bodygroups:SetTall(50)
		bodygroups:SetDecimals(0)
		bodygroups:SetMax(self.playermodel.Entity:GetBodygroupCount(i) - 1)
		bodygroups:SetValue(0)
		bodygroups.OnValueChanged = function(slf, val)
			self.playermodel.Entity:SetBodygroup(i, val)
		end
		table.insert(self.bgpanels, bodygroups)
		iv = iv + 30
	end
	if iv == 0 then
		local nothing_here = vgui.Create("DLabel", self.scrollpanel)
		nothing_here:SetPos(15, 0)
		nothing_here:SetText("Nichts hier!")
	end
	local done = vgui.Create("PS_DSWButton", self)
	done:DockMargin(0, 5, 0, 0)
	done:Dock(BOTTOM)
	done:SetTexts("Abschließen")
	done.DoClick = function()
		local bodygroups = {}
		for i=0, self.playermodel.Entity:GetNumBodyGroups() - 1 do
			if (self.playermodel.Entity:GetBodygroupCount(i) <= 1) then continue end
			table.insert(bodygroups, self.playermodel.Entity:GetBodygroup(i))
		end
		self.OnChoose(bodygroups, self.playermodel.Entity:GetSkin())
		self:Close()
	end
	self:Center()
	self:Show()
	self:MakePopup()
	PS_SkinPanel = self
end

function PANEL:OnChoose()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(PS.Style_Config.Col.CC.Main_Outline)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(PS.Style_Config.BGCol.CC_Canvas)
	surface.DrawRect(1, 1, w - 2, h - 2)
end

function PANEL:SetModel(model)
	self.PlayerModel = model
	self.Initialized = true
	self:Init()
end

function PANEL:SetBodygroup(number, count)
	for k,v in pairs(self.bgpanels) do
		if k == number then
			v:SetValue(count)
		end
	end
end

function PANEL:SetSkin(skin)
	if !self.skins then return end
	self.skins:SetValue(skin)
end

function PANEL:OnFocusChanged(focus)
	if !focus then
		self:Close()
	end
end

vgui.Register("DPointShopSkinChooser", PANEL, "DFrame")