SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "HK MP5"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_navymp5.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_mp5.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("mp5_navy_Single")
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 24
SWEP.Primary.Spread = 0.041
SWEP.Primary.IronAccuracy = 0.023
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(2.549, -0.927, 1.09)
SWEP.SightsAng = Vector(-0.01, -0.01, 0)
SWEP.RunSightsPos = Vector(-3.0328, 0, 1.888)
SWEP.RunSightsAng = Vector(-24.2146, -36.522, 10)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end