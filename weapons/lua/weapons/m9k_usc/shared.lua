SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "HK USC"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_hkoch_usc.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_usc.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_hkusc.Single")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 25
SWEP.Primary.KickUp = 0.75
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0.027
SWEP.Primary.IronAccuracy = 0.013
SWEP.SightsPos = Vector(4.698, -2.566, 2.038)
SWEP.SightsAng = Vector(-0.03, 0.04, 0)
SWEP.RunSightsPos = Vector(-7.814, -8.615, 1)
SWEP.RunSightsAng = Vector(-9.016, -64.764, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end