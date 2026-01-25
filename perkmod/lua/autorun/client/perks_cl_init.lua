local use_font = "Aero Matics Display"
surface.CreateFont("Perks_MenuFont", {font = use_font, size = 16, weight = 400, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont2", {font = use_font, size = 17, weight = 1000, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont3", {font = use_font, size = 24, weight = 1000, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont4", {font = use_font, size = 24, weight = 1000, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont5", {font = use_font, size = 48, weight = 1000, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont6", {font = use_font, size = 18, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont7", {font = use_font, size = 18, weight = 100, blursize = 0, scanlines = 0, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont8", {font = use_font, size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, shadow = false})
surface.CreateFont("Perks_MenuFont9", {font = use_font, size = 14, weight = 1000, blursize = 0, scanlines = 0, antialias = true, shadow = false})
surface.CreateFont("Perks_LevelNote_Text1", {font = use_font, size = 32, weight = 400, blursize = 0, scanlines = 0, antialias = true, shadow = true})
surface.CreateFont("Perks_LevelNote_Text2", {font = use_font, size = 24, weight = 400, blursize = 0, scanlines = 0, antialias = true, shadow = true})
surface.CreateFont("Perks_LevelNote_Text3", {font = use_font, size = 16, weight = 100, blursize = 0, scanlines = 0, antialias = true, shadow = false})
surface.CreateFont("Perks_LevelBar", {font = "Roboto", size = 18, weight = 400, blursize = 0, scanlines = 0, antialias = true, shadow = true})

PlayerPerks = {}

local levelnote_prestige = false
local levelnote_starttime = 0

local function PerkNotify(msg, typ, len)
	notification.AddLegacy(msg, typ, len)
	print(msg)
end

net.Receive("Perks_SendNotify", function()
	local typ = net.ReadUInt(4)
	local len = net.ReadUInt(8)
	local msg = net.ReadString()
	PerkNotify(msg, typ, len)
end)

net.Receive("Perks_AddNote", function()
	levelnote_prestige = net.ReadBool()
	levelnote_starttime = CurTime() + 10
	surface.PlaySound("garrysmod/save_load1.wav")
end)

local showlevelup = CreateClientConVar("cl_showlevelup", 1, FCVAR_ARCHIVE)
local function DrawLevelNote()
	if !showlevelup:GetBool() then return end
	local cur_time = CurTime()
	if levelnote_starttime > cur_time then
		local yoffs = math.Clamp((cur_time - (levelnote_starttime - 10)) * 500, 0, 120)
		surface.SetDrawColor(40, 40, 40, 250)
		draw.NoTexture()
		local scr_w = ScrW()
		surface.DrawPoly({{x = scr_w / 2, y = yoffs + 30}, {x = scr_w / 2 + 10, y = yoffs + 40}, {x = scr_w / 2 - 10, y = yoffs + 40}})
		if levelnote_prestige then
			surface.DrawRect(scr_w / 2 - 125, yoffs + 40, 250, 80)
			draw.SimpleText("Prestige erhöht!", "Perks_LevelNote_Text1", scr_w / 2, yoffs + 60, Color(255, 255, 255, 253), 1, 1)
			local prestige = LocalPlayer():GetPrestige()
			draw.SimpleText("Du bist nun Prestige "..prestige.."!", "Perks_LevelNote_Text2", scr_w / 2, yoffs + 85, Color(255, 255, 255, 253), 1, 1)
			draw.SimpleText("Alle Perks haben nun einen Bonus von "..(prestige * PerkConfig.PrestigeMultiplier).."%!", "Perks_LevelNote_Text3", scr_w / 2, yoffs + 110, Color(255, 255, 255, 253), 1, 1)
		else
			surface.DrawRect(scr_w / 2 - 100, yoffs + 40, 200, 80)
			draw.SimpleText("Level erhöht!", "Perks_LevelNote_Text1", scr_w / 2, yoffs + 60, Color(255, 255, 255, 253), 1, 1)
			draw.SimpleText("Du bist nun Level "..LocalPlayer():GetPerkVar("Level").."!", "Perks_LevelNote_Text2", scr_w / 2, yoffs + 85, Color(255, 255, 255, 253), 1, 1)
			draw.SimpleText("Drücke "..PerkConfig.KeyName..", um dich zu verbessern!", "Perks_LevelNote_Text3", scr_w / 2, yoffs + 110, Color(255, 255, 255, 253), 1, 1)
		end
	end
end
hook.Add("HUDPaint", "Perks_DrawLevelNote", DrawLevelNote, HOOK_MONITOR_LOW or 2)

local function DrawLevelbar(x, y, w, h, bgcolor, barcolor, textcolor, text_left, font_left, text_mid, font_mid, text_right, font_right, val, baralign)
	draw.RoundedBox(0, x, y, w, h, bgcolor)
	if !baralign then
		draw.RoundedBox(0, x, y, w * val, h, barcolor)
	else
		draw.RoundedBox(0, x + w - w * val, y, w * val, h, barcolor)
	end
	if text_left then
		surface.SetFont(font_left)
		local tw, th = surface.GetTextSize(text_left)
		surface.SetTextColor(textcolor)
		surface.SetTextPos(x + 12, y + h / 2 - th / 2)
		surface.DrawText(text_left, 10, 10)
	end
	if text_mid then
		surface.SetFont(font_mid)
		local tw, th = surface.GetTextSize(text_mid)
		surface.SetTextColor(textcolor)
		surface.SetTextPos(x + w / 2 - tw / 2, y + h / 2 - th / 2)
		surface.DrawText(text_mid, 10, 10)
	end
	if text_right then
		surface.SetFont(font_right)
		local tw, th = surface.GetTextSize(text_right)
		surface.SetTextColor(textcolor)
		surface.SetTextPos(x + w - 12 - tw, y + h / 2 - th / 2)
		surface.DrawText(text_right, 10, 10)
	end
end

local no_limit = CreateClientConVar("cl_nolvllimit", 0, true, true)
local showlevelbar = CreateClientConVar("cl_showlevelbar", 1, FCVAR_ARCHIVE)
local progress_bar, ply
local color1, color2 = Color(40, 40, 40, 230), Color(37, 74, 107, 230)
local function DrawLevelInfo()
	if !showlevelbar:GetBool() then return end
	ply = ply or LocalPlayer()
	local a, b, c, d
	if CORPSE then
		a, b, c, d = ScrW() / 2 - 200 / 2, 30, 200, 35
		local ghost = ply.IsGhost and ply:IsGhost()
		if !ply:Alive() or (ply:IsSpec() and !ghost) then return end
	else
		a, b, c, d = 30, 30, 200, 35
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() and wep:GetClass() == "gmod_tool" then return end
	end
	local xp = ply:GetPerkVar("XP")
	local level = ply:GetPerkVar("Level")
	local maths = level * PerkConfig.XPMultiplier
	local progress_text = string.Comma(xp).." / "..string.Comma(maths)
	local progress = xp / maths
	if level >= PerkConfig.MaxLevel and !no_limit:GetBool() then
		progress_text = "MAX XP"
		progress = 1
	end
	local xp_tag = "XP:"
	if #progress_text > 18 then
		xp_tag = ""
	end
	progress_bar = Lerp(FrameTime() * 4, progress_bar or progress, progress)
	DrawLevelbar(a, b, c, d, color1, color2, color_white, "LEVEL: "..level, "Perks_LevelBar", nil, nil, ply:GetPerkVar("AP").." AP", "Perks_LevelBar", 0)
	DrawLevelbar(a, b + 47, c, d, color1, color2, color_white, xp_tag, "Perks_LevelBar", progress_text, "Perks_LevelBar", nil, nil, math.min(1, progress_bar))
end
hook.Add("HUDPaint", "Perks_DrawLevelInfo", DrawLevelInfo)

local function AddEditButton(ply, PerkMenu)
	if !PerkConfig.AllowEdits then return end
	local EditButton = vgui.Create("DButton", PerkMenu)
	EditButton:SetSize(50, 20)
	EditButton:SetPos(PerkMenu:GetWide() - 51, PerkMenu:GetTall() - 21)
	EditButton:SetText("Edit.")
	EditButton:SetTextColor(color_white)
	EditButton:SetFont("Perks_MenuFont")
	EditButton.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		if ply:GetPrestige() < PerkConfig.MaxPrestige then
			PerkNotify("Du musst Prestige "..PerkConfig.MaxPrestige.." sein, um dieses Feature freizuschalten!", 1, 5)
		else
			local menu = DermaMenu(PerkMenu)
			if no_limit:GetBool() then
				menu:AddOption("XP-Einnahme nach Level "..PerkConfig.MaxLevel.." einschränken", function()
					surface.PlaySound("ui/buttonclick.wav")
					RunConsoleCommand("cl_nolvllimit", 0)
				end):SetIcon("icon16/key_delete.png")
			else
				menu:AddOption("XP-Einnahme nicht nach Level "..PerkConfig.MaxLevel.." einschränken", function()
					surface.PlaySound("ui/buttonclick.wav")
					RunConsoleCommand("cl_nolvllimit", 1)
				end):SetIcon("icon16/key.png")
			end
			local submenu, option = menu:AddSubMenu("Gefährlich")
			option:SetIcon("icon16/bug.png")
			option = submenu:AddOption("Level auf "..PerkConfig.MaxLevel.." zurücksetzen", function()
				surface.PlaySound("ui/buttonclick.wav")
				RunConsoleCommand("perks_resetmaxlevel")
			end)
			option:SetIcon("icon16/lightning.png")
			if ply:GetPerkVar("Level") < PerkConfig.MaxLevel then
				option:SetText("Level auf "..PerkConfig.MaxLevel.." zurücksetzen (Level "..PerkConfig.MaxLevel.." benötigt)")
				option:SetDisabled(true)
			end
			submenu:AddOption("Level auf 1 zurücksetzen", function()
				surface.PlaySound("ui/buttonclick.wav")
				RunConsoleCommand("perks_resetlevel")
			end):SetIcon("icon16/lightning.png")
			menu:Open()
		end
	end
	EditButton.Paint = function()
		if ply:GetPrestige() < PerkConfig.MaxPrestige then
			draw.RoundedBox(2, 0, 0, EditButton:GetWide(), EditButton:GetTall(), Color(125, 125, 125))
		else
			draw.RoundedBox(2, 0, 0, EditButton:GetWide(), EditButton:GetTall(), Color(255, 104, 104))
		end
	end
end

local PerkMenu
local BuyQuestion
local function OpenPerkMenu()
	if IsValid(PerkMenu) then return end
	PerkMenu = vgui.Create("DFrame")
	PerkMenu:SetSize(600, 400)
	PerkMenu:Center()
	PerkMenu:SetTitle("")
	PerkMenu:SetSizable(false)
	PerkMenu:ShowCloseButton(false)
	PerkMenu:MakePopup()
	PerkMenu:ParentToHUD()
	PerkMenu.Paint = function()
		draw.RoundedBox(2, 0, 0, PerkMenu:GetWide(), PerkMenu:GetTall(), Color(35, 35, 35))
	end
	PerkMenu.OnScreenSizeChanged = function(self)
		self:Remove()
	end
	local ply = LocalPlayer()
	local XPLabel = vgui.Create("DLabel", PerkMenu)
	XPLabel:SetPos(4, 1)
	XPLabel:SetText("XP: "..string.Comma(ply:GetPerkVar("XP")).."/"..string.Comma((ply:GetPerkVar("Level") * PerkConfig.XPMultiplier)).."\n\n")
	XPLabel:SetTextColor(color_white)
	XPLabel:SetFont("Perks_MenuFont2")
	XPLabel:SizeToContents()
	XPLabel.Think = function()
		if ply:GetPerkVar("Level") >= PerkConfig.MaxLevel then
			XPLabel:SetText("XP: MAX XP".."\n\n")
			XPLabel:SizeToContents()
		else
			XPLabel:SetText("XP: "..string.Comma(ply:GetPerkVar("XP")).."/"..string.Comma((ply:GetPerkVar("Level") * PerkConfig.XPMultiplier)).."\n\n")
			XPLabel:SizeToContents()
		end
	end
	local LevelLabel = vgui.Create("DLabel", PerkMenu)
	LevelLabel:SetPos(4, 1)
	LevelLabel:SetText("Level: "..ply:GetPerkVar("Level").."\n\n")
	LevelLabel:SetTextColor(color_white)
	LevelLabel:SetFont("Perks_MenuFont2")
	LevelLabel:SizeToContents()
	LevelLabel:MoveRightOf(XPLabel)
	LevelLabel.Think = function()
		LevelLabel:SetText("Level: "..ply:GetPerkVar("Level").."\n\n")
		LevelLabel:SizeToContents()
		LevelLabel:MoveRightOf(XPLabel)
	end
	local PointsLabel = vgui.Create("DLabel", PerkMenu)
	PointsLabel:SetPos(4, 1)
	PointsLabel:SetText("AP: "..ply:GetPerkVar("AP").."\n\n")
	PointsLabel:SetTextColor(color_white)
	PointsLabel:SetFont("Perks_MenuFont2")
	PointsLabel:SizeToContents()
	PointsLabel:MoveRightOf(LevelLabel)
	PointsLabel.Think = function()
		PointsLabel:SetText("AP: "..ply:GetPerkVar("AP").."\n\n")
		PointsLabel:SizeToContents()
		PointsLabel:MoveRightOf(LevelLabel)
	end
	local PrestigeLabel = vgui.Create("DLabel", PerkMenu)
	PrestigeLabel:SetPos(4, 1)
	PrestigeLabel:SetText("P: "..ply:GetPerkVar("Prestige").."\n\n")
	PrestigeLabel:SetTextColor(color_white)
	PrestigeLabel:SetFont("Perks_MenuFont2")
	PrestigeLabel:SizeToContents()
	PrestigeLabel:MoveRightOf(PointsLabel)
	PrestigeLabel.Think = function()
		PrestigeLabel:SetText("P: "..ply:GetPerkVar("Prestige").."\n\n")
		PrestigeLabel:SizeToContents()
		PrestigeLabel:MoveRightOf(PointsLabel)
	end
	local BuyButton
	if PerkConfig.BuyXP and ply:GetPerkVar("Level") < PerkConfig.MaxLevel then
		BuyButton = vgui.Create("DButton", PerkMenu)
		BuyButton:SetSize(75, 20)
		BuyButton:SetPos(PerkMenu:GetWide() - 300, 1)
		BuyButton:SetText("XP kaufen")
		BuyButton:SetTextColor(color_white)
		BuyButton:SetFont("Perks_MenuFont")
		BuyButton.DoClick = function()
			if IsValid(BuyQuestion) then BuyQuestion:Close() return end
			BuyQuestion = vgui.Create("DFrame")
			BuyQuestion:SetSize(350, 150)
			BuyQuestion:Center()
			BuyQuestion:MakePopup()
			BuyQuestion:ParentToHUD()
			BuyQuestion:SetTitle("")
			BuyQuestion:SetSizable(false)
			BuyQuestion:ShowCloseButton(false)
			BuyQuestion.Paint = function()
				draw.RoundedBox(2, 0, 0, BuyQuestion:GetWide(), BuyQuestion:GetTall(), Color(70, 70, 70))
				draw.RoundedBox(2, 2, 2, BuyQuestion:GetWide() - 4, BuyQuestion:GetTall() - 4, Color(35, 35, 35))
			end
			local CloseButton = vgui.Create("DButton", BuyQuestion)
			CloseButton:SetSize(50, 20)
			CloseButton:SetPos(BuyQuestion:GetWide() - 51, 1)
			CloseButton:SetText("X")
			CloseButton:SetTextColor(color_white)
			CloseButton:SetFont("Perks_MenuFont")
			CloseButton.DoClick = function()
				BuyQuestion:Close()
			end
			CloseButton.Paint = function()
				draw.RoundedBox(2, 0, 0, CloseButton:GetWide(), CloseButton:GetTall(), Color(255, 104, 104))
			end
			local Title = vgui.Create("DLabel", BuyQuestion)
			Title:SetPos(7, 4)
			Title:SetFont("Perks_MenuFont2")
			Title:SetText("XP kaufen")
			Title:SizeToContents()
			Title:SetTextColor(color_white)
			local Text = vgui.Create("DLabel", BuyQuestion)
			Text:SetFont("Perks_MenuFont9")
			Text:SetText("Wie viel XP möchtest du kaufen? (1 XP = "..string.Comma(PerkConfig.XPPrice).." Cash)")
			Text:SizeToContents()
			Text:SetContentAlignment(5)
			Text:SetTextColor(color_white)
			local w, h = Text:GetSize()
			w = math.max(w, 400)
			Text:StretchToParent(5, 5, 5, 35)
			local TextEntry = vgui.Create("DTextEntry", BuyQuestion)
			TextEntry:SetText("")
			TextEntry:SetNumeric(true)
			TextEntry.OnEnter = function()
				BuyQuestion:Close()
				RunConsoleCommand("perks_buy", TextEntry:GetValue())
			end
			TextEntry:StretchToParent(10, nil, 10, nil)
			TextEntry:AlignBottom(50)
			TextEntry:RequestFocus()
			TextEntry:SelectAllText(true)
			TextEntry.Paint = function()
				draw.RoundedBox(0, 0, 0, TextEntry:GetWide(), TextEntry:GetTall(), Color(45, 45, 45, 255))
				draw.RoundedBox(0, 2, 2, TextEntry:GetWide() - 4, TextEntry:GetTall() - 4, Color(25, 25, 25, 255))
				TextEntry:DrawTextEntryText(Color(255, 255, 255, 100), Color(0, 0, 0, 0), Color(255, 255, 255, 255))
			end
			local ButtonPanel = vgui.Create("DPanel", BuyQuestion)
			ButtonPanel:SetTall(30)
			ButtonPanel:SetPaintBackground(false)
			local Button = vgui.Create("DButton", ButtonPanel)
			Button:SetTextColor(color_white)
			Button:SetFont("Perks_MenuFont")
			Button:SetText("Kaufen")
			Button:SizeToContents()
			Button:SetTall(20)
			Button:SetWide(Button:GetWide() + 20)
			Button:SetPos(5, 5)
			Button.DoClick = function()
				BuyQuestion:Close()
				RunConsoleCommand("perks_buy", TextEntry:GetValue())
			end
			Button.Paint = function()
				draw.RoundedBox(2, 0, 0, Button:GetWide(), Button:GetTall(), Color(255, 104, 104))
			end
			local ButtonCancel = vgui.Create("DButton", ButtonPanel)
			ButtonCancel:SetTextColor(color_white)
			ButtonCancel:SetFont("Perks_MenuFont")
			ButtonCancel:SetText("Abbrechen")
			ButtonCancel:SizeToContents()
			ButtonCancel:SetTall(20)
			ButtonCancel:SetWide(Button:GetWide() + 20)
			ButtonCancel:SetPos(5, 5)
			ButtonCancel.DoClick = function()
			end
			ButtonCancel.Paint = function()
				draw.RoundedBox(2, 0, 0, ButtonCancel:GetWide(), ButtonCancel:GetTall(), Color(255, 104, 104))
			end
			ButtonCancel:MoveRightOf(Button, 5)
			ButtonPanel:SetWide(Button:GetWide() + 5 + ButtonCancel:GetWide() + 10)
			ButtonPanel:CenterHorizontal()
			ButtonPanel:AlignBottom(8)
			surface.PlaySound("ui/buttonclick.wav")
		end
		BuyButton:MoveRightOf(PrestigeLabel)
		BuyButton.Paint = function()
			draw.RoundedBox(2, 0, 0, BuyButton:GetWide(), BuyButton:GetTall(), Color(255, 104, 104))
		end
		BuyButton.Think = function()
			BuyButton:MoveRightOf(PrestigeLabel)
		end
	end
	local ResetButton = vgui.Create("DButton", PerkMenu)
	ResetButton:SetSize(50, 20)
	ResetButton:SetPos(PerkMenu:GetWide() - 350, 1)
	ResetButton:SetText("Reset")
	ResetButton:SetTextColor(color_white)
	ResetButton:SetFont("Perks_MenuFont")
	ResetButton.DoClick = function()
		RunConsoleCommand("perks_reset")
		surface.PlaySound("ui/buttonclick.wav")
	end
	ResetButton:MoveRightOf(BuyButton or PrestigeLabel, BuyButton and 5 or 0)
	ResetButton.Paint = function()
		draw.RoundedBox(2, 0, 0, ResetButton:GetWide(), ResetButton:GetTall(), Color(255, 104, 104))
	end
	ResetButton.Think = function()
		ResetButton:MoveRightOf(BuyButton or PrestigeLabel, BuyButton and 5 or 0)
	end
	local ScrollPanel = vgui.Create("DScrollPanel", PerkMenu)
	ScrollPanel:SetSize(240, 360)
	ScrollPanel:SetPos(5, 30)
	local buttonpaint = function()
	end
	ScrollPanel:GetVBar().btnUp.Paint = buttonpaint
	ScrollPanel:GetVBar().btnDown.Paint = buttonpaint
	ScrollPanel:GetVBar().btnGrip.Paint = function(slf)
		draw.RoundedBox(2, 0, 0, slf:GetWide(), slf:GetTall(), Color(75, 75, 75))
	end
	ScrollPanel:GetVBar().Paint = function(slf)
		draw.RoundedBox(2, 0, 0, slf:GetWide(), slf:GetTall(), Color(100, 100, 100))
	end
	local CloseButton = vgui.Create("DButton", PerkMenu)
	CloseButton:SetSize(50, 20)
	CloseButton:SetPos(PerkMenu:GetWide() - 51, 1)
	CloseButton:SetText("X")
	CloseButton:SetTextColor(color_white)
	CloseButton:SetFont("Perks_MenuFont")
	CloseButton.DoClick = function()
		if IsValid(BuyQuestion) then
			BuyQuestion:Close()
		end
		PerkMenu:Close()
		surface.PlaySound("ui/buttonclick.wav")
	end
	CloseButton.Paint = function()
		draw.RoundedBox(2, 0, 0, CloseButton:GetWide(), CloseButton:GetTall(), Color(255, 104, 104))
	end
	local PerkLayout = vgui.Create("DIconLayout", ScrollPanel)
	PerkLayout:SetPos(0, 0)
	PerkLayout:SetSize(ScrollPanel:GetWide(), ScrollPanel:GetTall())
	PerkLayout:SetSpaceX(2)
	PerkLayout:SetSpaceY(2)
	for k, v in ipairs(Perks) do
		local PerkPanel = PerkLayout:Add("DPanel")
		PerkPanel:SetSize(ScrollPanel:GetWide(), 50)
		PerkPanel.Paint = function()
			draw.RoundedBox(2, 0, 0, ScrollPanel:GetWide(), ScrollPanel:GetTall(), Color(30, 30, 30))
		end
		local PerkName = vgui.Create("DLabel", PerkPanel)
		PerkName:SetPos(4, 0)
		PerkName:SetSize(ScrollPanel:GetWide(), 25)
		PerkName:SetFont("Perks_MenuFont4")
		local p_name = v[1]
		PerkName:SetText(p_name)
		local p_level = v[2]
		PerkName.Think = function(slf)
			if ply:GetPerkVar("Level") < p_level then
				slf:SetTextColor(Color(180, 180, 180))
			else
				slf:SetTextColor(color_white)
			end
		end
		local PerkNeededLevel = vgui.Create("DLabel", PerkPanel)
		PerkNeededLevel:SetPos(4, 25)
		PerkNeededLevel:SetSize(ScrollPanel:GetWide(), 25)
		PerkNeededLevel:SetFont("Perks_MenuFont")
		PerkNeededLevel:SetText("Level "..p_level)
		PerkNeededLevel.Think = function(slf)
			slf:SetTextColor(color_white)
			if ply:GetPerkVar("Level") < p_level then
				slf:SetTextColor(Color(180, 180, 180))
			else
				slf:SetTextColor(color_white)
			end
		end
		local text = (!PlayerPerks[k] and "0" or PlayerPerks[k]).."/"..PerkConfig.MaxUpgrade
		surface.SetFont("Perks_MenuFont")
		local x = surface.GetTextSize(text)
		local PerkLevel = vgui.Create("DLabel", PerkPanel)
		PerkLevel:SetPos(220 - x, 30)
		PerkLevel:SetFont("Perks_MenuFont")
		PerkLevel:SetText(text)
		PerkLevel:SizeToContents()
		PerkLevel.Think = function()
			if ply:GetPerkVar("Level") < p_level then
				PerkLevel:SetTextColor(Color(180, 180, 180))
			else
				PerkLevel:SetTextColor(color_white)
			end
			local text = (!PlayerPerks[k] and "0" or PlayerPerks[k]).."/"..PerkConfig.MaxUpgrade
			surface.SetFont("Perks_MenuFont")
			local x = surface.GetTextSize(text)
			PerkLevel:SetText(text)
			PerkLevel:SetPos(220 - x, 30)
			PerkLevel:SizeToContents()
		end
		local PerkButton = vgui.Create("DButton", PerkPanel)
		PerkButton:SetSize(ScrollPanel:GetWide(), 60)
		PerkButton:SetPos(0, 0)
		PerkButton:SetText("")
		PerkButton.Paint = function()
		end
		PerkButton.DoClick = function(slf)
			if IsValid(PerkMenu.PerkPanel) then
				PerkMenu.PerkPanel:Remove()
			end
			PerkMenu:SelectPerk(p_name)
			surface.PlaySound("ui/buttonclick.wav")
		end
	end
	if PerkConfig.PrestigeSystem then
		local PrestigePanel = PerkLayout:Add("DPanel")
		PrestigePanel:SetSize(ScrollPanel:GetWide(), 50)
		PrestigePanel.Paint = function()
			draw.RoundedBox(2, 0, 0, ScrollPanel:GetWide(), ScrollPanel:GetTall(), Color(30, 30, 30))
		end
		local PrestigeLabel = vgui.Create("DLabel", PrestigePanel)
		PrestigeLabel:SetPos(4, 0)
		PrestigeLabel:SetSize(ScrollPanel:GetWide(), 25)
		PrestigeLabel:SetFont("Perks_MenuFont4")
		PrestigeLabel:SetText("Prestige")
		local max_level = PerkConfig.MaxLevel
		PrestigeLabel.Think = function(slf)
			if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
				slf:SetTextColor(Color(180, 180, 180))
			else
				slf:SetTextColor(color_white)
			end
		end
		local MinLevel = vgui.Create("DLabel", PrestigePanel)
		MinLevel:SetPos(4, 25)
		MinLevel:SetSize(ScrollPanel:GetWide(), 25)
		MinLevel:SetFont("Perks_MenuFont")
		MinLevel:SetText("Level "..max_level)
		MinLevel.Think = function(slf)
			slf:SetTextColor(color_white)
			if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
				slf:SetTextColor(Color(180, 180, 180))
			else
				slf:SetTextColor(color_white)
			end
		end
		local text = ply:GetPrestige().."/"..PerkConfig.MaxPrestige
		surface.SetFont("Perks_MenuFont")
		local x = surface.GetTextSize(text)
		local PrestigeLevel = vgui.Create("DLabel", PrestigePanel)
		PrestigeLevel:SetPos(220 - x, 30)
		PrestigeLevel:SetFont("Perks_MenuFont")
		PrestigeLevel:SetText(text)
		PrestigeLevel:SizeToContents()
		PrestigeLevel.Think = function()
			if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
				PrestigeLevel:SetTextColor(Color(180, 180, 180))
			else
				PrestigeLevel:SetTextColor(color_white)
			end
			text = ply:GetPrestige().."/"..PerkConfig.MaxPrestige
			surface.SetFont("Perks_MenuFont")
			local x = surface.GetTextSize(text)
			PrestigeLevel:SetText(text)
			PrestigeLevel:SetPos(220 - x, 30)
			PrestigeLevel:SizeToContents()
		end
		local SelectButton = vgui.Create("DButton", PrestigePanel)
		SelectButton:SetSize(ScrollPanel:GetWide(), 60)
		SelectButton:SetPos(0, 0)
		SelectButton:SetText("")
		SelectButton.Paint = function()
		end
		SelectButton.DoClick = function(slf)
			PerkMenu:SelectPerk("Prestige")
		end
	end
	PerkMenu.SelectPerk = function(slf, sel)
		if sel == "Prestige" then
			local PrestigePanel = vgui.Create("DPanel", PerkMenu)
			PrestigePanel:SetSize(slf:GetWide(), slf:GetTall())
			PrestigePanel:SetPos(250, 30)
			PrestigePanel.Paint = function()
				draw.RoundedBox(2, 0, 0, PrestigePanel:GetWide(), PrestigePanel:GetTall(), Color(35, 35, 35))
			end
			PerkMenu.PerkPanel = PrestigePanel
			local ply_prestige = ply:GetPrestige()
			local max_upgrade = PerkConfig.MaxPrestige
			local text = ply_prestige.."/"..max_upgrade
			local max_level = PerkConfig.MaxLevel
			local PrestigeLevel = vgui.Create("DLabel", PrestigePanel)
			surface.SetFont("Perks_MenuFont")
			local x = surface.GetTextSize(text)
			PrestigeLevel:SetText(text)
			PrestigeLevel:SetFont("Perks_MenuFont")
			PrestigeLevel.Think = function(slf)
				if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
					slf:SetTextColor(Color(180, 180, 180))
				else
					slf:SetTextColor(color_white)
				end
				PrestigeLevel:SetPos(PrestigePanel:GetWide() / 1.9 - x + 10, 10)
				PrestigeLevel:SizeToContents()
			end
			PrestigeLevel:SizeToContents()
			local LevelNumber = vgui.Create("DLabel", PrestigePanel)
			LevelNumber:SetPos(20, 10)
			LevelNumber:SetText("Level "..max_level)
			LevelNumber:SetFont("Perks_MenuFont3")
			LevelNumber.Think = function(slf)
				if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
					slf:SetTextColor(Color(180, 180, 180))
				else
					slf:SetTextColor(color_white)
				end
			end
			LevelNumber:SizeToContents()
			local PrestigeTitle = vgui.Create("DLabel", PrestigePanel)
			surface.SetFont("Perks_MenuFont5")
			local x, y = surface.GetTextSize("Prestige")
			PrestigeTitle:SetPos(20, 40)
			PrestigeTitle:SetText("Prestige")
			PrestigeTitle:SetContentAlignment(5)
			PrestigeTitle:SetFont("Perks_MenuFont5")
			PrestigeTitle.Think = function(slf)
				if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
					slf:SetTextColor(Color(180, 180, 180))
				else
					slf:SetTextColor(color_white)
				end
			end
			PrestigeTitle:SizeToContents()
			local PrestigeDescription = vgui.Create("DLabel", PrestigePanel)
			PrestigeDescription:SetPos(20, 70)
			PrestigeDescription:SetSize(280, 120)
			PrestigeDescription.Think = function(slf)
				if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
					slf:SetTextColor(Color(180, 180, 180))
				else
					slf:SetTextColor(color_white)
				end
			end
			PrestigeDescription:SetFont("Perks_MenuFont7")
			PrestigeDescription:SetText("Sobald du das maximale Level erreicht hast, kannst du dein Level hier zurücksetzen.\nEine Erhöhung gewährt einen prozentuellen Bonus auf alle Perks.")
			PrestigeDescription:SetWrap(true)
			PrestigeDescription:SetAutoStretchVertical(true)
			local PrestigeBonus = vgui.Create("DLabel", PrestigePanel)
			PrestigeBonus:SetPos(20, 150)
			PrestigeBonus:SetSize(PerkMenu:GetWide(), 120)
			PrestigeBonus:SetFont("Perks_MenuFont")
			PrestigeBonus:SetText("Derzeitiger Bonus: "..(ply_prestige * PerkConfig.PrestigeMultiplier).."%")
			PrestigeBonus.Think = function(slf)
				slf:SetTextColor(color_white)
				if ply:GetPerkVar("Level") < max_level and ply:GetPrestige() < PerkConfig.MaxPrestige then
					slf:SetTextColor(Color(180, 180, 180))
				end
			end
			if ply_prestige != max_upgrade then
				local PrestigeNextBonus = vgui.Create("DLabel", PrestigePanel)
				PrestigeNextBonus:SetPos(20, 130)
				PrestigeNextBonus:SetSize(PerkMenu:GetWide(), 120)
				PrestigeNextBonus.Think = function(slf)
					if ply:GetPerkVar("Level") < max_level then
						slf:SetTextColor(Color(180, 180, 180))
					else
						slf:SetTextColor(color_white)
					end
				end
				PrestigeNextBonus:SetFont("Perks_MenuFont")
				PrestigeNextBonus:SetText("Nächste Stufe: "..((ply:GetPrestige() + 1) * PerkConfig.PrestigeMultiplier).."%")
			end
			if (ply_prestige != max_upgrade) then
				local AddButton = vgui.Create("DButton", PrestigePanel)
				AddButton:SetSize(150, 30)
				AddButton:SetPos(20, 235)
				AddButton:SetText("Erhöhen")
				AddButton:SetTooltip("Bei zweifacher Betätigung, wird dein Level zurückgesetzt und dein Prestige-Rang um 1 erhöht.")
				AddButton:SetTextColor(color_white)
				AddButton:SetFont("Perks_MenuFont8")
				AddButton.Paint = function()
					draw.RoundedBox(2, 0, 0, AddButton:GetWide(), AddButton:GetTall(), (ply:GetPerkVar("Level") >= max_level and (AddButton.Delay or 0) <= CurTime()) and Color(0, 200, 0) or Color(200, 0, 0))
				end
				AddButton.DoClick = function(slf)
					if (slf.Delay or 0) > CurTime() then return end
					net.Start("Perks_Prestige")
					net.SendToServer()
					surface.PlaySound("ui/buttonclick.wav")
					slf.Delay = CurTime() + 1
					slf:SetDisabled(true)
				end
				AddButton.Think = function(slf)
					if (slf.Delay or 0) <= CurTime() then
						slf:SetDisabled(false)
					end
				end
			elseif (ply_prestige == max_upgrade) then
				local AddButton = vgui.Create("DLabel", PrestigePanel)
				AddButton:SetSize(200, 30)
				AddButton:SetPos(20, 235)
				AddButton:SetText("Max. erhöht")
				AddButton:SetTextColor(color_white)
				AddButton:SetFont("Perks_MenuFont8")
			end
			AddEditButton(ply, PerkMenu)
			PerkMenu.Selected = "Prestige"
			surface.PlaySound("ui/buttonclick.wav")
			return
		end
		for k, v in ipairs(Perks) do
			local p_name = v[1]
			if sel == p_name or sel == true then
				local PerkPanel = vgui.Create("DPanel", slf)
				PerkPanel:SetSize(slf:GetWide(), slf:GetTall())
				PerkPanel:SetPos(250, 30)
				PerkPanel.Paint = function()
					draw.RoundedBox(2, 0, 0, PerkPanel:GetWide(), PerkPanel:GetTall(), Color(35, 35, 35))
				end
				PerkMenu.PerkPanel = PerkPanel
				local PerkLevel = vgui.Create("DLabel", PerkPanel)
				PerkLevel:SetFont("Perks_MenuFont")
				local max_upgrade = PerkConfig.MaxUpgrade
				local perk = PlayerPerks[k]
				local text = (!perk and "0" or perk).."/"..max_upgrade
				surface.SetFont("Perks_MenuFont")
				local x = surface.GetTextSize(text)
				PerkLevel:SetText(text)
				PerkLevel:SetPos(PerkPanel:GetWide() / 1.9, -10)
				PerkLevel:SetSize(100, 50)
				local p_level = v[2]
				PerkLevel.Think = function(slf)
					if ply:GetPerkVar("Level") < p_level then
						slf:SetTextColor(Color(180, 180, 180))
					else
						slf:SetTextColor(color_white)
					end
					PerkLevel:SetPos(PerkPanel:GetWide() / 1.9 - x + 10, 10)
					PerkLevel:SizeToContents()
				end
				local LevelNumber = vgui.Create("DLabel", PerkPanel)
				LevelNumber:SetPos(20, 10)
				LevelNumber:SetText("Level "..p_level)
				LevelNumber:SetFont("Perks_MenuFont3")
				LevelNumber.Think = function(slf)
					if ply:GetPerkVar("Level") < p_level then
						slf:SetTextColor(Color(180, 180, 180))
					else
						slf:SetTextColor(color_white)
					end
				end
				LevelNumber:SizeToContents()
				local PerkTitle = vgui.Create("DLabel", PerkPanel)
				PerkTitle:SetPos(20, 40)
				PerkTitle:SetText(p_name)
				PerkTitle:SetContentAlignment(5)
				PerkTitle:SetFont("Perks_MenuFont5")
				PerkTitle.Think = function(slf)
					if ply:GetPerkVar("Level") < p_level then
						slf:SetTextColor(Color(180, 180, 180))
					else
						slf:SetTextColor(color_white)
					end
				end
				PerkTitle:SizeToContents()
				local PerkDescription = vgui.Create("DLabel", PerkPanel)
				PerkDescription:SetPos(20, 50)
				PerkDescription:SetSize(280, 120)
				PerkDescription.Think = function(slf)
					if ply:GetPerkVar("Level") < p_level then
						slf:SetTextColor(Color(180, 180, 180))
					else
						slf:SetTextColor(color_white)
					end
				end
				PerkDescription:SetFont("Perks_MenuFont7")
				PerkDescription:SetText(v[4])
				PerkDescription:SetWrap(true)
				PerkDescription:SetAutoStretchVertical(true)
				local PerkMulti = vgui.Create("DLabel", PerkPanel)
				PerkMulti:SetPos(20, 115)
				PerkMulti:SetSize(slf:GetWide(), 120)
				PerkMulti:SetFont("Perks_MenuFont")
				PerkMulti:SetText("Derzeitiger Multikiplikator: "..math.Round(ply:GetPerkPercentage(p_name) * 100, 2).."%")
				PerkMulti.Think = function(slf)
					slf:SetTextColor(color_white)
					if ply:GetPerkVar("Level") < p_level then
						slf:SetTextColor(Color(180, 180, 180))
					end
				end
				if perk != max_upgrade then
					local PerkLevelMulti = vgui.Create("DLabel", PerkPanel)
					PerkLevelMulti:SetPos(20, 95)
					PerkLevelMulti:SetSize(slf:GetWide(), 120)
					PerkLevelMulti.Think = function(slf)
						if ply:GetPerkVar("Level") < p_level then
							slf:SetTextColor(Color(180, 180, 180))
						else
							slf:SetTextColor(color_white)
						end
					end
					PerkLevelMulti:SetFont("Perks_MenuFont")
					PerkLevelMulti:SetText("Nächstes Level: "..math.Round(ply:GetPerkPercentage(p_name, true) * 100, 2).."%")
				end
				if (!perk or perk != max_upgrade) then
					local AddButton = vgui.Create("DButton", PerkPanel)
					AddButton:SetSize(150, 30)
					AddButton:SetPos(20, 200)
					if !perk then
						AddButton:SetText("Freischalten")
					else
						AddButton:SetText("Verbessern")
					end
					AddButton:SetTextColor(color_white)
					AddButton:SetFont("Perks_MenuFont8")
					AddButton.Paint = function()
						draw.RoundedBox(2, 0, 0, AddButton:GetWide(), AddButton:GetTall(), ply:GetPerkVar("Level") >= p_level and ply:GetPerkVar("AP") > 0 and Color(0, 200, 0) or Color(200, 0, 0))
					end
					AddButton.DoClick = function(slf)
						if (slf.Delay or 0) > CurTime() then return end
						slf.Delay = CurTime() + 0.5
						net.Start("Perks_AddPerk")
							net.WriteInt(k, 6)
						net.SendToServer()
						surface.PlaySound("ui/buttonclick.wav")
					end
				elseif (perk and perk == max_upgrade) then
					local AddButton = vgui.Create("DLabel", PerkPanel)
					AddButton:SetSize(200, 30)
					AddButton:SetPos(20, 200)
					AddButton:SetText("Max. verbessert")
					AddButton:SetTextColor(color_white)
					AddButton:SetFont("Perks_MenuFont8")
				end
				AddEditButton(ply, PerkMenu)
				PerkMenu.Selected = p_name
				break
			end
		end
	end
	PerkMenu.SelectPerk(PerkMenu, true)
end
concommand.Add("perks", OpenPerkMenu)

local OpenPerks
local function ShowMenu()
	if input.IsKeyDown(PerkConfig.Key) then
		if OpenPerks then return end
		OpenPerks = true
		if IsValid(PerkMenu) then
			PerkMenu:SetVisible(!PerkMenu:IsVisible())
			if !PerkMenu:IsVisible() then
				if IsValid(BuyQuestion) then
					BuyQuestion:Close()
				end
				CloseDermaMenus()
			end
			PerkMenu:Center()
		else
			OpenPerkMenu()
		end
	else
		OpenPerks = false
	end
end
hook.Add("Think", "Perks_ShowMenu", ShowMenu)

hook.Add("OnPlayerChat", "Perks_ShowMenu", function(ply, text)
	if string.lower(text) == PerkConfig.ChatCommand then
		if ply != LocalPlayer() then return true end
		OpenPerkMenu()
		return true
	end
end)

net.Receive("Perks_TransferClient", function(l)
	PlayerPerks = net.ReadTable()
	if IsValid(PerkMenu) and PerkMenu.Selected then
		PerkMenu:SelectPerk(PerkMenu.Selected)
	end
end)