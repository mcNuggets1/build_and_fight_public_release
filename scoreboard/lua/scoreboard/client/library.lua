Scoreboard.Kick = function(ply)
	if !IsValid(ply) then return end
	RunConsoleCommand("ulx", "kick", ply:Name(), "Quick Kick")
end

Scoreboard.Ban = function(ply) 
	if !IsValid(ply) then return end
	Scoreboard.vgui:SetVisible(false)
	xgui.ShowBanWindow(ply, ply:SteamID(), true)
end

Scoreboard.OpenStats = function(ply) 
	if !IsValid(ply) or !Stats then return end
	gui.EnableScreenClicker(false)
	Scoreboard.vgui:SetVisible(false)
	Stats.OpenStats(ply)
end

Scoreboard.OpenUTime = function(ply) 
	if !IsValid(ply) or !UTime then return end
	gui.EnableScreenClicker(false)
	Scoreboard.vgui:SetVisible(false)
	UTime.AskData(ply:SteamID())
end

Scoreboard.CreateVGUI = function()
	if IsValid(Scoreboard.vgui) then
		Scoreboard.vgui:Remove()
		Scoreboard.vgui = nil
	end
	Scoreboard.vgui = vgui.Create("Scoreboard")
	return true
end

Scoreboard.Show = function()
	if !IsValid(Scoreboard.vgui) then
		Scoreboard.CreateVGUI()
	end
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)
	Scoreboard.vgui:SetVisible(true)
	Scoreboard.vgui:UpdateScoreboard(true)
	Scoreboard.vgui:UpdatePlayerList()
	return true
end

Scoreboard.Hide = function()
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker(false)
	if IsValid(Scoreboard.vgui) then
		Scoreboard.vgui:SetVisible(false)
	end
	return true
end