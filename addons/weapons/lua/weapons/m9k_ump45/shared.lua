SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "HK UMP45"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_hk_ump_45.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_ump45.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("m9k_hk_ump45.Single")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 28
SWEP.Primary.Spread = 0.033
SWEP.Primary.IronAccuracy = 0.015
SWEP.SightsPos = Vector(2.826, -1.601, 1.259)
SWEP.SightsAng = Vector(-0.055, -0.04, 0)
SWEP.RunSightsPos = Vector(-3.386, -5.488, -1)
SWEP.RunSightsAng = Vector(-2.362, -48.78, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end