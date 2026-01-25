SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "TMP"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_smg_tmp.mdl"
SWEP.WorldModel = Model("models/weapons/3_smg_tmp.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_TMP.1")
SWEP.Primary.RPM = 875
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.45
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = 0.03
SWEP.Primary.IronAccuracy = 0.018
SWEP.CanSelectFire = true
SWEP.DeployDelay = 0.95
SWEP.SightsPos = Vector(2.59, -1.3, 2.026)
SWEP.SightsAng = Vector(0, -0.129, 0.291)
SWEP.RunSightsPos = Vector(-6.693, -6.378, 2.282)
SWEP.RunSightsAng = Vector(-17.914, -49.882, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end