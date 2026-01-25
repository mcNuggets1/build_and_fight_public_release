SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "KRISS Vector"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_kriss_svs.mdl"
SWEP.WorldModel = Model("models/weapons/w_kriss_vector.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("kriss_vector.Single")
SWEP.Primary.RPM = 1000
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.4
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 50
SWEP.Primary.Damage = 19
SWEP.Primary.Spread = 0.036
SWEP.Primary.IronAccuracy = 0.02
SWEP.SightsPos = Vector(3.943, -0.129, 1.677)
SWEP.SightsAng = Vector(-1.922, 0.481, 0)
SWEP.RunSightsPos = Vector(-3.701, -6.064, -0.8)
SWEP.RunSightsAng = Vector(-4.685, -62.559, 9.093)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end