if SERVER then
	AddCSLuaFile()
	hook.Add("PlayerInitialSpawn", "Scoreboard_PlayerInitialSpawn", Scoreboard.PlayerSpawn)
end

if CLIENT then
	hook.Add("ScoreboardShow", "Scoreboard_Show", Scoreboard.Show)
	hook.Add("ScoreboardHide", "Scoreboard_Hide", Scoreboard.Hide)
end