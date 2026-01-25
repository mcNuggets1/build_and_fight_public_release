SWEP.Category = "M9K Pistols"
SWEP.PrintName = "S&W Model 500"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_swmodel_500.mdl"
SWEP.WorldModel = Model("models/weapons/w_sw_model_500.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Model_500.Single")
SWEP.Primary.RPM = 150
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Primary.KickUp = 2.5
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 54
SWEP.Primary.Spread	= 0.018
SWEP.Primary.IronAccuracy = 0.008
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-1.923, -1.675, 0.374)
SWEP.SightsAng = Vector(-0.1, 0.02, 0)
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