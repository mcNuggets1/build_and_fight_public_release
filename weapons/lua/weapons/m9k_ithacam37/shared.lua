SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Ithaca M37"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_ithaca_m37shot.mdl"
SWEP.WorldModel = Model("models/weapons/w_ithaca_m37.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("IthacaM37.Single")
SWEP.Primary.RPM = 70
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.4
SWEP.Primary.NumShots = 8
SWEP.Primary.Damage = 10.6
SWEP.Primary.Spread	= 0.085
SWEP.Primary.IronAccuracy = 0.075
SWEP.SightsPos = Vector(2.16, 0, 0.6)
SWEP.SightsAng = Vector(3, 0, 0)
SWEP.RunSightsPos = Vector(-5.116, -2, 0)
SWEP.RunSightsAng = Vector(-19.894, -47.624, 10.902)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end