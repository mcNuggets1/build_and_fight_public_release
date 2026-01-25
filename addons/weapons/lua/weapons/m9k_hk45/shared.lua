SWEP.Category = "M9K Pistols"
SWEP.PrintName = "HK45C"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight	= 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_hk45.mdl"
SWEP.WorldModel	= Model("models/weapons/w_hk45c.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_hk45.Single")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 33
SWEP.Primary.Spread = 0.028
SWEP.Primary.IronAccuracy = 0.014
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-2.315, 0, 0.86)
SWEP.SightsAng = Vector(0, 0.02, 0)
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