SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "TEC-9"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_tec_9_smg.mdl"
SWEP.WorldModel = Model("models/weapons/w_intratec_tec9.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_Tec9.Single")
SWEP.Primary.RPM = 825
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.KickUp = 0.45
SWEP.Primary.KickHorizontal = 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = 0.036
SWEP.Primary.IronAccuracy = 0.018
SWEP.SightsPos = Vector(4.314, -1.216, 2.135)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-5.434, -1.181, 0.393)
SWEP.RunSightsAng = Vector(-6.89, -42.166, 0)
SWEP.LoweredAng = Vector(-10, 0, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end
