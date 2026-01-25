SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Striker 12"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_striker_12g.mdl"
SWEP.WorldModel = Model("models/weapons/w_striker_12g.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("ShotStriker12.Single")
SWEP.Primary.RPM = 365
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12
SWEP.Primary.KickUp = 2.2
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.28
SWEP.Primary.NumShots = 12
SWEP.Primary.Damage = 3.6
SWEP.Primary.Spread = 0.13
SWEP.Primary.IronAccuracy = 0.12
SWEP.SightsPos = Vector(3.805, -1.045, 1.805)
SWEP.SightsAng = Vector(2.502, 3.431, 0)
SWEP.RunSightsPos = Vector(-6.237, -6.376, 1.167)
SWEP.RunSightsAng = Vector(-8.391, -63.543, 0)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end