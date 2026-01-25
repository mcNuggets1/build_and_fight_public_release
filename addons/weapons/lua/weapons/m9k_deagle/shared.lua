SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Desert Eagle"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight	= 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_tcom_deagle.mdl"
SWEP.WorldModel = Model("models/weapons/w_tcom_deagle.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_TDegle.Single")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.KickUp	= 1.2
SWEP.Primary.KickHorizontal	= 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage	= 39
SWEP.Primary.Spread = 0.026
SWEP.Primary.IronAccuracy = 0.013
SWEP.DeployDelay = 0.95
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-1.7102, 0, 0.2585)
SWEP.SightsAng = Vector(0, 0.016, 0)
SWEP.RunSightsPos = Vector(3.444, -7.823, -6.27)
SWEP.RunSightsAng = Vector(60.695, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end