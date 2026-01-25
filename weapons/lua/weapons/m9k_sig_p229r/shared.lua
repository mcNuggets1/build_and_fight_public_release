SWEP.Category = "M9K Pistols"
SWEP.PrintName = "SIG Sauer P229R"
SWEP.Slot = 1
SWEP.SlotPos = 4
SWEP.Weight = 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_sick_p228.mdl"
SWEP.WorldModel = Model("models/weapons/w_sig_229r.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Sauer1_P228.Single")
SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 12
SWEP.Primary.KickUp = 0.75
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0.024
SWEP.Primary.IronAccuracy = 0.013
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-2.653, -0.686, 1.06)
SWEP.SightsAng = Vector(0.235, 0.02, 0)
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