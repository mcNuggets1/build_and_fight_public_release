local PANEL = {}

function PANEL:Init()
	if !self.Initialized then return end
	if IsValid(PS_MatPanel) then
		PS_MatPanel:Remove()
	end
	self:SetTitle("")
	self:SetSize(600, 500)
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:SetDeleteOnClose(true)
	local TopBar = vgui.Create("DPanel", self)
	TopBar:SetSize(self:GetWide() - 2, 25)
	TopBar:SetPos(1, 1)
	TopBar.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.GP_TitleBG)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(PS.Style_Config.Col.PG.Main_Outline)
		surface.DrawRect(0, h - 1, w, 1)
		draw.SimpleText("Shop: Materialauswahl", "PS_Treb_S22", 10, 1, PS.Style_Config.Col.PG.Main_TitleText)
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
	self.panellist = vgui.Create("DPanelList", self)
	self.panellist:SetSize(300, 440)
	self.panellist:SetPos(5, 30)
	self.panellist:SetSpacing(2)
	self.panellist:EnableVerticalScrollbar(true)
	self.panellist:EnableHorizontal(false)
	self.panellist:PS_PaintListBar()
	local mat = vgui.Create("PS_DSWButton", self.panellist)
	mat:SetTexts("Zurücksetzen")
	mat:SetSize(485, 30)
	mat.Click = function()
		self:SetMaterial("")
	end
	self.panellist:AddItem(mat)
	for _, v in SortedPairsByValue(self.Materials) do
		local mat = vgui.Create("PS_DSWButton", self.panellist)
		mat.material = v
		if v and v != "" then
			mat:SetTexts(v)
		else
			mat:SetTexts("Zurücksetzen")
		end
		mat:SetSize(485, 30)
		mat.Click = function()
			self:SetMaterial(mat.material)
		end
		self.panellist:AddItem(mat)
	end
	self.preview = vgui.Create("DImage", self)
	self.preview:SetPos(320, 50)
	self.preview:SetSize(256, 256)
	self.previewname = vgui.Create("DLabel", self)
	self.previewname:SetPos(320, 310)
	self.previewname:SizeToContents()
	self.search = vgui.Create("DTextEntry", self)
	self.search:SetPos(320, 330)
	self.search:SetSize(256, 20)
	self.search:SetPlaceholderText("Eigenen Materialpfad angeben...")
	self.search.OnChange = function()
		self:SetMaterial(self.search:GetValue())
	end
	self.random = vgui.Create("DCheckBoxLabel", self)
	self.random:SetPos(320, 360)
	self.random:SetSize(256, 20)
	self.random:SetText("Zufälliges Material")
	self.random:SetConVar("ps_rnd_mat")	
	local done = vgui.Create("PS_DSWButton", self)
	done:DockMargin(0, 5, 0, 0)
	done:Dock(BOTTOM)
	done:SetTexts("Abschließen")
	done.DoClick = function()
		self.OnChoose(self.material)
		self:Close()
	end
	self:Center()
	self:Show()
	self:MakePopup()
	PS_MatPanel = self
end

function PANEL:OnChoose()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(PS.Style_Config.Col.CC.Main_Outline)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(PS.Style_Config.BGCol.CC_Canvas)
	surface.DrawRect(1, 1, w - 2, h - 2)
end

function PANEL:SetMaterials(mats)
	self.Materials = mats
	self.Initialized = true
	self:Init()
end

function PANEL:SetMaterial(mat)
	self.material = mat
	if mat and mat != "" then
		self.preview:SetImage(mat)
		self.previewname:SetText(mat)
		self.search:SetValue(mat)
	else
		self.preview:SetImage("error")
		self.previewname:SetText("Nichts ausgewählt")
	end
	self.previewname:SizeToContents()
end

--[[function PANEL:OnFocusChanged(focus) -- This bugs with DTextEntry
	if !focus then
		self:Close()
	end
end]]

vgui.Register("DPointShopMatChooser", PANEL, "DFrame")