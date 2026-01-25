SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AK-47"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_dot_ak47.mdl"
SWEP.WorldModel = Model("models/weapons/w_ak47_m9k.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("47ak.Single")
SWEP.Primary.RPM = 615
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp	= 0.9
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 34
SWEP.Primary.Spread	= 0.023
SWEP.Primary.IronAccuracy = 0.0074
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(4.539, -4.238, 1.799)
SWEP.SightsAng = Vector(0.7, -0.06, 0)
SWEP.RunSightsPos = Vector(-4, -3.386, 0.708)
SWEP.RunSightsAng = Vector(-7.441, -41.614, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end