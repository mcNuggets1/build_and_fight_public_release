SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Remington 870"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_rem870tactical.mdl"
SWEP.WorldModel = Model("models/weapons/w_remington_870_tact.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("WepRem870.Single")
SWEP.Primary.RPM = 72
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 1.8
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.42
SWEP.Primary.NumShots = 12
SWEP.Primary.Damage = 7.4
SWEP.Primary.Spread = 0.082
SWEP.Primary.IronAccuracy = 0.072
SWEP.DeployDelay = 0.85
SWEP.SightsPos = Vector(-2.014, 0.1, 1.2)
SWEP.SightsAng = Vector(0.351, 0.01, 0)
SWEP.RunSightsPos = Vector(8, -4.646, 1.654)
SWEP.RunSightsAng = Vector(-19.567, 68.622, 0)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end