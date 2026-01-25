SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "Bizon PP19"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight	= 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_bizon19.mdl"
SWEP.WorldModel	= Model("models/weapons/w_pp19_bizon.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_P19.Single")
SWEP.Primary.RPM = 675
SWEP.Primary.ClipSize = 64
SWEP.Primary.DefaultClip = 64
SWEP.Primary.KickUp	= 0.75
SWEP.Primary.KickHorizontal	= 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage	= 25
SWEP.Primary.Spread	= 0.039
SWEP.Primary.IronAccuracy = 0.02
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(3.362, 0, 0.839)
SWEP.SightsAng = Vector(0.65, -0.615, 0)
SWEP.RunSightsPos = Vector(-2.3095, -3.0514, 0.5)
SWEP.RunSightsAng = Vector(-10, -38.9181, 5)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end