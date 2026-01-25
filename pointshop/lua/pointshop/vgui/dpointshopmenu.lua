local ALL_ITEMS = 1
local OWNED_ITEMS = 2
local UNOWNED_ITEMS = 3

local CategoryLimits = {}
local EquipLimits = {}
local ItemCount = 0

local SortStuff = {
	{"Name", "Name"},
	{"Price", "Preis", true},
	{"EquipGroup", "Gruppe"},
}

local function RecountLimits(ply)
	if !IsValid(ply) then return end
	CategoryLimits = {}
	EquipLimits = {}
	for _, ITEM in pairs(PS.Items) do
		if ply:PS_HasItemEquipped(ITEM.ID) then
			if ITEM.EquipGroup != "znone" and ITEM.MaxEquip and ITEM.MaxEquip > -1 then
				EquipLimits[ITEM.EquipGroup] = EquipLimits[ITEM.EquipGroup] and EquipLimits[ITEM.EquipGroup] + (ITEM.Weight or 1) or (ITEM.Weight or 1)
			end
			CategoryLimits[ITEM.Category] = CategoryLimits[ITEM.Category] and CategoryLimits[ITEM.Category] + (ITEM.Weight or 1) or (ITEM.Weight or 1)
		end
	end
end

hook.Add("PS_ItemsAdjusted", "PS_ItemsAdjusted",function()
	if IsValid(PS.ShopMenu) then
		PS.ShopMenu:UpdateMyInventory(nil, false)
		PS.ShopMenu:UpdateCurrentShopList(nil, false)

		RecountLimits(LocalPlayer())
	end
end)

local function BuildItemMenu(menu, ply, itemtype, callback)
	local ply_items = ply:PS_GetItems()
	local cats = {}
	for _, i in pairs(PS.Categories) do
		table.insert(cats, i)
	end
	table.SortByMember(cats, "Name", function(a, b) return a > b end)
	local items = {}
	for k, i in pairs(PS.Items) do
		table.insert(items, i)
	end
	table.SortByMember(items, PS.Config.SortItemsBy, function(a, b) return a[2] > b[2] end)
	for _, CATEGORY in pairs(cats) do
		local catmenu, parent = menu:AddSubMenu(CATEGORY.Name)
		parent:SetSkin("PS_DermaMenu")
		catmenu:GetVBar().btnUp.Paint = function(slf, w, h)
			draw.RoundedBox(0, 0, 0, w, h, PS.Style_Config.Col.MN.DSWBoarderCol)
		end
		catmenu:GetVBar().btnDown.Paint = function(slf, w, h)
			draw.RoundedBox(0, 0, 0, w, h, PS.Style_Config.Col.MN.DSWBoarderCol)
		end
		catmenu:GetVBar().btnGrip.Paint = function(slf, w, h)
			draw.RoundedBox(0, 0, 0, w, h, PS.Style_Config.Col.MN.DSWBoarderCol)
		end
		catmenu:GetVBar().Paint = function(slf, w, h)
			draw.RoundedBox(0, 0, 0, w, h, PS.Style_Config.BGCol.CC_Canvas)
		end
		for _, tab in pairs(items) do
			local item_id = tab.ID
			local ITEM = tab
			if ITEM.Category == CATEGORY.Name then
				if itemtype == ALL_ITEMS or (itemtype == OWNED_ITEMS and ply_items[item_id]) or (itemtype == UNOWNED_ITEMS and !ply_items[item_id]) then
					catmenu:AddOption(ITEM.Name.." ("..string.Comma(ITEM.Price).." "..PS.Config.PointsName..")", function()
						surface.PlaySound("ui/buttonclick.wav")
						callback(item_id)
					end)
				end
			end
		end
	end
end

local PANEL = {}
function PANEL:UpdateMyInventory(FilterName,Fade)
	if IsValid(self.InvList) then
		self.InvList:UpdateList(FilterName, Fade)
	end
end

function PANEL:UpdateCurrentShopList(Name)
	if IsValid(self.ShopList) then
		self.ShopList:UpdateList(FilterName, Fade)
	end
end

function PANEL:ReBulidCanvas()
	if IsValid(self.Canvas) then
		self.Canvas:Remove()
	end
	self.Canvas = vgui.Create("DPanel",self)
	self.Canvas:SetPos(0, self.TopBar:GetTall())
	self.Canvas:SetSize(self:GetWide(), self:GetTall() - self.TopBar:GetTall())
	self.Canvas.Paint = function(slf, w, h)
		if slf.BGCol then
			surface.SetDrawColor(slf.BGCol)
			surface.DrawRect(0, 0, w, h)
		end
	end
	function self.Canvas:SetBGCol(color)
		self.BGCol = color
	end
	return self.Canvas
end

function PANEL:Init()
	local scrw, scrh = ScrW(), ScrH()
	self.SelectedPanel = "main"
	local windowed = PS.Style_Config.Windowed
	self:SetSize(scrw * (windowed and PS.Style_Config.WindowSize[1] or PS.Style_Config.Size[1]), scrh * (windowed and PS.Style_Config.WindowSize[2] or PS.Style_Config.Size[2]))
	self:Center()
	self.OnScreenSizeChanged = function()
		PS:CloseMenu()
		PS:ToggleMenu()
	end
	self.TopBar = vgui.Create("DPanel",self)
	self.TopBar:SetSize(self:GetWide(), 80)
	self.TopBar:SetPos(0, 0)
	self.TopBar.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.MainTitle)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(PS.Style_Config.Col.MN.BottomLine)
		surface.DrawRect(0, h - 1, w, 1)
		draw.SimpleText("Shop", "PS_Treb_S80", 20, 2, PS.Style_Config.Col.MN.PointShopText)
	end
	local EditStyle = vgui.Create("PS_DSWButton", self.TopBar)
	EditStyle:SetSize(120, 39)
	EditStyle:SetPos(self.TopBar:GetWide() - 480, self.TopBar:GetTall() - 40)
	EditStyle.BoarderCol = Color(0, 0, 0, 0)
	EditStyle:SetTexts("Design anpassen")
	EditStyle.Font = "PS_Treb_S20"
	EditStyle.Click = function(slf)
		vgui.Create("DPointShopDesignOptions")
	end
	local HomeButton = vgui.Create("PS_DSWButton", self.TopBar)
	HomeButton:SetSize(120, 39)
	HomeButton:SetPos(self.TopBar:GetWide() - 360, self.TopBar:GetTall() - 40)
	HomeButton.BoarderCol = Color(0, 0, 0, 0)
	HomeButton:SetTexts("Startseite")
	HomeButton.Font = "PS_Treb_S20"
	HomeButton.Click = function(slf)
		if self.SelectedPanel == "main" then return end
		PS:CloseMenu()
		PS:ToggleMenu()
	end
	local SendPoints = vgui.Create("PS_DSWButton", self.TopBar)
	SendPoints:SetSize(120, 39)
	SendPoints:SetPos(self.TopBar:GetWide() - 240, self.TopBar:GetTall() - 40)
	SendPoints.BoarderCol = Color(0, 0, 0, 0)
	SendPoints:SetTexts(PS.Config.PointsName.." versenden")
	SendPoints.Font = "PS_Treb_S20"
	SendPoints.Click = function(slf)
		vgui.Create("DPointShopGivePoints")
	end
	local CloseButton = vgui.Create("PS_DSWButton", self.TopBar)
	CloseButton:SetSize(120, 39)
	CloseButton:SetPos(self.TopBar:GetWide() - 120, self.TopBar:GetTall() - 40)
	CloseButton.BoarderCol = Color(0, 0, 0, 0)
	CloseButton:SetTexts("Schließen")
	CloseButton.Font = "PS_Treb_S20"
	CloseButton.Click = function(slf)
		PS:CloseMenu()
	end
	self:ReBulidCanvas()
	self:CanvasBuild_Main()
end

function PANEL:Paint()
	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0, 0, ScrW(), ScrH())
end

function PANEL:CanvasBuild_Main()
	self.SelectedPanel = "main"
	local Canvas = self:ReBulidCanvas()
	local Buttons = {}
	table.insert(Buttons,{
		PrintName = "Shop",
		Func = function(Main)
			self:CanvasBuild_Shop()
		end
	})
	table.insert(Buttons,{
		PrintName = "Inventar",
		Func = function()
			self:CanvasBuild_Inventory()
		end
	})
	local ply = LocalPlayer()
	if ((PS.Config.AdminCanAccessAdminTab and ply:IsAdmin()) or (PS.Config.SuperAdminCanAccessAdminTab and ply:IsSuperAdmin())) then
	table.insert(Buttons,{
		PrintName = "Admin-Übersicht",
		Func = function()
			self:CanvasBuild_Admin()
		end
	})
	end
	table.insert(Buttons,{
		PrintName = "Schließen",
		Func = function(Main)
			PS:CloseMenu()
		end
	})
	if PS.Config.DisplayPreviewInMenu then
		local PreviewPanel = vgui.Create("DPointShopPreview", Canvas)
		PreviewPanel:SetSize(Canvas:GetWide(),Canvas:GetTall())
		PreviewPanel:SetPos(0,0)
		PreviewPanel.ZoomHere = 150
	end
	for k, v in ipairs(Buttons) do
		local Button = vgui.Create("PS_DSWButton",Canvas)
		Button:SetSize(Canvas:GetWide()/4,Canvas:GetWide() / 15)
		Button:SetPos(50, 50 + (k - 1) * (Canvas:GetWide() / 15 + 10))
		Button:SetTexts(v.PrintName)
		Button.Font = "PS_Treb_S25"
		Button.Click = function(slf)
			v:Func(self)
		end
		Button:PS_PanelAnim_Appear_FlyIn({Dir = "FromLeft", Speed = 0.8, Smooth = 10, Delay = k / 10})
	end
end

function PANEL:UpdateFilterList(shop)
	if !IsValid(self.FilterLister) then return end
	self.FilterLister:Clear()
	local ListerPanel = self.FilterLister
	local categories = {}
	for _, i in pairs(PS.Categories) do
		table.insert(categories, i)
	end
	table.sort(categories, function(a, b) 
		if a.Order == b.Order then 
			return a.Name < b.Name
		else
			return a.Order < b.Order
		end
	end)

	local ply = LocalPlayer()
	local HIDDEN_ITEMS_CATEGORIES = {}
	local OWNED_ITEMS_CATEGORIES = {}
	for _, ITEM in pairs(PS.Items) do
		if ply:PS_HasItem(ITEM.ID) then
			OWNED_ITEMS_CATEGORIES[ITEM.Category] = (OWNED_ITEMS_CATEGORIES[ITEM.Category] or 0) + 1
		end

		if ITEM.Hidden and !ITEM:CanPlayerSee(ply) then
			HIDDEN_ITEMS_CATEGORIES[ITEM.Category] = (HIDDEN_ITEMS_CATEGORIES[ITEM.Category] or 0) + 1
		end
	end

	for _, CATEGORY in ipairs(categories) do
		if shop and CATEGORY.AllowedUserGroups and #CATEGORY.AllowedUserGroups > 0 then
			if !table.HasValue(CATEGORY.AllowedUserGroups, ply:PS_GetUsergroup()) then
				continue
			end
		end
		if !shop and CATEGORY.CanPlayerSee and !CATEGORY:CanPlayerSee(ply) then continue end
		if !shop and !OWNED_ITEMS_CATEGORIES[CATEGORY.Name] then continue end
		if shop and OWNED_ITEMS_CATEGORIES[CATEGORY.Name] == CATEGORY.ItemCount then continue end
		if shop and (CATEGORY.ItemCount - (HIDDEN_ITEMS_CATEGORIES[CATEGORY.Name] or 0)) == 0 then continue end

		local Button = vgui.Create("PS_DSWButton")
		Button:SetSize(self.FilterLister:GetWide() / 2 - 5, 40)
		Button.Font = "PS_Treb_S20"
		Button:SetTexts("")
		--Button:SetTooltip(CATEGORY.Name)
		Button.BoarderCol = Color(0, 0, 0, 0)
		Button.Click = function(slf)
			ListerPanel.CurCategory = CATEGORY.Name
			if ListerPanel.OnFilterSelected then
				ListerPanel:OnFilterSelected(CATEGORY.Name)
			end
		end

		local hidden_color = Color(150, 0, 0, 50)
		Button.PaintBackGround = function(slf, w, h)
			if CATEGORY.Hidden then
				surface.SetDrawColor(hidden_color)
				surface.DrawRect(1, 1, w - 2, h - 2)
			end

			if ListerPanel.CurCategory and ListerPanel.CurCategory == CATEGORY.Name then
				local col = Color(PS.Style_Config.Col.MN.DSWClickFX.r, PS.Style_Config.Col.MN.DSWClickFX.g, PS.Style_Config.Col.MN.DSWClickFX.b, PS.Style_Config.Col.MN.DSWClickFX.a or 255)
				col.a = 50
				surface.SetDrawColor(col)
				surface.DrawRect(1, 1, w - 2, h - 2)
			end
			if CATEGORY.AllowedEquipped > -1 then
				draw.SimpleText(CATEGORY.Name, slf.Font, w / 2, h / 2 - 5, slf.TextCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText((CategoryLimits[CATEGORY.Name] or 0).." / "..CATEGORY.AllowedEquipped, "PS_Treb_S16", w / 2, h / 2 + 10, PS.Style_Config.Col.MN.DSWBoarderCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(CATEGORY.Name, slf.Font, w / 2, h / 2, slf.TextCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		self.FilterLister:AddItem(Button)
	end
	RecountLimits(ply)
end

function PANEL:CanvasBuild_Admin()
	self.SelectedPanel = "admin"
	local Canvas = self:ReBulidCanvas()
	Canvas:SetBGCol(PS.Style_Config.BGCol.AP_CanvasBG)
	local Title = vgui.Create("DPanel", Canvas)
	Title:SetPos(20, 5)
	Title:SetSize(Canvas:GetWide() - 40,40)
	Title.Paint = function(slf, w, h)
		draw.SimpleText("Spielermanagement", "PS_Treb_S30", w / 2, 10, PS.Style_Config.Col.AP.TitleText,TEXT_ALIGN_CENTER)
	end
	local Button = vgui.Create("PS_DSWButton", Title)
	Button:SetSize(250, 30)
	Button:SetPos(Title:GetWide() - 260, 10)
	Button:SetTexts("Menü")
	Button.Font = "PS_Treb_S25"
	Button.Click = function(slf)
		self:CanvasBuild_Main()
	end
	Button:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 0.8, Smooth = 10, Delay = 0.5})
	local FilterTitle = vgui.Create("DPanel",Canvas)
	FilterTitle:SetPos(50,60)
	FilterTitle:SetSize(Canvas:GetWide() - 100,30)
	FilterTitle.Paint = function(slf)
	end
	local PlayerClick = function()
	end
	local PlayerList = vgui.Create("DPanelList", Canvas)
	local Button = vgui.Create("PS_DSWButton",FilterTitle)
	Button:SetSize(100, 30)
	Button:SetPos(0, 0)
	Button:SetTexts("Nr.")
	Button.Font = "PS_Treb_S25"
	Button.BoarderCol = Color(0, 0, 0, 0)
	Button.Click = function(slf)
		PlayerList:ReBuild("Num")
	end
	local Button = vgui.Create("PS_DSWButton",FilterTitle)
	Button:SetSize(300, 30)
	Button:SetPos(FilterTitle:GetWide() / 5 * 2 - 150,0)
	Button:SetTexts("Name")
	Button.Font = "PS_Treb_S25"
	Button.BoarderCol = Color(0, 0, 0, 0)
	Button.Click = function(slf)
		PlayerList:ReBuild("Nick")
	end
	local Button = vgui.Create("PS_DSWButton",FilterTitle)
	Button:SetSize(100, 30)
	Button:SetPos(FilterTitle:GetWide() - 200,0)
	Button:SetTexts(PS.Config.PointsName)
	Button.Font = "PS_Treb_S25"
	Button.BoarderCol = Color(0, 0, 0, 0)
	Button.Click = function(slf)
		PlayerList:ReBuild("Points")
	end
	local Button = vgui.Create("PS_DSWButton",FilterTitle)
	Button:SetSize(100, 30)
	Button:SetPos(FilterTitle:GetWide() - 100,0)
	Button:SetTexts("Items")
	Button.Font = "PS_Treb_S25"
	Button.BoarderCol = Color(0, 0, 0, 0)
	Button.Click = function(slf)
		PlayerList:ReBuild("Items")
	end
	PlayerList:SetPos(50, 90)
	PlayerList:SetSize(Canvas:GetWide() - 100, Canvas:GetTall() - 120)
	PlayerList:SetSpacing(0)
	PlayerList:SetPadding(0)
	PlayerList:EnableVerticalScrollbar(true)
	PlayerList:EnableHorizontal(true)
	PlayerList:PS_PaintListBar()
	PlayerList.Paint = function(slf) end
	local Dir = true
	PlayerList.ReBuild = function(slf,Order)
		local list = {}
		for k, v in ipairs(player.GetAll()) do
			local ply_list = {}
			ply_list.Num = k
			ply_list.Points = string.Comma(v:PS_GetPoints())
			ply_list.Items = table.Count(v:PS_GetItems())
			ply_list.Nick = v:Name()
			ply_list.Ply = v
			table.insert(list, ply_list)
		end
		slf:Clear()
		slf.Order = slf.Order or Order
		if Order == slf.Order then
			if !Dir then 
				Dir = true 
			else 
				Dir = false 
			end
		end
		slf.Order = Order
		if Dir then
			table.SortByMember(list, Order)
		else
			table.SortByMember(list, Order, function(a, b) return a < b end)
		end
		for k, v in ipairs(list) do
			local BGP = vgui.Create("PS_DSWButton")
			BGP:SetSize(PlayerList:GetWide(), 30)
			BGP:SetTexts("")
			BGP.BoarderCol = Color(0, 0, 0, 0)
			BGP.Count = k%2
			BGP.Click = function(slf)
				PlayerClick(v.Ply)
			end
			BGP.Think = function(slf)
				if !IsValid(v.Ply) then
					slf:Remove()
				end
			end
			local num = v.Num
			local ply = v.Ply
			local items = table.Count(ply:PS_GetItems())
			local itemsupdate = CurTime() + 1
			BGP.PaintOverlay = function(slf, w, h)
				draw.SimpleText("Nr."..num, "PS_Treb_S22", 10, 2, PS.Style_Config.Col.AP.List_No)
				draw.SimpleText(ply:Name(), "PS_Treb_S22", w / 5 * 2, 2, PS.Style_Config.Col.AP.List_PlayerNick, TEXT_ALIGN_CENTER)
				draw.SimpleText(string.Comma(ply:PS_GetPoints()), "PS_Treb_S22", w - 150, 2, PS.Style_Config.Col.AP.List_PlayerPoints, TEXT_ALIGN_CENTER)
				if itemsupdate > CurTime() then
					itemsupdate = CurTime() + 1
					items = table.Count(ply:PS_GetItems())
				end
				draw.SimpleText(items, "PS_Treb_S22", w - 50, 2, PS.Style_Config.Col.AP.List_PlayerItems, TEXT_ALIGN_CENTER)
			end
			BGP.PaintBackGround = function(slf, w, h)
				surface.SetDrawColor(Color(0, 10, slf.Count * 10 + 10, 120))
				surface.DrawRect(1, 1, w - 2, h - 2)
				surface.SetDrawColor(PS.Style_Config.Col.AP.ListBottomLine)
				surface.DrawRect(1, h - 1, w - 2, 1)
			end
			BGP:PS_PanelAnim_Fade({Speed = 0.5, Fade = 100, Delay = k / 50})
			PlayerList:AddItem(BGP)
		end	
	end
	PlayerList:ReBuild("Num")
	PlayerClick = function(ply)
		local menu = DermaMenu(self)
		menu:SetSkin("PS_DermaMenu")
		menu:AddOption(PS.Config.PointsName.." setzen", function()
			surface.PlaySound("ui/buttonclick.wav")
			PS:ShowSearch(PS.Config.PointsName.." von "..ply:GetName().." setzen", function(str)
				if !str or !tonumber(str) then return end
				surface.PlaySound("ui/buttonclick.wav")
				net.Start("PS_SetPoints")
					net.WriteEntity(ply)
					net.WriteUInt(tonumber(str), 32)
				net.SendToServer()
			end)
		end):SetIcon("icon16/money.png")
		menu:AddOption(PS.Config.PointsName.." geben", function()
			surface.PlaySound("ui/buttonclick.wav")
			PS:ShowSearch(PS.Config.PointsName.." an "..ply:GetName().." geben", function(str)
				if !tonumber(str) then return end
				surface.PlaySound("ui/buttonclick.wav")
				net.Start("PS_GivePoints")
					net.WriteEntity(ply)
					net.WriteUInt(tonumber(str), 32)
				net.SendToServer()
			end)
		end):SetIcon("icon16/money_add.png")
		menu:AddOption(PS.Config.PointsName.." nehmen", function()
			surface.PlaySound("ui/buttonclick.wav")
			PS:ShowSearch(PS.Config.PointsName.." von "..ply:GetName().." nehmen", function(str)
				if !tonumber(str) then return end
				surface.PlaySound("ui/buttonclick.wav")
				net.Start("PS_TakePoints")
					net.WriteEntity(ply)
					net.WriteUInt(tonumber(str), 32)
				net.SendToServer()
			end)
		end):SetIcon("icon16/money_delete.png")
		menu:AddSpacer()
		local men, parent = menu:AddSubMenu("Item geben")
		BuildItemMenu(men, ply, UNOWNED_ITEMS, function(item_id)
			surface.PlaySound("ui/buttonclick.wav")
			net.Start("PS_GiveItem")
				net.WriteEntity(ply)
				net.WriteString(item_id)
			net.SendToServer()
		end)
		parent:SetIcon("icon16/brick_add.png")
		local men, parent = menu:AddSubMenu("Item nehmen")
		BuildItemMenu(men, ply, OWNED_ITEMS, function(item_id)
			surface.PlaySound("ui/buttonclick.wav")
			net.Start("PS_TakeItem")
				net.WriteEntity(ply)
				net.WriteString(item_id)
			net.SendToServer()
		end)
		parent:SetIcon("icon16/brick_delete.png")
		menu:Open()
	end
end

local function AddWeaponToolTip(class, item)
	local wep = weapons.GetStored(class)
	if wep then
		local dmg, clip, automatic, rpm, spread, recoil, ammo
		if CustomizableWeaponry then
			local function GetStuff(tbl)
				local total = 0
				local count = #tbl
				for k=1, #tbl do
					total = total + tbl[k]
				end

				return total / count
			end

			local primary = wep.Primary
			dmg = wep.Damage or (wep.PrimaryAttackDamage and (istable(wep.PrimaryAttackDamage) and GetStuff(wep.PrimaryAttackDamage) or wep.PrimaryAttackDamage)) or "N/A"
			clip = primary and primary.ClipSize and primary.ClipSize >= 0 and primary.ClipSize or "N/A"
			automatic = primary and primary.Automatic and "Ja" or "Nein"
			rpm = wep.FireDelay and math.Round(1 / (wep.FireDelay / 60)) or "N/A"
			spread = wep.HipSpread or "N/A"
			recoil = wep.Recoil or "N/A"
			ammo = primary and primary.Ammo and (LANG and LANG.GetUnsafeNamed("ammo_"..string.lower(primary.Ammo)) or language.GetPhrase(primary.Ammo.."_ammo") != primary.Ammo.."_ammo" and language.GetPhrase(primary.Ammo.."_ammo")) or "N/A"
		else
			local primary = wep.Primary
			dmg = primary and primary.Damage and primary.Damage >= 0 and math.Round(primary.Damage * (primary.NumShots or 1)) or "N/A"
			clip = primary and primary.ClipSize and primary.ClipSize >= 0 and primary.ClipSize or "N/A"
			automatic = primary and primary.Automatic and "Ja" or "Nein"
			rpm = primary and (primary.Delay and math.Round(1 / (primary.Delay / 60)) or primary.RPM or "N/A") or "N/A"
			spread = primary and (primary.Cone and primary.Cone or primary.Spread or "N/A") or "N/A"
			recoil = primary and (primary.Recoil and primary.Recoil or primary.KickUp or "N/A") or "N/A"
			ammo = primary and primary.Ammo and (LANG and LANG.GetUnsafeNamed("ammo_"..string.lower(primary.Ammo)) or language.GetPhrase(primary.Ammo.."_ammo") != primary.Ammo.."_ammo" and language.GetPhrase(primary.Ammo.."_ammo")) or "N/A"
		end

		item:SetTooltip("Schaden: "..dmg.."\nMagazin: "..clip.."\nAutomatisch: "..automatic.."\nRPM: "..rpm.."\nPräzision: "..spread.."\nRückstoß: "..recoil.."\nMunition: "..ammo)
	else
		item:SetTooltip("Informationen nicht abrufbar!")
	end
end

local ItemList = {}
function PANEL:CanvasBuild_Inventory()
	self.SelectedPanel = "inv"
	local Canvas = self:ReBulidCanvas()
	Canvas:SetBGCol(PS.Style_Config.BGCol.InvCanvasBG)
	local PreviewPanel = vgui.Create("DPointShopPreview", Canvas)
	PreviewPanel:SetSize(Canvas:GetWide() / 7 * 4,Canvas:GetTall() - 40)
	PreviewPanel:SetPos(Canvas:GetWide() / 7 * 3, 20)
	PreviewPanel:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 1.2, Smooth = 10, Delay = 0.2})
	local Button = vgui.Create("PS_DSWButton",Canvas)
	Button:SetSize(Canvas:GetWide() / 4, Canvas:GetWide() / 16)
	Button:SetPos(Canvas:GetWide() - Button:GetWide() - 10, 10)
	Button:SetTexts("Menü")
	Button.Font = "PS_Treb_S25"
	Button.Click = function(slf)
		self:CanvasBuild_Main()
	end
	Button:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 0.8, Smooth = 10, Delay = 0.5})
	local Button = vgui.Create("PS_DSWButton", Canvas)
	Button:SetSize(Canvas:GetWide() / 4,Canvas:GetWide() / 16)
	Button:SetPos(Canvas:GetWide() - Button:GetWide() - 10, Button:GetTall() + 16)
	Button:SetTexts("Shop")
	Button.Font = "PS_Treb_S25"
	Button.Click = function(slf)
		self:CanvasBuild_Shop()
	end
	Button:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 0.8, Smooth = 10, Delay = 0.7})
	local Title = vgui.Create("DPanel",Canvas)
	Title:SetPos(20, 5)
	Title:SetSize(Canvas:GetWide() / 7 * 3 - 40, 40)
	local ply = LocalPlayer()
	Title.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.InvTitleBG)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("Inventar", "PS_Treb_S30", 10, 10, PS.Style_Config.Col.Inv.InvTitle, TEXT_ALIGN_LEFT)
		draw.SimpleText("Du hast "..string.Comma(ply:PS_GetPoints()).." "..PS.Config.PointsName, "PS_Treb_S20", w - 10, 20, PS.Style_Config.Col.SP.MyPoints, TEXT_ALIGN_RIGHT)
	end
	local LeftMaster = vgui.Create("DPanel",Canvas)
	LeftMaster:SetPos(20, 50)
	LeftMaster:SetSize(Canvas:GetWide() / 7 * 3 - 40,Canvas:GetTall() - 60)
	LeftMaster:PS_PanelAnim_Appear_FlyIn({Dir = "FromLeft", Speed = 0.8, Smooth = 10})
	LeftMaster.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.InvLeftCanvasBG)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("Filter", "PS_Treb_S30", 10, 10, PS.Style_Config.Col.Inv.FilterTitleText, TEXT_ALIGN_LEFT)
		if IsValid(self.InvList) and !table.IsEmpty(self.InvList:GetItems()) then
			draw.SimpleText("Gegenstände ("..ItemCount..")", "PS_Treb_S30", 10, 170, PS.Style_Config.Col.SP.FilterTitleText, TEXT_ALIGN_LEFT)
		end
	end
	local Sort = vgui.Create("PS_DSWButton", Canvas)
	Sort:SetPos(LeftMaster:GetWide() - 190, 220)
	Sort:SetSize(200, 25)
	Sort.Font = "PS_Treb_S19"
	Sort:SetTexts("Sortieren nach: "..(PS.Config.SortItemsBy == "Name" and "Name" or "Preis").." ↑")
	Sort.SortBy = PS.Config.SortItemsBy == "Name" and "Name" or "Price"
	Sort.SortDir = true
	Sort.Click = function(slf)
		local menu = DermaMenu()
		menu:SetSkin("PS_DermaMenu")
		for _, v in ipairs(SortStuff) do
			menu:AddOption(v[2].." ↑", function()
				slf.SortBy = v[1]
				slf.SortDir = !v[3] and true or false
				self.InvList:UpdateList(nil, nil, true)
				Sort:SetTexts("Sortieren nach: "..v[2].." ↑")
				surface.PlaySound("ui/buttonclick.wav")
			end)
			menu:AddOption(v[2].." ↓", function()
				slf.SortBy = v[1]
				slf.SortDir = v[3] and true or false
				self.InvList:UpdateList(nil, nil, true)
				Sort:SetTexts("Sortieren nach: "..v[2].." ↓")
				surface.PlaySound("ui/buttonclick.wav")
			end)
		end
		menu:Open()
	end
	Sort:PS_PanelAnim_Appear_FlyIn({Dir = "FromLeft", Speed = 0.8, Smooth = 10})
	local FilterList = vgui.Create("DPanelList", LeftMaster)
	self.FilterLister = FilterList
	FilterList:SetPos(10, 40)
	FilterList:SetSize(LeftMaster:GetWide() - 20, 120)
	FilterList:SetSpacing(0)
	FilterList:SetPadding(0)
	FilterList:EnableVerticalScrollbar(true)
	FilterList:EnableHorizontal(true)
	FilterList:PS_PaintListBar()
	FilterList.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.InvFilterLister)
		surface.DrawRect(0, 0, w, h)
	end
	FilterList.OnFilterSelected = function(slf, FilterName)
		if slf.InvList then
			slf.InvList:UpdateList(FilterName, true)
		end
	end
	self:UpdateFilterList(false)
	local InvList = vgui.Create("DPanelList", LeftMaster)
	FilterList.InvList = InvList
	self.InvList = InvList
	InvList:SetPos(10, 200)
	InvList:SetSize(LeftMaster:GetWide() - 20, LeftMaster:GetTall() - 210)
	InvList:SetSpacing(0)
	InvList:SetPadding(0)
	InvList:EnableVerticalScrollbar(true)
	InvList:EnableHorizontal(false)
	InvList:PS_PaintListBar()
	InvList.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.InvItemsLister)
		surface.DrawRect(0, 0, w, h)
	end
	function InvList:UpdateList(FilterName, Fade, Clear)
		if FilterName then
			self.LastFilterName = FilterName
		end
		FilterName = FilterName or self.LastFilterName
		if !FilterName then return end
		if Clear then
			self:Clear()
			ItemList = {}
		end
		local items = {}
		local not_equipped = {}
		for _, ITEM in pairs(PS.Items) do
			if ITEM.Category == FilterName then
				if ply:PS_HasItemEquipped(ITEM.ID) or (!PS.Config.SortItemsByOwned and ply:PS_HasItem(ITEM.ID)) then
					table.insert(items, ITEM)
				elseif ply:PS_HasItem(ITEM.ID) then
					table.insert(not_equipped, ITEM)
				end
			end
		end
		if PS.Config.SortItemsByOwned then
			if Sort.SortDir then
				table.SortByMember(not_equipped, Sort.SortBy, true)
				table.SortByMember(items, Sort.SortBy, true)
			else
				table.SortByMember(not_equipped, Sort.SortBy, false)
				table.SortByMember(items, Sort.SortBy, false)
			end
			table.Add(items, not_equipped)
		else
			if Sort.SortDir then
				table.SortByMember(items, Sort.SortBy, true)
			else
				table.SortByMember(items, Sort.SortBy, false)
			end
		end
		local cnt = 0
		local cur_time = SysTime()
		ItemCount = 0
		for _, ITEM in ipairs(items) do
			local item = ItemList[ITEM]
			if IsValid(item) then
				item.PreventRemoval = cur_time
				ItemCount = ItemCount + 1
				continue
			end
			cnt = cnt + 1
			local price = PS.Config.CalculateSellPrice(ply, ITEM)
			ItemList[ITEM] = vgui.Create("PS_DSWButton")
			item = ItemList[ITEM]
			item.PreventRemoval = cur_time
			item.BoarderCol = Color(0, 0, 0, 0)
			item.TextCol = Color(0, 0, 150, 255)
			item:SetSize(self:GetWide(), 70)
			item:SetTexts("")
			item.Count = cnt % 2
			item.FXCol = PS.Style_Config.Col.Inv.ListItemHoverCol
			local name = ITEM.Name
			local id = ITEM.ID
			item.PaintOverlay = function(slf, w, h)
				draw.SimpleText(name, "PS_Treb_S30", h + 5, 2, PS.Style_Config.Col.Inv.ListItemName)
				draw.SimpleText("Verkaufspreis: "..string.Comma(price), "PS_Treb_S25", w - 5, h - 25, PS.Style_Config.Col.Inv.ListItemRefund, TEXT_ALIGN_RIGHT)
				if ply:PS_HasItemEquipped(id) then
					draw.SimpleText("Ausgerüstet", "PS_Treb_S25", w - 5, 2, PS.Style_Config.Col.Inv.ListEquippedText, TEXT_ALIGN_RIGHT)
				end
				local text = ""
				if ITEM.EquipGroup != "znone" and ITEM.MaxEquip and ITEM.MaxEquip > -1 then
					text = ITEM.EquipGroup..": "..(EquipLimits[ITEM.EquipGroup] or 0).."/"..ITEM.MaxEquip
				end

				if ITEM.Weight and ITEM.Weight != 1 then
					local weight = ITEM.Weight >= (ITEM.AllowedEquipped or -1) and "alle" or ITEM.Weight
					if text != "" then
						text = text..", verbraucht "..weight.." Plätze"
					else
						text = "Verbraucht "..weight.." Plätze"
					end
				end
				if text != "" then
					draw.SimpleText(text, "PS_Treb_S20", h + 6, h - 45, PS.Style_Config.Col.SP.ListItemPrice)
				end
			end
			local hidden_color = Color(255, 0, 0, 255)
			item.PaintBackGround = function(slf, w, h)
				surface.SetDrawColor(Color(0, 10, slf.Count * 10 + 10, 120))
				surface.DrawRect(1, 1, w - 2, h - 2)
			   	surface.SetDrawColor(PS.Style_Config.Col.Inv.ListBottomLine)
				surface.DrawRect(1, h - 1, w - 2, 1)
			end
			item.CursorEnter = function(slf)
				if slf.Icon then
					slf.Icon:OnCursorEntered()
				end
			end
			item.CursorExit = function(slf)
			   	if slf.Icon then
					slf.Icon:OnCursorExited()
				end
			end
			if Fade then
				item:PS_PanelAnim_Fade({Speed = 0.5, Fade = 100, Delay = cnt / 50})
			end
			if ITEM.Description then
				item:SetTooltip(ITEM.Description)
			elseif ITEM.WeaponClass then
				AddWeaponToolTip(ITEM.WeaponClass, item)
			end
			local model = vgui.Create("DPointShopItem", item)
			item.Icon = model
			model:SetData(ITEM)
			model:SetPos(1, 1)
			model:SetSize(item:GetTall() - 2, item:GetTall() - 2)
			if ITEM.Hidden then
				model.BGCol = Color(200, 0, 0, 75)
			end
			item.Click = function(slf)
				model:DoClick()
			end
			self:AddItem(item)
			ItemCount = ItemCount + 1
		end
		for k, v in pairs(ItemList) do
			if IsValid(v) then
				if v.PreventRemoval != cur_time then
					v:Remove()
					ItemList[k] = nil
				end
			else
				ItemList[k] = nil
			end
		end
		RecountLimits(ply)
	end
end

local ShopItemList = {}
function PANEL:CanvasBuild_Shop()
	self.SelectedPanel = "shop"
	local Canvas = self:ReBulidCanvas()
	Canvas:SetBGCol(PS.Style_Config.BGCol.ShopCanvasBG)
	local PreviewPanel = vgui.Create("DPointShopPreview", Canvas)
	PreviewPanel:SetSize(Canvas:GetWide() / 7 * 4, Canvas:GetTall() - 40)
	PreviewPanel:SetPos(Canvas:GetWide() / 7 * 3, 20)
	PreviewPanel:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 1.2, Smooth = 10, Delay = 0.2})
	local Button = vgui.Create("PS_DSWButton", Canvas)
	Button:SetSize(Canvas:GetWide() / 4, Canvas:GetWide() / 16)
	Button:SetPos(Canvas:GetWide() - Button:GetWide() - 10, 10)
	Button:SetTexts("Menü")
	Button.Font = "PS_Treb_S25"
	Button.Click = function(slf)
		self:CanvasBuild_Main()
	end
	Button:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 0.8, Smooth = 10, Delay = 0.5})
	local Button = vgui.Create("PS_DSWButton", Canvas)
	Button:SetSize(Canvas:GetWide() / 4,Canvas:GetWide() / 16)
	Button:SetPos(Canvas:GetWide() - Button:GetWide() - 10, Button:GetTall() + 16)
	Button:SetTexts("Inventar")
	Button.Font = "PS_Treb_S25"
	Button.Click = function(slf)
		self:CanvasBuild_Inventory()
	end
	Button:PS_PanelAnim_Appear_FlyIn({Dir = "FromRight", Speed = 0.8, Smooth = 10, Delay = 0.7})
	local Title = vgui.Create("DPanel", Canvas)
	Title:SetPos(20, 5)
	Title:SetSize(Canvas:GetWide() / 7 * 3 - 40, 40)
	local ply = LocalPlayer()
	Title.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.ShopTitleBG)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("Shop", "PS_Treb_S30", 10, 10, PS.Style_Config.Col.SP.ShopTitle, TEXT_ALIGN_LEFT)
		draw.SimpleText("Du hast "..string.Comma(ply:PS_GetPoints()).." "..PS.Config.PointsName, "PS_Treb_S20", w - 10, 20, PS.Style_Config.Col.SP.MyPoints, TEXT_ALIGN_RIGHT)
	end
	local LeftMaster = vgui.Create("DPanel", Canvas)
	LeftMaster:SetPos(20, 50)
	LeftMaster:SetSize(Canvas:GetWide() / 7 * 3 - 40, Canvas:GetTall() - 60)
	LeftMaster:PS_PanelAnim_Appear_FlyIn({Dir = "FromLeft", Speed = 0.8, Smooth = 10})
	LeftMaster.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.ShopLeftCanvasBG)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText("Filter", "PS_Treb_S30", 10, 10, PS.Style_Config.Col.SP.FilterTitleText, TEXT_ALIGN_LEFT)
		if IsValid(self.ShopList) and !table.IsEmpty(self.ShopList:GetItems()) then
			draw.SimpleText("Gegenstände ("..ItemCount..")", "PS_Treb_S30", 10, 170, PS.Style_Config.Col.SP.FilterTitleText, TEXT_ALIGN_LEFT)
		end
	end
	local Sort = vgui.Create("PS_DSWButton", Canvas)
	Sort:SetPos(LeftMaster:GetWide() - 190, 220)
	Sort:SetSize(200, 25)
	Sort.Font = "PS_Treb_S19"
	Sort:SetTexts("Sortieren nach: "..(PS.Config.SortItemsBy == "Name" and "Name" or "Preis").." ↑")
	Sort.SortBy = PS.Config.SortItemsBy == "Name" and "Name" or "Price"
	Sort.SortDir = true
	Sort.Click = function(slf)
		local menu = DermaMenu()
		menu:SetSkin("PS_DermaMenu")
		for _, v in ipairs(SortStuff) do
			menu:AddOption(v[2].." ↑", function()
				slf.SortBy = v[1]
				slf.SortDir = !v[3] and true or false
				self.ShopList:UpdateList(nil, nil, true)
				Sort:SetTexts("Sortieren nach: "..v[2].." ↑")
				surface.PlaySound("ui/buttonclick.wav")
			end)
			menu:AddOption(v[2].." ↓", function()
				slf.SortBy = v[1]
				slf.SortDir = v[3] and true or false
				self.ShopList:UpdateList(nil, nil, true)
				Sort:SetTexts("Sortieren nach: "..v[2].." ↓")
				surface.PlaySound("ui/buttonclick.wav")
			end)
		end
		menu:Open()
	end
	Sort:PS_PanelAnim_Appear_FlyIn({Dir = "FromLeft", Speed = 0.8, Smooth = 10})
	local FilterList = vgui.Create("DPanelList", LeftMaster)
	self.FilterLister = FilterList
	FilterList:SetPos(10, 40)
	FilterList:SetSize(LeftMaster:GetWide() - 20, 120)
	FilterList:SetSpacing(0)
	FilterList:SetPadding(0)
	FilterList:EnableVerticalScrollbar(true)
	FilterList:EnableHorizontal(true)
	FilterList:PS_PaintListBar()
	FilterList.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.ShopFilterLister)
		surface.DrawRect(0, 0, w, h)
	end
	FilterList.OnFilterSelected = function(slf, FilterName)
		if slf.ShopList then
			slf.ShopList:UpdateList(FilterName, true)
		end
	end
	self:UpdateFilterList(true)
	local ShopList = vgui.Create("DPanelList", LeftMaster)
	FilterList.ShopList = ShopList
	self.ShopList = ShopList
	ShopList:SetPos(10, 200)
	ShopList:SetSize(LeftMaster:GetWide() - 20, LeftMaster:GetTall() - 210)
	ShopList:SetSpacing(0)
	ShopList:SetPadding(0)
	ShopList:EnableVerticalScrollbar(true)
	ShopList:EnableHorizontal(false)
	ShopList:PS_PaintListBar()
	ShopList.Paint = function(slf, w, h)
		surface.SetDrawColor(PS.Style_Config.BGCol.ShopItemsLister)
		surface.DrawRect(0, 0, w, h)
	end
	function ShopList:UpdateList(FilterName, Fade, Clear)
		if FilterName then
			self.LastFilterName = FilterName
		end
		FilterName = FilterName or self.LastFilterName
		if !FilterName then return end
		if Clear then
			self:Clear()
			ShopItemList = {}
		end
		local items = {}
		
		for _, ITEM in pairs(PS.Items) do
			if ITEM.Category == FilterName and !ply:PS_HasItem(ITEM.ID) then
				if ITEM.CanPlayerSee and !ITEM:CanPlayerSee(ply) then continue end
				table.insert(items, ITEM)
			end
		end

		if Sort.SortDir then
			table.SortByMember(items, Sort.SortBy, true)
		else
			table.SortByMember(items, Sort.SortBy, false)
		end
		local cnt = 0
		local cur_time = SysTime()
		ItemCount = 0
		for _, ITEM in ipairs(items) do
			local item = ShopItemList[ITEM]
			if IsValid(item) then
				item.PreventRemoval = cur_time
				ItemCount = ItemCount + 1
				continue
			end
			cnt = cnt + 1
			local price = PS.Config.CalculateBuyPrice(ply, ITEM)
			ShopItemList[ITEM] = vgui.Create("PS_DSWButton")
			item = ShopItemList[ITEM]
			item.PreventRemoval = cur_time
			item.BoarderCol = Color(0, 0, 0, 0)
			item.TextCol = Color(0, 0, 150, 255)
			item:SetSize(self:GetWide(), 70)
			item:SetTexts("")
			item.Count = cnt % 2
			item.FXCol = PS.Style_Config.Col.SP.ListItemHoverCol
			local name = ITEM.Name
			item.PaintOverlay = function(slf, w, h)
				draw.SimpleText(name, "PS_Treb_S30", h + 5, 2, PS.Style_Config.Col.SP.ListItemName)
				draw.SimpleText("Preis: "..string.Comma(price), "PS_Treb_S25", w - 5, h - 25, ply:PS_HasPoints(price) and PS.Style_Config.Col.SP.ListItemPrice or PS.Style_Config.Col.SP.ListItemPrice_No, TEXT_ALIGN_RIGHT)
				local text = ""
				if ITEM.EquipGroup != "znone" and ITEM.MaxEquip and ITEM.MaxEquip > -1 then
					text = ITEM.EquipGroup..": "..(EquipLimits[ITEM.EquipGroup] or 0).."/"..ITEM.MaxEquip
				end
				if ITEM.Weight and ITEM.Weight != 1 then
					local weight = ITEM.Weight >= (ITEM.AllowedEquipped or -1) and "alle" or ITEM.Weight
					if text != "" then
						text = text..", verbraucht "..weight.." Plätze"
					else
						text = "Verbraucht "..weight.." Plätze"
					end
				end
				if text != "" then
					draw.SimpleText(text, "PS_Treb_S20", h + 6, h - 45, PS.Style_Config.Col.SP.ListItemPrice)
				end
			end
			item.PaintBackGround = function(slf, w, h)
				surface.SetDrawColor(Color(0, 10, slf.Count * 10 + 10, 120))
				surface.DrawRect(1, 1, w - 2, h - 2)
				surface.SetDrawColor(PS.Style_Config.Col.SP.ListBottomLine)
				surface.DrawRect(1, h - 1, w - 2, 1)
			end
			item.CursorEnter = function(slf)
				if slf.Icon then
					slf.Icon:OnCursorEntered()
				end
			end
			item.CursorExit = function(slf)
				if slf.Icon then
					slf.Icon:OnCursorExited()
				end
			end
			if Fade then
				item:PS_PanelAnim_Fade({Speed = 0.5, Fade = 100, Delay = cnt / 50})
			end
			if ITEM.Description then
				item:SetTooltip(ITEM.Description)
			elseif ITEM.WeaponClass then
				AddWeaponToolTip(ITEM.WeaponClass, item)
			end
			local model = vgui.Create("DPointShopItem", item)
			item.Icon = model
			model:SetData(ITEM)
			model:SetPos(1, 1)
			model:SetSize(item:GetTall() - 2, item:GetTall() - 2)
			if ITEM.Hidden then
				model.BGCol = Color(200, 0, 0, 75)
			end
			item.Click = function(slf)
				model:DoClick()
			end
			self:AddItem(item)
			ItemCount = ItemCount + 1
		end
		for k, v in pairs(ShopItemList) do
			if IsValid(v) then
				if v.PreventRemoval != cur_time then
					v:Remove()
					ShopItemList[k] = nil
				end
			else
				ShopItemList[k] = nil
			end
		end
		RecountLimits(ply)
	end
end
vgui.Register("DPointShopMenu", PANEL)