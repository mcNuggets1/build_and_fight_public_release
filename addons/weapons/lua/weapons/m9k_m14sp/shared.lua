SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "M14"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_snip_m14sp.mdl"
SWEP.WorldModel = Model("models/weapons/w_snip_m14sp.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_M14SP.Single")
SWEP.Primary.RPM = 725
SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickHorizontal = 0.7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 45	
SWEP.CanSelectFire = true
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0.026
SWEP.Primary.IronAccuracy = 0.012
SWEP.DeployDelay = 0.85
SWEP.SightsPos = Vector(-2.7050, -1.0539, 1.6562)
SWEP.SightsAng = Vector(0, 0.026, 0)
SWEP.RunSightsPos = Vector(2.9642, -0.6371, -1)
SWEP.RunSightsAng = Vector(-11.0116, 47.5223, -15.3199)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end