local PANEL = {}

function PANEL:Init()
	if IsValid(PS_DesignPanel) then
		PS_DesignPanel:Remove()
		PS_DesignPanel = nil
	end
	self:SetTitle("Design anpassen")
	self:SetSize(300, 250)
	self:SetDraggable(false)
	self:SetDeleteOnClose(true)
	local TopBar = vgui.Create("DPanel",self)
	TopBar:SetSize(self:GetWide() - 2, 25)
	TopBar:SetPos(1, 1)
	TopBar.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.GP_TitleBG)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(PS.Style_Config.Col.PG.Main_Outline)
		surface.DrawRect(0, w - 1, h, 1)
		draw.SimpleText("Design anpassen", "PS_Treb_S22", 10, 1, PS.Style_Config.Col.PG.Main_TitleText)
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
	local l1 = vgui.Create("DLabel", self)
	l1:SetText("Layout auswählen:")
	l1:Dock(TOP)
	l1:DockMargin(4, 0, 4, 4)
	l1:SizeToContents()
	local layoutselect = vgui.Create("DComboBox", self)
	layoutselect:SetValue("")
	layoutselect:SetTall(24)
	layoutselect:Dock(TOP)
	local names = {}
	for k, v in pairs(PS.Style_Config.ColorStyles) do
		local name = v.Name
		names[k] = name
		layoutselect:AddChoice(name, k)
	end
	layoutselect:SetValue(names[PS.Style_Config.ColorSelected])
	layoutselect.OnSelect = function(slf, index, value, data)
		if PS.Style_Config.ColorSelected == data then return end
		RunConsoleCommand("shop_style", data)
		PS.LoadColorTable(data)
		PS:CloseMenu()
		PS:ToggleMenu()
		vgui.Create("DPointShopDesignOptions")
	end
	local l2 = vgui.Create("DLabel", self)
	l2:SetText("Hintergrundfarbe auswählen:")
	l2:Dock(TOP)
	l2:DockMargin(4, 2, 4, 4)
	l2:SizeToContents()
	local bgselect = vgui.Create("DComboBox", self)
	bgselect:SetValue("")
	bgselect:SetTall(24)
	bgselect:Dock(TOP)
	local names = {}
	for k, v in pairs(PS.Style_Config.BGColorStyles) do
		local name = v.Name
		names[k] = name
		bgselect:AddChoice(name, k)
	end
	bgselect:SetValue(names[PS.Style_Config.BGColorSelected])
	bgselect.OnSelect = function(slf, index, value, data)
		if PS.Style_Config.BGColorSelected == data then return end
		RunConsoleCommand("shop_bgstyle", data)
		PS.LoadBGColorTable(data)
		PS:CloseMenu()
		PS:ToggleMenu()
		vgui.Create("DPointShopDesignOptions")
	end
	local l3 = vgui.Create("DLabel", self)
	l3:SetText("Shop-Intro konfigurieren:")
	l3:Dock(TOP)
	l3:DockMargin(4, 2, 4, 4)
	l3:SizeToContents()
	local selections = {
		[0] = "Intro nur beim ersten Öffnen abspielen",
		[1] = "Intro immer beim Öffnen abspielen",
		[2] = "Intro immer beim Aufrufen abspielen",
		[3] = "Intro nie abspielen"
	}
	local introselect = vgui.Create("DComboBox", self)
	introselect:SetValue("")
	introselect:SetTall(24)
	introselect:Dock(TOP)
	introselect:SetValue(selections[GetConVar("shop_playintro"):GetInt()] or selections[3])
	for k, v in pairs(selections) do
		introselect:AddChoice(v, k)
	end
	introselect.OnSelect = function(slf, index, value, data)
		RunConsoleCommand("shop_playintro", data)
	end
	local l4 = vgui.Create("DLabel", self)
	l4:SetText("Ansicht ändern:")
	l4:Dock(TOP)
	l4:DockMargin(4, 2, 4, 4)
	l4:SizeToContents()
	local selections = {
		[0] = "Vollbildmodus",
		[1] = "Fenstermodus"
	}
	local windowed = vgui.Create("DComboBox", self)
	windowed:SetValue("")
	windowed:SetTall(24)
	windowed:Dock(TOP)
	windowed:SetSortItems(false)
	windowed:SetValue(selections[PS.Style_Config.Windowed and 1 or 0])
	for k, v in pairs(selections) do
		windowed:AddChoice(v, k)
	end
	windowed.OnSelect = function(slf, index, value, data)
		RunConsoleCommand("shop_windowed", data)
		PS.Style_Config.Windowed = data == 1 and true or false
		PS:CloseMenu()
		PS:ToggleMenu()
		vgui.Create("DPointShopDesignOptions")
	end
	local l5 = vgui.Create("DLabel", self)
	l5:SetText("Animations-Geschwindigkeit konfigurieren:")
	l5:Dock(TOP)
	l5:DockMargin(4, 2, 4, 4)
	l5:SizeToContents()
	local bg = vgui.Create("DPanel", self)
	bg:SetBackgroundColor(Color(60, 60, 60))
	bg:SetTall(24)
	bg:Dock(TOP)
	local setspeed = vgui.Create("DNumSlider", bg)
	setspeed:SetTall(24)
	setspeed:Dock(TOP)
	setspeed:DockMargin(10, 0, 0, 0)
	setspeed:SetText("Wert:")
	setspeed:SetMin(0.1)
	setspeed:SetMax(1)
	setspeed:SetDecimals(1)
	setspeed:SetValue(GetConVar("shop_speed_mult"):GetFloat())
	setspeed.OnValueChanged = function(slf, val)
		RunConsoleCommand("shop_speed_mult", val)
	end
	self:Center()
	self:MakePopup()
	PS_DesignPanel = self
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(PS.Style_Config.BGCol.GP_BodyBG)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(PS.Style_Config.Col.PG.Main_Outline)
	surface.DrawRect(0, 0, w, 1)
	surface.DrawRect(0, h - 1, w, 1)
	surface.DrawRect(0, 0, 1, h)
	surface.DrawRect(w - 1, 0, 1, h)
end

vgui.Register("DPointShopDesignOptions", PANEL, "DFrame")