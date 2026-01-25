MG = MG or {}

MG.TranslateWeapons = true

local weapon = weapons.GetStored
local ent = scripted_ents.GetStored

local function MG_AddTranslatedWeaponParts()
	if !MG.TranslateWeapons then return end
	weapon("mg_gun_base").Translations.Shoot = "Schießen"
	weapon("mg_gun_base").Translations.Aim = "Zielen"
	weapon("mg_gun_base").Translations.ReloadAction = "Waffe nachladen"
	weapon("mg_gun_base").Translations.Silence = "Schalldämpfer (ab)montieren"
	weapon("mg_gun_base").Translations.SelectFire = "Feuermodus umstellen"

	weapon("mg_gun_base").Translations.Primary = "Linksklick"
	weapon("mg_gun_base").Translations.Secondary = "Rechtsklick"
	weapon("mg_gun_base").Translations.Reload = "R"
	weapon("mg_gun_base").Translations.Use = "E"

	weapon("mg_gun_base").Translations.AutomaticSelected = "Automatisch ausgewählt."
	weapon("mg_gun_base").Translations.SemiSelected = "Halbautomatisch ausgewählt."
	weapon("mg_gun_base").Translations.LoweredWeapon = "Waffe gesichert."

	weapon("mg_nade_base").Instructions = "Linkslick zum Werfen einer Granate.\nRechtsklick zum Rollen einer Granate."

	weapon("m9k_minigun").PrintName = "M134 Maschinengewehr"
	weapon("m9k_scoped_taurus").PrintName = "Raging Bull (Visier)"
	weapon("m9k_dbarrel").PrintName = "Doppelläufige Schrotflinte"
	weapon("m9k_ied_detonator").PrintName = "Handybombe"
	weapon("m9k_orbital_strike").PrintName = "Luftschlag"
	weapon("m9k_m61_frag").PrintName = "M61-Granate"
	weapon("m9k_sticky_grenade").PrintName = "Haftgranate"
	weapon("m9k_flash_grenade").PrintName = "Blendgranate"
	weapon("m9k_smoke_grenade").PrintName = "Rauchgranate"
	weapon("m9k_nerve_gas").PrintName = "Nervengas"
	weapon("m9k_proxy_mine").PrintName = "Proxymine"
	weapon("m9k_harpoon").PrintName = "Harpune"
	weapon("m9k_machete").PrintName = "Machete"
	weapon("m9k_knife").PrintName = "Messer"
	weapon("m9k_damascus").PrintName = "Ninjaschwert"

	weapon("m9k_baseball_bat").PrintName = "Baseballschläger"
	weapon("m9k_hatchet").PrintName = "Beil"
	weapon("m9k_sledgehammer").PrintName = "Vorschlaghammer"
	weapon("m9k_spade").PrintName = "Spaten"

	weapon("m9k_an94").SpreadFireSelectedText = "Ausbruchsfeuer ausgewählt."
	weapon("m9k_c4").Instructions = "Linksklick zum Platzieren.\nRechtsklick zum Konfigurieren."
	weapon("m9k_c4").ThirtySecondsSelected = "30 Sekunden ausgewählt."
	weapon("m9k_c4").FortyFiveSecondsSelected = "45 Sekunden ausgewählt."
	weapon("m9k_c4").SixtySecondsSelected = "60 Sekunden ausgewählt."
	weapon("m9k_c4").HundredTwentySecondsSelected = "120 Sekunden ausgewählt."

	weapon("m9k_suicide_bomb").Instructions = "Linksklick zum Platzieren.\nRechtsklick zum Konfigurieren."
	weapon("m9k_suicide_bomb").WrongJobText = "Du musst Terrorist sein, damit du C4 legen kannst."
	weapon("m9k_suicide_bomb").TenSecondsSelected = "10 Sekunden ausgewählt."
	weapon("m9k_suicide_bomb").TwentySecondsSelected = "20 Sekunden ausgewählt."
	weapon("m9k_suicide_bomb").ThirtySecondsSelected = "30 Sekunden ausgewählt."
	weapon("m9k_suicide_bomb").FourtyFiveSecondsSelected = "45 Sekunden ausgewählt."
	weapon("m9k_suicide_bomb").DetonationOnUseSelected = "Warnung: Sofortige Detonation ausgewählt."

	weapon("m9k_ied_detonator").Instructions = "Linksklick zum Platzieren einer Handybombe.\nRechtsklick zum Detonieren."
	weapon("m9k_ied_detonator").WrongJobText = "Du musst Terrorist sein, damit du eine Handybombe platzieren kannst."
	weapon("m9k_harpoon").Instructions = "Linksklick zum Werfen."
	weapon("m9k_orbital_strike").Instructions = "Linksklick auf eine beliebige Stelle, um einen Luftschlag anzufordern."
	weapon("m9k_machete").Instructions = "Linksklick zum Angreifen.\nRechtsklick zum Werfen."
	weapon("m9k_knife").Instructions = "Linksklick für eine leichte Attacke.\nRechtsklick für eine schwere Attacke.\nNachladen zum Werfen."
	weapon("m9k_damascus").Instructions = "Linksklick zum Angreifen.\nRechtsklick zum Blockieren halten."
	weapon("m9k_proxy_mine").Instructions = "Linksklick zum Platzieren."

	weapon("m9k_baseball_bat").Instructions = "Linksklick für eine leichte Attacke.\nRechtsklick für eine schwere Attacke."
	weapon("m9k_hatchet").Instructions = "Linksklick zum Angreifen.\nRechtsklick zum Werfen."
	weapon("m9k_sledgehammer").Instructions = "Linksklick für eine leichte Attacke.\nRechtsklick für eine schwere Attacke."
	weapon("m9k_spade").Instructions = "Linksklick für eine leichte Attacke.\nRechtsklick für eine schwere Attacke."

	ent("m9k_gdcwa_matador_90mm").t.PrintName = "Matador-Rakete"
	ent("m9k_gdcwa_rpg_heat").t.PrintName = "RPG-7-Rakete"
	ent("m9k_improvised_explosive").t.PrintName = "Paketbombe"
	ent("m9k_launched_ex41").t.PrintName = "EX41-Granate"
	ent("m9k_launched_m79").t.PrintName = "M79-Granate"
	ent("m9k_m202_rocket").t.PrintName = "M202-Rakete"
	ent("m9k_mad_c4").t.PrintName = "Platziertes C4"
	ent("m9k_milkor_nade").t.PrintName = "Milkor Mk1-Granate"
	ent("m9k_nervegasnade").t.PrintName = "Nervengas"
	ent("m9k_oribital_cannon").t.PrintName = "Ausgeführter Luftschlag"
	ent("m9k_proxy").t.PrintName = "Platzierte Proxymine"
	ent("m9k_thrown_harpoon").t.PrintName = "Geworfene Harpune"
	ent("m9k_thrown_machete").t.PrintName = "Geworfene Machete"
	ent("m9k_thrown_m61").t.PrintName = "Geworfene M61-Granate"
	ent("m9k_thrown_flash").t.PrintName = "Geworfene Blendgranate"
	ent("m9k_thrown_smoke").t.PrintName = "Geworfene Rauchgranate"
	ent("m9k_thrown_nitrox").t.PrintName = "Geworfenes Nitro Glycerin"
	ent("m9k_thrown_knife").t.PrintName = "Geworfenes Messer"
	ent("m9k_thrown_sticky_grenade").t.PrintName = "Geworfene Haftgranate"

	print("[MG] Translations initialised!")
end

hook.Add("OnGamemodeLoaded", "MG_AddTranslatedWeaponParts", MG_AddTranslatedWeaponParts)
hook.Add("OnReloaded", "MG_AddTranslatedWeaponParts", MG_AddTranslatedWeaponParts)