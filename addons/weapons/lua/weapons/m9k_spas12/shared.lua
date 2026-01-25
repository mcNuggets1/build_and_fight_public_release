SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "SPAS 12"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 50
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 73
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_spas12_shot.mdl"
SWEP.WorldModel = Model("models/weapons/w_spas_12.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("spas_12_shoty.Single")
SWEP.Primary.RPM = 380
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 2
SWEP.Primary.KickHorizontal = 1.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.38
SWEP.Primary.NumShots = 10
SWEP.Primary.Damage = 4.4
SWEP.Primary.Spread	= 0.09
SWEP.Primary.IronAccuracy = 0.08
SWEP.SightsPos = Vector(2.657,1.394, 1.659)
SWEP.SightsAng = Vector(0.28, -0.07, 0)
SWEP.RunSightsPos = Vector(-3.116, -3.935, 0.492)
SWEP.RunSightsAng = Vector(-19.894, -47.624, 10.902)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end