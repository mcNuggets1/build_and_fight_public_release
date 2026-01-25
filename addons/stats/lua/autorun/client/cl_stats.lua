surface.CreateFont("Stats_PlayerName", {font = "Bebas Neue", size = 70, weight = 1})
surface.CreateFont("Stats_CloseButton", {font = "Bebas Neue", size = 50, weight = 1})
surface.CreateFont("Stats_SelectButton", {font = "Bebas Neue", size = 45, weight = 1})

local oldEnableScreenClicker = gui.EnableScreenClicker
function gui.OverrideScreenClicker(bool)
	return oldEnableScreenClicker(bool)
end

local Stats_Background
function gui.EnableScreenClicker(bool)
	if !bool and IsValid(Stats_Background) then return end
	return oldEnableScreenClicker(bool)
end

function Stats.OpenStats(ply)
	net.Start("PVP_OpenStats")
		net.WriteEntity(ply)
	net.SendToServer()
end

function Stats.OpenOtherPlayerStats(sid)
	net.Start("PVP_OpenOtherPlayerStats")
		net.WriteString(sid)
	net.SendToServer()
end

function Stats.ChangeProfilePrivacy(bool)
	net.Start("PVP_ChangeProfilePrivacy")
		net.WriteBit(bool)
	net.SendToServer()
end

local ply
local ply_info
local private
local utime
local stats_loading
local stats_unavailable
local stats_private
local page
local timing = Stats.FadeIn and Stats.FadeTime or 0

local function fetchPlayerTime(ply) -- YOUR TIME TRACKING FUNCTION. MEOW MF
	return ply.GetUTimeTotalTime and ply:GetUTimeTotalTime() or 0
end

net.Receive("PVP_OpenStats", function()
	gui.OverrideScreenClicker(true)
	ply_info = net.ReadTable()
	stats_private = (IsValid(Stats_Background) and ply_info.PrivateProfile == 1 and ply != LocalPlayer() and !LocalPlayer():IsAdmin())
	stats_unavailable = (!ply_info or table.Count(ply_info) <= 0)
	stats_loading = false
	utime = (IsValid(Stats_Background) and (ply_info.OverrideTime or (ply and !isstring(ply) and IsValid(ply) and fetchPlayerTime(ply)) or 0))
	stats_error = ply_info.Loaded == false
	if IsValid(Stats_Background) then return end
	local net_ply = net.ReadEntity()
	ply = IsValid(net_ply) and net_ply or LocalPlayer()
	stats_private = (ply_info.PrivateProfile == 1 and ply != LocalPlayer() and !LocalPlayer():IsAdmin())
	private = net.ReadBit()
	utime = (ply_info.OverrideTime or (ply and !isstring(ply) and IsValid(ply) and fetchPlayerTime(ply)) or 0)
	page = 1
	Stats_Background = vgui.Create("DFrame")
	Stats_Background:SetPos(0, 0)
	Stats_Background:SetSize(ScrW(), ScrH())
	Stats_Background:SetAlpha(0)
	Stats_Background:AlphaTo(255, timing)
	Stats_Background:SetTitle("")
	Stats_Background:ShowCloseButton(false)
	Stats_Background:SetDraggable(false)
	Stats_Background:SetMouseInputEnabled(true)
	Stats_Background:MakePopup()
	Stats_Background:ParentToHUD()
	Stats_Background.Paint = function(s, w, h)
		if Stats.BackgroundBlur then
			Derma_DrawBackgroundBlur(s)
		end
		draw.RoundedBox(0, 0, 0, w, h, Stats.Background)
		local topcol = Stats.RainbowTopText and HSVToColor(math.abs(math.sin(CurTime() * 0.15) * 300), 1, 1) or Stats.TopTextColor
		draw.SimpleText("Statistiken für: "..((isstring(ply) and ply) or (IsValid(ply) and ply:Name()) or "NICHT VERFÜGBAR!")..(ply_info.PrivateProfile == 1 and ply != LocalPlayer() and LocalPlayer():IsAdmin() and " (PRIVAT)" or ""), "Stats_PlayerName", w / 2, h - h + 20, topcol, TEXT_ALIGN_CENTER)
	end
	local Stats_Page1 = vgui.Create("DFrame", Stats_Background)
	Stats_Page1:SetPos(0, 0)
	Stats_Page1:SetSize(ScrW(), ScrH())
	Stats_Page1:SetAlpha(0)
	Stats_Page1:AlphaTo(255, timing)
	Stats_Page1:SetTitle("")
	Stats_Page1:ShowCloseButton(false)
	Stats_Page1:SetDraggable(false)
	Stats_Page1:SetMouseInputEnabled(true)
	Stats_Page1.Paint = function(s, w, h)
		if stats_error then
			draw.SimpleText("Profil nicht initialisiert. Bitte versuche es später erneut!", "JB_Stats_PlayerName", w / 2, h / 3, Color(255, 0, 0), TEXT_ALIGN_CENTER)
			return
		end
		if stats_private then
			draw.SimpleText("Dieses Profil ist privat!", "Stats_PlayerName", w / 2, h / 3, Color(255, 0, 0), TEXT_ALIGN_CENTER)
			return
		end
		local maincol = Stats.RainbowMainText and HSVToColor(math.abs(math.sin(CurTime() * 0.15) * 300), 1, 1) or Stats.TextColor
		if stats_loading then
			draw.SimpleText("Statistiken werden geladen...", "Stats_PlayerName", w / 2, h / 3, maincol, TEXT_ALIGN_CENTER)
			return
		end
		if stats_unavailable then
			draw.SimpleText("System konnte nichts finden!", "Stats_PlayerName", w / 2, h / 3, Color(255, 0, 0), TEXT_ALIGN_CENTER)
			return
		end
		draw.SimpleText("Gesamte Tötungen:", "Stats_PlayerName", w / 4, h / 5, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalKills), "Stats_PlayerName", w / 4, h / 5 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gesamte Tode:", "Stats_PlayerName", w / 4, h / 2 - h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalDeaths), "Stats_PlayerName", w / 4, h / 2 - h / 7 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gesamte Selbstmorde", "Stats_PlayerName", w / 4, h / 2, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalSuicides), "Stats_PlayerName", w / 4, h / 2 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("K/D:", "Stats_PlayerName", w / 4, h / 2 + h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(math.Round((ply_info.TotalKills + 1) / (ply_info.TotalDeaths + 1), 2)), "Stats_PlayerName", w / 4, h / 2 + h / 7 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gesamte Kopfschüsse:", "Stats_PlayerName", w / 4, h / 2 + h / 3.5, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalHeadshots), "Stats_PlayerName", w / 4, h / 2 + h / 3.5 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gespawnte Props:", "Stats_PlayerName", w / 2 + w / 4, h / 5, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalProps), "Stats_PlayerName", w / 2 + w / 4, h / 5 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Benutzte Werkzeuge:", "Stats_PlayerName", w / 2 + w / 4, h / 2 - h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalTools), "Stats_PlayerName", w / 2 + w / 4, h / 2 +  - h / 7 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Verdientes Geld:", "Stats_PlayerName", w / 2 + w / 4, h / 2, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalMoney), "Stats_PlayerName", w / 2 + w / 4, h / 2 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Items in Besitz:", "Stats_PlayerName", w / 2 + w / 4, h / 2 + h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalItems), "Stats_PlayerName", w / 2 + w / 4, h / 2 + h / 7 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Items in Benutzung:", "Stats_PlayerName", w / 2 + w / 4, h / 2 + h / 3.5, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalItemsInUse), "Stats_PlayerName", w / 2 + w / 4, h / 2 + h / 3.5 + 60, col, TEXT_ALIGN_CENTER)
	end
	local Stats_Page2 = vgui.Create("DFrame", Stats_Background)
	Stats_Page2:SetPos(0, 0)
	Stats_Page2:SetSize(ScrW(), ScrH())
	Stats_Page2:SetAlpha(0)
	Stats_Page2:AlphaTo(0, timing)
	Stats_Page2:SetTitle("")
	Stats_Page2:ShowCloseButton(false)
	Stats_Page2:SetDraggable(false)
	Stats_Page2:SetMouseInputEnabled(true)
	Stats_Page2.Paint = function(s, w, h)
		if stats_error then
			draw.SimpleText("Profil nicht initialisiert. Bitte versuche es später erneut!", "JB_Stats_PlayerName", w / 2, h / 3, Color(255, 0, 0), TEXT_ALIGN_CENTER)
			return
		end
		if stats_private then
			draw.SimpleText("Dieses Profil ist privat!", "Stats_PlayerName", w / 2, h / 3, Color(255, 0, 0), TEXT_ALIGN_CENTER)
			return
		end
		if stats_loading then
			draw.SimpleText("Statistiken werden geladen...", "Stats_PlayerName", w / 2, h / 3, maincol, TEXT_ALIGN_CENTER)
			return
		end
		if stats_unavailable then
			draw.SimpleText("System konnte nichts finden!", "Stats_PlayerName", w / 2, h / 3, Color(255, 0, 0), TEXT_ALIGN_CENTER)
			return
		end
		draw.SimpleText("Freigespielte Level:", "Stats_PlayerName", w / 4, h / 5, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalLevels), "Stats_PlayerName",w / 4, h / 5 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Freigeschaltete Errungenschaften:", "Stats_PlayerName", w / 4, h / 2 - h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalAchievements), "Stats_PlayerName", w / 4, h / 2 - h / 7 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Geöffnete Kisten:", "Stats_PlayerName", w / 4, h / 2, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalCrates), "Stats_PlayerName", w / 4, h / 2 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gespielte Unboxing-Runden:", "Stats_PlayerName", w / 4, h / 2 + h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.Comma(ply_info.TotalUnbox), "Stats_PlayerName", w / 4, h / 2 + h / 7 + 60, col, TEXT_ALIGN_CENTER)
		draw.SimpleText("Gesamte Spielzeit:", "Stats_PlayerName", w / 2 + w / 4, h / 5, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(UTime_TimeToString and UTime_TimeToString(utime) or "NICHT VERFÜGBAR!", "Stats_PlayerName", w / 2 + w / 4, h / 5 + 60, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText("Spielt seit:", "Stats_PlayerName", w / 2 + w / 4, h / 2 - h / 7, maincol, TEXT_ALIGN_CENTER)
		draw.SimpleText(os.date("%d.%m.%Y", ply_info.FirstJoin), "Stats_PlayerName", w / 2 + w / 4, h / 2 - h / 7 + 60, maincol, TEXT_ALIGN_CENTER)
	end
	local Stats_PlayerModel = vgui.Create("DModelPanel", Stats_Background)
	Stats_PlayerModel:SetPos(ScrW() / 2 - ScrW() / 4, ScrH() / 2 - ScrH() / 2)
	timer.Simple(Stats.FadeIn and Stats.FadeModelTime or 0, function()
		if !ply or isstring(ply) or !IsValid(ply) or !IsValid(Stats_PlayerModel) or ply:GetModel() == "models/player.mdl" or stats_unavailable or stats_loading or stats_private then return end
		Stats_PlayerModel:SetModel(ply:GetModel())
	end)
	Stats_PlayerModel:SetSize(ScrW() / 2, ScrH())
	Stats_PlayerModel:SetAnimated(true)
	function Stats_PlayerModel:LayoutEntity()
		self:RunAnimation()
	end
	Stats_PlayerModel:SetCamPos(Vector(60, 0, 50))
	Stats_PlayerModel:SetLookAt(Vector(0, 0, 40))
	timer.Create("Stats_UpdatePlayerModel", 0.1, 0, function()
		if !ply or isstring(ply) or !IsValid(ply) or !IsValid(Stats_PlayerModel) or stats_unavailable or stats_loading or stats_private then return end
		if (!IsValid(Stats_PlayerModel.Entity) or IsValid(Stats_PlayerModel.Entity) and ply:GetModel() != Stats_PlayerModel.Entity:GetModel()) and ply:GetModel() != "models/player.mdl" then
			Stats_PlayerModel:SetModel(ply:GetModel())
		end
	end)
	local Stats_PlayerModelFix = vgui.Create("DFrame", Stats_Background)
	Stats_PlayerModelFix:SetPos(ScrW() / 2 - ScrW() / 4, ScrH() / 2 - ScrH() / 2)
	Stats_PlayerModelFix:SetSize(ScrW() / 2, ScrH())
	Stats_PlayerModelFix:SetTitle("")
	Stats_PlayerModelFix:ShowCloseButton(false)
	Stats_PlayerModelFix:SetDraggable(false)
	Stats_PlayerModelFix.Paint = function()
	end
	local CloseButton = vgui.Create("DButton", Stats_Background)
	CloseButton:SetColor(Color(255, 255, 255))
	CloseButton:SetFont("Stats_PlayerName")
    CloseButton:SetText("Schließen")
    CloseButton:SetSize(ScrW() / 4, 50)
    CloseButton:SetPos(ScrW() / 2 - ScrW() / 4 / 2, ScrH() - 50)
    CloseButton.DoClick = function()
		timer.Remove("Stats_UpdatePlayerModel")
		Stats_Background:AlphaTo(0, timing, 0, function()
			if !IsValid(Stats_Background) then return end
			Stats_Background:Remove()
		end)
		Stats_PlayerModel:Remove()
		gui.OverrideScreenClicker(false)
    end
	CloseButton.OnRemove = function()
		timer.Remove("Stats_UpdatePlayerModel")
	end
    CloseButton.Paint = function(w, h)
		local col = Color(200, 30, 30)
        if CloseButton.Hovered then
			col = Color(252, 63, 63)
        end
        surface.SetDrawColor(col.r, col.g, col.b)
        surface.DrawRect(0, 0, CloseButton:GetWide(), CloseButton:GetTall())
    end
	local PageButton = vgui.Create("DButton", Stats_Background)
	PageButton:SetColor(Color(255, 255, 255))
	PageButton:SetFont("Stats_SelectButton")
	PageButton:SetText("")
	PageButton:SetSize(250, 50)
	PageButton:SetPos(ScrW() - 255, 5)
	PageButton.DoClick = function()
		if (page == 1) then
			page = 2
			Stats_Page1:AlphaTo(0, timing / 2)
			Stats_Page2:AlphaTo(255, timing)
		else
			page = 1
			Stats_Page2:AlphaTo(0, timing / 2)
			Stats_Page1:AlphaTo(255, timing)
		end
	end
	PageButton.Paint = function(w, h)
		if (page == 1) then
			PageButton:SetText("-> Seite 2")
		else
			PageButton:SetText("-> Seite 1")
		end
		local col = Stats.PagesColor
		if PageButton.Hovered then
			col = Color(col.r, col.g, col.b, col.a - 20)
		end
		draw.RoundedBox(0, 0, 0, PageButton:GetWide(), PageButton:GetTall(), col)
	end
	local PlayerButton = vgui.Create("DButton", Stats_Background)
	PlayerButton:SetColor(Color(255, 255, 255))
	PlayerButton:SetFont("Stats_SelectButton")
	PlayerButton:SetText("Spieler auswählen")
	PlayerButton:SetSize(250, 50)
	PlayerButton:SetPos(5, 5)
	PlayerButton.DoClick = function(btn)
		local Menu = DermaMenu()
		local count = 0
		for _,v in ipairs(player.GetAll()) do
			if v != ply then
				Menu:AddOption(v:Name(), function()
					if !IsValid(v) then return end
					stats_loading = true
					ply = v
					Stats_PlayerModel:SetModel("")
					Stats.OpenStats(v)
				end)
				count = count + 1
			end
		end
		if count <= 0 then
			Menu:AddOption("Niemand verfügbar!")
		end
		Menu:Open()
	end
	PlayerButton.Paint = function(w, h)
		local col = Stats.PlayerColor
		if PlayerButton.Hovered then
			col = Color(col.r, col.g, col.b, col.a - 20)
		end
		draw.RoundedBox(0, 0, 0, PlayerButton:GetWide(), PlayerButton:GetTall(), col)
	end
	local OfflinePlayerButton = vgui.Create("DButton", Stats_Background)
	OfflinePlayerButton:SetColor(Color(255, 255, 255))
	OfflinePlayerButton:SetFont("Stats_SelectButton")
	OfflinePlayerButton:SetText("SteamID angeben")
	OfflinePlayerButton:SetSize(250, 50)
	OfflinePlayerButton:SetPos(5, 65)
	OfflinePlayerButton.DoClick = function(btn)
		Derma_StringRequest(
			"SteamID angeben",
			"Bitte gebe die SteamID eines Spielers an um seine Statistiken einzusehen.",
			"",
			function(steamid)
				steamid = string.upper(string.Trim(steamid))
				if string.Trim(steamid) == "" then return end
				if steamid:match("^(STEAM_[0-9]+:[0-9]+:[0-9]+)$") then
					local v_ply = player.GetBySteamID(steamid)
					if IsValid(v_ply) then
						if ply == v_ply then return end
						ply = v_ply
						Stats.OpenStats(ply)
					else
						ply = steamid
						Stats.OpenOtherPlayerStats(steamid)
					end
					stats_loading = true
				else
					Derma_Message("Bitte gebe eine gültige SteamID an.", "Ungültige SteamID", "In Ordnung...")
					return
				end
				Stats_PlayerModel:SetModel("")
			end,
			nil,
			"Suchen",
			"Zurück"
		)
	end
	OfflinePlayerButton.Paint = function(w, h)
		local col = Stats.PlayerColor
		if OfflinePlayerButton.Hovered then
			col = Color(col.r, col.g, col.b, col.a - 20)
		end
		draw.RoundedBox(0, 0, 0, OfflinePlayerButton:GetWide(), OfflinePlayerButton:GetTall(), col)
	end
	local PrivateButton = vgui.Create("DButton", Stats_Background)
	PrivateButton:SetColor(Color(255, 255, 255))
	PrivateButton:SetFont("Stats_SelectButton")
	PrivateButton:SetText("Privates Profil")
	PrivateButton:SetSize(250, 50)
	PrivateButton:SetPos(5, 125)
	PrivateButton.DoClick = function(btn)
		if (private == 1) then
			Derma_Query("Wenn du dein Profil öffentlich machst, werden alle Spieler Zugriff auf deine Statistiken haben.", "Profil Öffentlich machen", "Öffentlich machen", function() private = 0 Stats.ChangeProfilePrivacy(false) end, "Abbrechen")
		else
			Derma_Query("Wenn du dein Profil privat machst, wird niemand außer dir mehr Zugriff auf deine Statistiken haben.", "Profil Privat machen", "Privat machen", function() private = 1 Stats.ChangeProfilePrivacy(true) end, "Abbrechen")
		end
	end
	PrivateButton.Paint = function(w, h)
		if (private == 1) then
			PrivateButton:SetColor(Color(0, 255, 0))
		else
			PrivateButton:SetColor(Color(255, 0, 0))
		end
		local col = Stats.PlayerColor
		if PrivateButton.Hovered then
			col = Color(col.r, col.g, col.b, col.a - 20)
		end
		draw.RoundedBox(0, 0, 0, PrivateButton:GetWide(), PrivateButton:GetTall(), col)
	end
end)