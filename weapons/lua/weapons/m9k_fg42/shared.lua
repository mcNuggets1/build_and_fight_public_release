SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "FG 42"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 50
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_rif_fg42.mdl"
SWEP.WorldModel = Model("models/weapons/w_fg42.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.Primary.Sound = Sound("FG42_weapon.Single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.03
SWEP.Primary.IronAccuracy = 0.02
SWEP.SightsPos = Vector(3.468, -6.078, 1.93)
SWEP.SightsAng = Vector(0, -0.13, 0)
SWEP.RunSightsPos = Vector(-5.738, -1.803, 0)
SWEP.RunSightsAng = Vector(-7.46, -47.624, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end