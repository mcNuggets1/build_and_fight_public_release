SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Mossberg 590"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_shot_mberg_590.mdl"
SWEP.WorldModel = Model("models/weapons/w_mossberg_590.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Mberg_590.Single")
SWEP.Primary.RPM = 75
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 2
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.45
SWEP.Primary.NumShots = 10
SWEP.Primary.Damage = 8.4
SWEP.Primary.Spread	= 0.087
SWEP.Primary.IronAccuracy = 0.077
SWEP.SightsPos = Vector(-2.72, -3.143, 1.26)
SWEP.SightsAng = Vector(0, -0.77, 3)
SWEP.RunSightsPos = Vector(10, -8.429, -0.857)
SWEP.RunSightsAng = Vector(-7, 63, 0)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end