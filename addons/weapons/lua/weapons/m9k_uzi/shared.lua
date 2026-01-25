SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "UZI"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_imi_uzi01.mdl"
SWEP.WorldModel = Model("models/weapons/w_uzi_imi.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_uzi.single")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = 0.037
SWEP.Primary.IronAccuracy = 0.019
SWEP.SightsPos = Vector(-2.951, -2.629, 1.633)
SWEP.SightsAng = Vector(0.109, -0.75, 1.725)
SWEP.RunSightsPos = Vector(3.858, -2.945, 0.057)
SWEP.RunSightsAng = Vector(-5.237, 40.471, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end