SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "PKM"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 50
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_mach_russ_pkm.mdl"
SWEP.WorldModel = Model("models/weapons/w_mach_russ_pkm.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("pkm.Single")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.KickUp = 0.7
SWEP.Primary.KickHorizontal = 0.65
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.022
SWEP.SightsPos = Vector(-2.198, -2.116, 0.36)
SWEP.SightsAng = Vector(-0.3, 0.075, 0)
SWEP.RunSightsPos = Vector(8.276, -1.859, 0)
SWEP.RunSightsAng = Vector(-10.606, 52.087, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end