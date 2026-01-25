SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "SR-3M Vikhr"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dmg_vikhr.mdl"
SWEP.WorldModel = Model("models/weapons/w_dmg_vikhr.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Dmgfok_vikhr.Single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 22
SWEP.Primary.Spread = 0.031
SWEP.Primary.IronAccuracy = 0.016
SWEP.SightsPos = Vector(-2.2363, -1.0859, 0.5292)
SWEP.SightsAng = Vector(1.4076, 0.0907, 0)
SWEP.RunSightsPos = Vector(0.3339, -2.043, -0.1)
SWEP.RunSightsAng = Vector(-11.5931, 42.4648, -19.7039)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end