local afk_flagminutes = CreateConVar("afk_flagminutes", 5, FCVAR_ARCHIVE, "How many minutes a player can be AFK before being flagged as AFK.")
local afk_kickminutes = CreateConVar("afk_kickminutes", 45, FCVAR_ARCHIVE, "How many minutes a player can be AFK before being kicked.")
local afk_ignoreadmins = CreateConVar("afk_ignoreadmins", 1, FCVAR_ARCHIVE, "Should we ignore AFK admins? (1=yes, 0=no).")
local afk_kickonafk = CreateConVar("afk_kickonafk", 1, FCVAR_ARCHIVE, "Should AFK players be kicked from the server at all? (1=yes, 0=no).")
local afk_kickonlywhenfull = CreateConVar("afk_kickonlywhenfull", 0, FCVAR_ARCHIVE, "Should the script only kick afk players when the server is full? (1=yes, 0=no).")

local function CheckAFK(ply)
	if (ply:IsAdmin() and afk_ignoreadmins:GetInt() == 1) then return end
	ply.afkc = ply.afkc + 1
	if ply.afkc >= afk_flagminutes:GetInt() then
		if !ply.afk then
			ply.afk = true
			if ULib then
				ULib.tsayColor(_, team.GetColor(ply:Team()), ply:Name(), color_white, " ist nun ", Color(255, 0, 0, 255), "AFK.")
			else
				PrintMessage(HUD_PRINTTALK, ply:Name().." ist nun AFK.")
			end
		end
	end
	if (ply.afkc >= afk_kickminutes:GetInt()) and afk_kickonafk:GetInt() then
		if (afk_kickonlywhenfull:GetInt() == 1)  and (player.GetCount() < game.MaxPlayers()) then return end
		ULib.kick(ply, "Du warst zu lange AFK und wurdest gekickt!")
	end
end

hook.Add("PlayerInitialSpawn", "AFK_CreateTimer", function(ply)
	ply.afkc = 0
	ply.afk = false
	timer.Create("afk_timer_"..ply:SteamID(), 60, 0, function()
		CheckAFK(ply)
	end)
end)

hook.Add("PlayerDisconnected", "AFK_RemoveTimer", function(ply)
	timer.Remove("afk_timer_"..ply:SteamID())
end)

local function ResetAFKStatus(ply)
	ply.afkc = 0
	if ply.afk then
		ply.afk = false
		if ULib then
			ULib.tsayColor(_, team.GetColor(ply:Team()), ply:Name(), color_white, " ist nicht länger ", Color(255, 0, 0, 255), "AFK.")
		else
			PrintMessage(HUD_PRINTTALK, ply:Name().." ist nicht länger AFK.")
		end
	end
end
hook.Add("PlayerButtonDown", "AFK_KeyPress", ResetAFKStatus)