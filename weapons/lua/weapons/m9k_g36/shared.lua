SWEP.Category= "M9K Assault Rifles"
SWEP.PrintName = "G36"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_rif_g362.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_g36c.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("G36.single")
SWEP.Primary.Sound_Silenced = Sound("G36.SilencedSingle")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.CanSilence = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 31
SWEP.Primary.Spread = 0.041
SWEP.Primary.IronAccuracy = 0.02
SWEP.SightsPos = Vector(2.862, -0.857, 1.06)
SWEP.SightsAng = Vector(0.1, -0.03, 0)
SWEP.RunSightsPos = Vector(-6, -2.571, -0.04)
SWEP.RunSightsAng = Vector(-11, -43, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end