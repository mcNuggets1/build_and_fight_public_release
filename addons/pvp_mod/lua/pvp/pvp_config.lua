PVP = PVP or {}

-- Config Begin --

PVP.BuilderName = "Builder"
PVP.FighterName = "Fighter"

PVP.BuilderColor = Color(0, 0, 255, 255)
PVP.FighterColor = Color(255, 0, 0, 255)

PVP.BuilderHUDColor = Color(100, 100, 255, 255)
PVP.FighterHUDColor = Color(255, 100, 100, 255)

PVP.BuilderCommands = {
	["!build"] = true,
	["/build"] = true,
	["!builder"] = true,
	["/builder"] = true,
	["!pvpoff"] = true,
	["/pvpoff"] = true,
	["!b"] = true,
	["/b"] = true
}

PVP.FighterCommands = {
	["!fight"] = true,
	["/fight"] = true,
	["!fighter"] = true,
	["/fighter"] = true,
	["!pvpon"] = true,
	["/pvpon"] = true,
	["!f"] = true,
	["/f"] = true
}

PVP.BuilderInvincible = true
PVP.DisableBuilderFighterDamage = true

PVP.NoDamageOwnerEntities = {
	["hoverboard_avatar"] = true,
	["hoverboard_hull"] = true
}

PVP.EnablePSRewards = true

PVP.PS_SpawnReward = 5
PVP.PS_BreakPropReward = 25
PVP.PS_UseToolReward = 2

PVP.PS_NewEnergy = 20
PVP.PS_KillReward = 150
PVP.PS_KillReward_2Kills = 175
PVP.PS_KillReward_3Kills = 200
PVP.PS_KillReward_4Kills = 225
PVP.PS_KillReward_5Kills = 250
PVP.PS_KillReward_6Kills = 275
PVP.PS_KillReward_7Kills = 300
PVP.PS_KillReward_8Kills = 325
PVP.PS_KillReward_9Kills = 350
PVP.PS_KillReward_10Kills = 375
PVP.PS_KillReward_10KillsOrAbove = 400
PVP.PS_KillReward_AllowAssists = true
PVP.PS_KillReward_Assist = 75
PVP.PS_KillReward_SameTarget = 25
PVP.PS_KillReward_NearDeath = 160
PVP.PS_KillReward_Headshot = 170
PVP.PS_KillReward_Melee = 175

PVP.PS_KillReward_MeleeWeapons = {
	["m9k_baseball_bat"] = true,
	["m9k_knife"] = true,
	["m9k_machete"] = true,
	["m9k_damascus"] = true,
	["m9k_sledgehammer"] = true,
	["m9k_spade"] = true,
	["m9k_hatchet"] = true,

	["weapon_emp"] = true,
	["weapon_flopper"] = true,
	["weapon_blink"] = true,
	["weapon_fists"] = true,
	["weapon_superfists"] = true,

	["weapon_crowbar"] = true,
	["weapon_stunstick"] = true,
}

PVP.AllowDropCommand = true

PVP.DropWeaponCommands = {
	["!drop"] = true,
	["/drop"] = true,
	["!d"] = true,
	["/d"] = true
}

PVP.DisallowDrop = {
	["weapon_fists"] = true,
	["weapon_physcannon"] = true,
	["weapon_lockpick"] = true,
	["weapon_superfists"] = true,
	["weapon_finger"] = true,
	["weapon_tasered"] = true,
	["m9k_fists"] = true
}

PVP.CleanMapEntities = {
	["npc_tripmine"] = true,
	["mineturtle"] = true,
	["m9k_proxy"] = true,
	["m9k_thrown_nitro"] = true,
	["m9k_thrown_nitrox"] = true,
	["m9k_nervegasnade"] = true
}

PVP.BuilderJoinDelay = 10

PVP.WeaponsAllowed = false
PVP.AllowFighterWeapons = false

PVP.DisableNPCs = true
PVP.DisableProps = true
PVP.DisableEntities = true
PVP.DisableEffects = true
PVP.DisableRagdolls = true
PVP.DisableVehicles = true
PVP.DisableProperties = true

PVP.BuilderLoadout = {
	"weapon_physgun",
	"weapon_physcannon",
	"gmod_tool",
	"gmod_camera"
}

PVP.DefaultBuilderWeapon = "weapon_physgun"

PVP.FighterLoadout = {
	"weapon_physcannon",
	"weapon_fists",
	"weapon_lockpick"
}

PVP.DefaultFighterWeapon = "weapon_fists"

PVP.FighterLoadoutAmmo = {
}

PVP.AllowFallDamage = true

PVP.AllowedWeaponsBlacklist = false

PVP.AllowedWeapons = {
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["weapon_bugbait"] = true,
	["weapon_blink"] = true,
	["vc_jerrycan"] = true,
	["vc_wrench"] = true
}

PVP.HelpMessage = "[HILFE] Du kannst deine Klasse mit F7 und F8 zu jeder Zeit ändern."
PVP.BuilderMessage = " ist nun Builder."
PVP.FighterMessage = " ist nun Fighter."

PVP.UseShortcuts = true

PVP.UseHUD = true
PVP.FontName = system.IsWindows() and "Tahoma" or "Verdana"
PVP.FontSize = 13
PVP.FontWeight = 600

PVP.FontName2 = system.IsWindows() and "Tahoma" or "Verdana"
PVP.FontSize2 = 11
PVP.FontWeight2 = 0

PVP.BuilderTeamNumber = 100
PVP.FighterTeamNumber = 200

PVP.HoverboardHotfix = true

-- Config End --
