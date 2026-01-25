SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "TAR-21"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_imi_tavor.mdl"
SWEP.WorldModel = Model("models/weapons/w_imi_tar21.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Wep_imitavor.single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.4
SWEP.Primary.KickHorizontal = 0.32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = 0.031
SWEP.Primary.IronAccuracy = 0.015
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(-1.825, 0.685, 0.155)
SWEP.SightsAng = Vector(0.65, 0.014, 0)
SWEP.RunSightsPos = Vector(3.858, 0.079, -1.025)
SWEP.RunSightsAng = Vector(-5.237, 49.648, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end