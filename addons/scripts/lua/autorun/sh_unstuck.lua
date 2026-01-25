if SERVER then
	util.AddNetworkString("StuckMessage")
end

if CLIENT then
	local m = {}
	m[1] = "Wir versuchen dich zu befreien!"
	m[2] = "Du musst auf einen freien Platz zielen! Ziele nicht auf Wände und versuche es in 10 Sekunden erneut!"
	m[3] = "Du solltest nun nicht mehr stucken! Falls doch, kannst du es in 10 Sekunden erneut versuchen!"
	m[4] = "Du musst am leben sein, um den Unstuck-Befehl zu benutzen!"
	m[5] = "Ziele nicht auf eine Wand, versuche einen freien Platz zu erwischen!"
	m[6] = "Bitte benutz den Unstuck-Befehl nicht übereifrig!"
	m[7] = "Bitte ziele nur auf einen freien Platz!"
	m[8] = "Du bist inhaftiert!"
	m[9] = "Du bist eingefroren!"
	m[10] = "Du musst dich am Boden befinden, um den Unstuck-Befehl zu benutzen!"

	net.Receive("StuckMessage", function()
		chat.AddText(Color(200, 100, 100), "[UNSTUCK] ", Color(255, 255, 255), m[net.ReadInt(8)])
	end)
end