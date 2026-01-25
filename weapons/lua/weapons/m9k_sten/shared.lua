SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "STEN"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_smgsten.mdl"
SWEP.WorldModel = Model("models/weapons/w_sten.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weaponsten.Single")
SWEP.Primary.RPM = 520
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.55
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 28
SWEP.Primary.Spread = 0.035
SWEP.Primary.IronAccuracy = 0.017
SWEP.SightsPos = Vector(4.367, -1.476, 3.119)
SWEP.SightsAng = Vector(-0.34, -0.487, 0)
SWEP.RunSightsPos = Vector(-2.3095, -3.0514, 2.3965)
SWEP.RunSightsAng = Vector(-19.8471, -33.9181, 10)
SWEP.LoweredAng = Vector(-12, 0, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end