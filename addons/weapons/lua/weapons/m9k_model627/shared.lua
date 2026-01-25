SWEP.Category = "M9K Pistols"
SWEP.PrintName = "S&W Model 627"
SWEP.Slot = 1	
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_swmodel_627.mdl"
SWEP.WorldModel = Model("models/weapons/w_sw_model_627.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("model_627perf.Single")
SWEP.Primary.RPM = 105
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 52
SWEP.Primary.Spread	= 0.02
SWEP.Primary.IronAccuracy = 0.009
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(2.68, 0.019, 1.521)
SWEP.SightsAng = Vector(-0.3, -0.14, 0)
SWEP.RunSightsPos = Vector(-2.419, -4.467, -4.693)
SWEP.RunSightsAng = Vector(56.766, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end