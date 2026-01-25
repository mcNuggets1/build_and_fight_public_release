SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "MP5SD"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_hkmp5sd.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_mp5sd.mdl")
SWEP.Base = "mg_gun_base" 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_hkmp5sd.single")
SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.4
SWEP.Primary.KickHorizontal = 0.25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = 0.038
SWEP.Primary.IronAccuracy = 0.021
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(-2.288, -1.446, 0.884)
SWEP.SightsAng = Vector(2.3, 0.04, 0)
SWEP.RunSightsPos = Vector(3.858, -1.655, -0.866)
SWEP.RunSightsAng = Vector(-4.634, 49.493, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end