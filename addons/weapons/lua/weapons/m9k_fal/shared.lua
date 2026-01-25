SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "FN FAL"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_fnfalnato.mdl"
SWEP.WorldModel = Model("models/weapons/w_fn_fal.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("fnfal.Single")
SWEP.Primary.RPM = 650
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp = 1
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 32
SWEP.Primary.Spread	= 0.03
SWEP.Primary.IronAccuracy = 0.015
SWEP.SightsPos = Vector(-3.166, -1.068, 1.24)
SWEP.SightsAng = Vector(0.4, 0.028, 0)
SWEP.RunSightsPos = Vector(2.598, -2.441, 0.36)
SWEP.RunSightsAng = Vector(-7.993, 37.756, -6.89)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end