SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Colt 1911"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/f_dmgf_co1911.mdl"
SWEP.WorldModel = Model("models/weapons/s_dmgf_co1911.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Dmgfok_co1911.Single")
SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.KickUp = 0.9
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 36
SWEP.Primary.Spread = 0.0225
SWEP.Primary.IronAccuracy = 0.01
SWEP.DeployDelay = 0.95
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-2.6004, -1.3877, 1.1892)
SWEP.SightsAng = Vector(0.3756, 0.04, 0.103)
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