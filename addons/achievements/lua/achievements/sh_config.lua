if SERVER then
	AddCSLuaFile()
end

achievements.Skin = "sleek"
achievements.FrameTitle = [[Errungenschaften]]
achievements.ChatCommand = "!achv"
achievements.ConsoleCommand = "achv"
achievements.OpenKey = false
achievements.DataProvider = achievements.DataProvider or "sql"
achievements.ShowInChat = true