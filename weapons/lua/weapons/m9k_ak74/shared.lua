SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AK-74"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 76
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_tct_ak47.mdl"
SWEP.WorldModel	= Model("models/weapons/w_tct_ak47.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Tactic_AK47.Single")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.65
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 32
SWEP.Primary.Spread	= 0.03
SWEP.Primary.IronAccuracy = 0.01
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(2.0378, -3.8941, 0.8809)
SWEP.SightsAng = Vector(0, -0.05, 0)
SWEP.RunSightsPos = Vector(-1.3095, -3.0514, 0.7436)
SWEP.RunSightsAng = Vector(-17.8471, -33.9181, 10)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end