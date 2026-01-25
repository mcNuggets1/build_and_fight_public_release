SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "M3 Super 90"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_shot_m3super90.mdl"
SWEP.WorldModel = Model("models/weapons/3_shot_m3super90.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_M3Super.1")
SWEP.Primary.RPM = 70
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 3
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.35
SWEP.Primary.NumShots = 8
SWEP.Primary.Damage = 10.6
SWEP.Primary.Spread = 0.09
SWEP.Primary.IronAccuracy = 0.08
SWEP.SightsPos = Vector(2.679, 0, 1.1)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(4.487, -12.992, -7.481)
SWEP.RunSightsAng = Vector(70, -53.189, 0)
SWEP.LoweredPos = Vector(0, 0, -4)
SWEP.LoweredAng = Vector(0, -30, 15)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end