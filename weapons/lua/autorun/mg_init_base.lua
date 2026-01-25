MG = MG or {}

MG.TranslateAmmo = true

MG.AutomaticSelected = "Automatisch ausgewählt."
MG.SemiSelected = "Halbautomatisch ausgewählt."

MG.LMGAmmoName = "Maschinengewehrmunition"
MG.SniperAmmoName = "Scharfschützengewehrmunition"

MG.M61Frag = "M61-Granate"
MG.FlashGrenade = "Blendgranate"
MG.SmokeGrenade = "Rauchgranate"
MG.StickyGrenade = "Haftgranate"

MG.EX41Nade = "EX41-Granate"
MG.M202Round = "M202-Geschoss"
MG.M79Nade = "M79 GL-Granate"
MG.MatadorRound = "Matador-Geschoss"
MG.MilkorNade = "Milkor Mk1-Granate"
MG.RPG7Round = "RPG-7-Geschoss"

MG.PistolAmmo = "Pistolenmunition"
MG.RevolverAmmo = "Revolvermunition"
MG.SMGAmmo = "SMG-Munition"
MG.SMGGrenade = "SMG-Granate"
MG.HeavyAmmo = "Gewehrmunition"
MG.Impulse = "AR2-Impuls"
MG.ShotgunAmmo = "Schrotflintenmunition"
MG.GrenadeAmmo = "Granate"
MG.RPG_Round = "RPG-Geschoss"
MG.SLAMs = "S.L.A.M"

print("[MG Weapons] mg_weapons-Config loaded!")

if MG.TranslateAmmo then
	if CLIENT then
		language.Add("Pistol_ammo", MG.PistolAmmo)
		language.Add("357_ammo", MG.RevolverAmmo)
		language.Add("SMG1_ammo", MG.SMGAmmo)
		language.Add("SMGGrenade_ammo", MG.SMGGrenade)
		language.Add("AR2_ammo", MG.HeavyAmmo)
		language.Add("AR2AltFire_ammo", MG.Impulse)
		language.Add("Buckshot_ammo", MG.ShotgunAmmo)
		language.Add("Grenade_ammo", MG.GrenadeAmmo)
		language.Add("RPG_Round_ammo", MG.RPG_Round)
		language.Add("Slam_ammo", MG.SLAMs)
	end
end

if CLIENT then
	language.Add("LMG_ammo", MG.LMGAmmoName)
	language.Add("SniperPenetratedRound_ammo", MG.SniperAmmoName)

	language.Add("LMG_ammo", MG.LMGAmmoName)
	language.Add("SniperPenetratedRound_ammo", MG.SniperAmmoName)

	language.Add("m61_frag_ammo", MG.M61Frag)
	language.Add("flash_grenade_ammo", MG.FlashGrenade)
	language.Add("smoke_grenade_ammo", MG.SmokeGrenade)
	language.Add("sticky_nade_ammo", MG.StickyGrenade)

	language.Add("ex41_nade_ammo", MG.EX41Nade)
	language.Add("m202_round_ammo", MG.M202Round)
	language.Add("m79_nade_ammo", MG.M79Nade)
	language.Add("matador_round_ammo", MG.MatadorRound)
	language.Add("milkorm_nade_ammo", MG.LMGAmmoName)
	language.Add("rpg7_round_ammo", MG.RPG7Round)
end

game.AddAmmoType({name = "LMG", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "SniperPenetratedRound", dmgtype = DMG_BULLET})

game.AddAmmoType({name = "m61_frag", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "flash_grenade", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "smoke_grenade", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "sticky_nade", dmgtype = DMG_BULLET})

game.AddAmmoType({name = "ex41_nade", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "m202_round", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "m79_nade", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "matador_round", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "milkorm_nade", dmgtype = DMG_BULLET})
game.AddAmmoType({name = "rpg7_round", dmgtype = DMG_BULLET})

if !ConVarExists("mg_m9k_disablecontextmenu") then
	CreateConVar("mg_m9k_disablecontextmenu", 0, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Disable/enable context menu while holding a weapon.")
	print("[MG Weapons] mg_m9k_disablecontextmenu-ConVar initialised!")
end

if !ConVarExists("mg_m9k_stripweapon") then
	CreateConVar("mg_m9k_stripweapon", 0, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Strip/keep empty weapons.")
	print("[MG Weapons] mg_m9k_stripweapon-ConVar initialised!")
end

if !ConVarExists("mg_m9k_dynamicrecoil") then
	CreateConVar("mg_m9k_dynamicrecoil", 1, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Enable/disable realistic recoil.")
	print("[MG Weapons] mg_m9k_dynamicrecoil-ConVar initialised!")
end

if !ConVarExists("mg_m9k_damagemultiplicator") then
	CreateConVar("mg_m9k_damagemultiplicator", 1, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Used to modify the damage multiplicator.")
	print("[MG Weapons] mg_m9k_damagemultiplicator-ConVar initialised!")
end

if !ConVarExists("mg_m9k_spreadmultiplicator") then
	CreateConVar("mg_m9k_spreadmultiplicator", 0.75, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Used to modify the spread multiplicator.")
	print("[MG Weapons] mg_m9k_spreadmultiplicator-ConVar initialised!")
end

if !ConVarExists("mg_m9k_recoilmultiplicator") then
	CreateConVar("mg_m9k_recoilmultiplicator", 1, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Used to modify the recoil multiplicator.")
	print("[MG Weapons] mg_m9k_recoilmultiplicator-ConVar initialised!")
end

if !ConVarExists("mg_m9k_defaultclip") then
	CreateConVar("mg_m9k_defaultclip", -1, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Additional Magazines for weapons.")
	print("[MG Weapons] mg_m9k_defaultclip-ConVar initialised!")
end

if !ConVarExists("mg_m9k_jumppenaltymult") then
	CreateConVar("mg_m9k_jumppenaltymult", 1.25, {FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Spread penalty for shooting midair.")
	print("[MG Weapons] mg_jumppenalty-ConVar initialised!")
end