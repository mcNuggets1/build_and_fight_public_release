SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "Galil"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/2_rif_galil.mdl"
SWEP.WorldModel = Model("models/weapons/3_rif_galil.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_Galil.1")
SWEP.Primary.RPM = 685
SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 35
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 29
SWEP.Primary.Spread = 0.029
SWEP.Primary.IronAccuracy = 0.011
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(-2.965, -2, 1.55)
SWEP.SightsAng = Vector(0, 0.023, 0)
SWEP.RunSightsPos = Vector(5.906, -6, 2.44)
SWEP.RunSightsAng = Vector(-18.466, 64.212, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end