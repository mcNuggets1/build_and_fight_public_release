Scoreboard = {}

if SERVER then
	AddCSLuaFile("scoreboard/client/scoreboard.lua")
	AddCSLuaFile("scoreboard/client/admin_buttons.lua")
	AddCSLuaFile("scoreboard/client/player_frame.lua")
	AddCSLuaFile("scoreboard/client/player_infocard.lua")
	AddCSLuaFile("scoreboard/client/player_row.lua")
	AddCSLuaFile("scoreboard/client/scoreboard.lua")
	AddCSLuaFile("scoreboard/client/vote_button.lua")
	AddCSLuaFile("scoreboard/client/library.lua")
	include("scoreboard/server/rating.lua")
	include("scoreboard/server/library.lua")

	hook.Add("PlayerInitialSpawn", "Scoreboard_PlayerInitialSpawn", Scoreboard.PlayerSpawn)
end

if CLIENT then
	Scoreboard.PlayerColor = Color(255, 155, 0, 255)

	include("scoreboard/client/library.lua")
	include("scoreboard/client/scoreboard.lua")

	hook.Add("ScoreboardShow", "Scoreboard_Show", Scoreboard.Show)
	hook.Add("ScoreboardHide", "Scoreboard_Hide", Scoreboard.Hide)
end