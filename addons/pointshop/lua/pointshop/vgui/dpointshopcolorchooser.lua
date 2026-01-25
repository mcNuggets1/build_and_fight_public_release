local PANEL = {}

function PANEL:Init()
	if IsValid(PS_ColorPanel) then
		PS_ColorPanel:Remove()
	end
	self:SetTitle("")
	self:SetSize(300, 300)
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
		draw.SimpleText("Shop: Farbenauswahl", "PS_Treb_S22", 10, 1, PS.Style_Config.Col.PG.Main_TitleText)
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
	self.colorpicker = vgui.Create("DColorMixer", self)
	self.colorpicker:Dock(FILL)
	local done = vgui.Create("PS_DSWButton", self)
	done:DockMargin(0, 5, 0, 0)
	done:Dock(BOTTOM)
	done:SetTexts("Abschließen")
	done.DoClick = function()
		self.OnChoose(self.colorpicker:GetColor())
		self:Close()
	end
	self:Center()
	self:Show()
	self:MakePopup()
	PS_ColorPanel = self
end

function PANEL:OnChoose(color)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(PS.Style_Config.Col.CC.Main_Outline)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(PS.Style_Config.BGCol.CC_Canvas)
	surface.DrawRect(1, 1, w - 2, h - 2)
end

function PANEL:SetColor(color)
	self.colorpicker:SetColor(color or color_white)
end

function PANEL:OnFocusChanged(focus)
	if !focus then
		self:Close()
	end
end

vgui.Register("DPointShopColorChooser", PANEL, "DFrame")