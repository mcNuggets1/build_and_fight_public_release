SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "M4A1 Iron"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_m4a1_iron.mdl"
SWEP.WorldModel = Model("models/weapons/w_m4a1_iron.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Dmgfok_M4A1.Single")
SWEP.Primary.RPM = 830
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.028
SWEP.Primary.IronAccuracy = 0.01
SWEP.SightsPos = Vector(2.4537, 1.0923, 0.2696)
SWEP.SightsAng = Vector(-0.0105, -0.02, 0)
SWEP.RunSightsPos = Vector(-3.0328, 0, -0.5)
SWEP.RunSightsAng = Vector(-14.2146, -36.522, 10)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end