SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "MP9"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_b_t_mp9.mdl"
SWEP.WorldModel = Model("models/weapons/w_brugger_thomet_mp9.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_mp9.Single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 22
SWEP.Primary.Spread = 0.035
SWEP.Primary.IronAccuracy = 0.019
SWEP.SightsPos = Vector(4.073, -3.438, 1.259)
SWEP.SightsAng = Vector(0.09, -0.005, 0)
SWEP.RunSightsPos = Vector(-4.5, -6.172, 0)
SWEP.RunSightsAng = Vector(-7.661, -62.523, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end