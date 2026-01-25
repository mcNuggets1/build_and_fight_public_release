SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "XM1014"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_shot_xm1014.mdl"
SWEP.WorldModel = Model("models/weapons/3_shot_xm1014.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_XM1014.1")
SWEP.Primary.RPM = 200
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.38
SWEP.Primary.NumShots = 12
SWEP.Primary.Damage = 3.4
SWEP.Primary.Spread = 0.09
SWEP.Primary.IronAccuracy = 0.08
SWEP.SightsPos = Vector(5.35, 0.551, 2.24)
SWEP.SightsAng = Vector(-0.238, 0.78, 4.303)
SWEP.RunSightsPos = Vector(-6, -7.639, 0.236)
SWEP.RunSightsAng = Vector(-9.646, -65.866, 0)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end