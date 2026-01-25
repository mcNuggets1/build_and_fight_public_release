SWEP.Category = "M9K Pistols"
SWEP.PrintName = "S&W Model 3 Russian"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_pist_model3.mdl"
SWEP.WorldModel = Model("models/weapons/w_model_3_rus.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Model3.Single")
SWEP.Primary.RPM = 150
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"	
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 50
SWEP.Primary.Spread	= 0.019
SWEP.Primary.IronAccuracy = 0.0086
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(4.06, 0, 0.876)
SWEP.SightsAng = Vector(-0.207, -0.02, 0)
SWEP.RunSightsPos = Vector(-1.5, -14, -7)
SWEP.RunSightsAng = Vector(70, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end