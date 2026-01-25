SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "FAMAS F1"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_tct_famas.mdl"
SWEP.WorldModel = Model("models/weapons/w_tct_famas.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_FAMTC.Single")
SWEP.Primary.RPM = 950
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 22
SWEP.Primary.Spread = 0.033
SWEP.Primary.IronAccuracy = 0.01
SWEP.SightsPos = Vector(-3.36, 0, 0.247)
SWEP.SightsAng = Vector(-0.04, -0.515, 0)
SWEP.RunSightsPos = Vector(1, -3.6313, 0)
SWEP.RunSightsAng = Vector(-15.1165, 43.8507, -18.2067)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end