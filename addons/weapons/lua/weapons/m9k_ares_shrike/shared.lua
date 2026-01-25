SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "Ares Shrike"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight	= 60
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_ares_shrike01.mdl"
SWEP.WorldModel	= Model("models/weapons/w_ares_shrike.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_shrk.Single")
SWEP.Primary.RPM = 650
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.KickUp	= 0.65
SWEP.Primary.KickHorizontal = 0.55
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.033
SWEP.Primary.IronAccuracy = 0.023
SWEP.SightsPos = Vector(-3.798, 0, 0.495)
SWEP.SightsAng = Vector(0.119, 0, 0)
SWEP.RunSightsPos = Vector(1.639, -3.444, 0)
SWEP.RunSightsAng = Vector(-7.46, 47.048, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end