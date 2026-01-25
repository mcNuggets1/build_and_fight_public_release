SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AS VAL"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dmg_vally.mdl"
SWEP.WorldModel = Model("models/weapons/w_dmg_vally.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Dmgfok_vally.Single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp = 0.4
SWEP.Primary.KickHorizontal = 0.34
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 26
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.012
SWEP.SightsPos = Vector(-2.193, -1.8353, 1.0599)
SWEP.SightsAng = Vector(0.9, 0.1, 0)
SWEP.RunSightsPos = Vector(0.3339, -2.043, -0.3)
SWEP.RunSightsAng = Vector(-11.5931, 48.4648, -19.7039)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end