SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "Magpul PDR"
SWEP.Slot = 2
SWEP.SlotPos = 52
SWEP.Weight = 30	
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_pdr_smg.mdl"
SWEP.WorldModel = Model("models/weapons/w_magpul_pdr.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("MAG_PDR.Single")
SWEP.Primary.RPM = 575
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 29
SWEP.Primary.Spread = 0.035
SWEP.Primary.IronAccuracy = 0.017
SWEP.SightsPos = Vector(4.8, 0, 2.079)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-2.437, -1.364, 1.45)
SWEP.RunSightsAng = Vector(-15.263, -41.1, 0)
SWEP.LoweredAng = Vector(-13, 0, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end