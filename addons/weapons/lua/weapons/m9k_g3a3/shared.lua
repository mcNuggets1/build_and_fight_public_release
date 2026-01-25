SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "HK G3A3"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_hk_g3_rif.mdl"
SWEP.WorldModel	= Model("models/weapons/w_hk_g3.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.Primary.Sound = Sound("hk_g3_weapon.Single")
SWEP.Primary.RPM = 550
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp	= 0.65
SWEP.Primary.KickHorizontal = 0.45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 35
SWEP.Primary.Spread = 0.034
SWEP.Primary.IronAccuracy = 0.015
SWEP.SightsPos = Vector(-2.417, -2.069, 1.498)
SWEP.SightsAng = Vector(-0.109, -0.288, 0)
SWEP.RunSightsPos = Vector(3.384, -3.044, -0.264)
SWEP.RunSightsAng = Vector(-7.402, 43.334, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end