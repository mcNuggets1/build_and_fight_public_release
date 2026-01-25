Perks = Perks or {}
PerkConfig = PerkConfig or {}

PerkConfig.Key = KEY_F3
PerkConfig.KeyName = "F3"
PerkConfig.ChatCommand = "/perks"
PerkConfig.MaxLevel = 100
PerkConfig.XPMultiplier = 3000
PerkConfig.MaxUpgrade = 5
PerkConfig.PrestigeSystem = true
PerkConfig.MaxPrestige = 3
PerkConfig.PrestigeMultiplier = 10
PerkConfig.BuyXP = false
PerkConfig.XPPrice = 0.2
PerkConfig.AllowEdits = true

timer.Simple(0, function()
	PerkMod.AddPerk("Kurzer", 1, 4, "Erhöht Schaden mit Pistolen.")
	PerkMod.AddPerk("Nahkämpfer", 1, 20, "Erhöht Schaden mit Nahkampfwaffen.")
	PerkMod.AddPerk("Revolverheld", 1, 4, "Erhöht Schaden & Präzision mit Revolvern.")
	PerkMod.AddPerk("Ruhige Hand", 1, 2, "Verringert Rückstoß mit allen gewöhnlichen Waffen.")
	PerkMod.AddPerk("Scharfschütze", 5, 4, "Erhöht Präzision mit allen gewöhnlichen Waffen, beim Anvisieren.")
	PerkMod.AddPerk("Bücherwurm", 10, 20, "Erhöht gewöhnlichen XP-Gewinn.")
	PerkMod.AddPerk("Resistenz", 15, 0.5, "Reduziert direkten, von Spielern zugefügten Schaden.")
	PerkMod.AddPerk("Kritisch", 20, 1, "Führt kritische Treffer ein, welche 50% mehr Schaden verursachen.")
	PerkMod.AddPerk("Todeswut", 25, 10, "Erhöht Schaden, wenn Leben gering sind. (Unter 20%)")
	PerkMod.AddPerk("Harte Knochen", 30, 4, "Reduziert Schaden bei Arm und Bein-Beschuss.")
	PerkMod.AddPerk("Stahlschädel", 35, 8, "Reduziert Schaden bei Kopfschüssen.")
	PerkMod.AddPerk("Blitzartig", 40, 2, "Erhöht Bewegungsgeschwindigkeit.")
	PerkMod.AddPerk("Juggernaut", 45, 2, "Erhöht maximale Leben.")
	PerkMod.AddPerk("Doppelläufig", 50, 1, "Führt Chance ein, eine Kugel beim Schießen zu duplizieren.")
	PerkMod.AddPerk("Fingerfertigkeit", 55, 3, "Erhöht Nachladegeschwindigkeit aller gewöhnlichen Waffen.")
	PerkMod.AddPerk("Fester Griff", 60, 2.5, "Erhöht Rausholgeschwindigkeit aller gewöhnlichen Waffen.")
	PerkMod.AddPerk("Adlerauge", 65, 1, "Erhöht Präzision mit allen gewöhnlichen Waffen, aus der Hüfte.")
	PerkMod.AddPerk("Blutige Messe", 70, 1, "Erhöht Schaden mit allen Waffen.")
	PerkMod.AddPerk("Spezialist", 75, 1, "Erhöht maximale Schussrate aller gewöhnlichen Waffen.")
	PerkMod.AddPerk("Vampir", 80, 4, "Gewinnt Leben durch das Töten eines Spielers.")
end)