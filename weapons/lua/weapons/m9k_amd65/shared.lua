SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AMD 65"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_amd_65.mdl"
SWEP.WorldModel	= Model("models/weapons/w_amd_65.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("amd65.single")
SWEP.Primary.RPM = 765
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp = 0.7
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 28
SWEP.Primary.Spread = 0.033
SWEP.Primary.IronAccuracy = 0.01
SWEP.DeployDelay = 0.95
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(3.504, -2.21, 2.115)
SWEP.SightsAng = Vector(-3.701, -0.023, 0)
SWEP.RunSightsPos = Vector(-5.198, -9.164, 0)
SWEP.RunSightsAng = Vector(-8.825, -70, 0)
SWEP.WeaponType = "assault"

SWEP.VElements = {
	["element"] = {type = "Model", model = "models/mechanics/wheels/wheel_speed_72.mdl", bone = "Havana Daydreamin", rel = "", pos = Vector(-0.15, -5.336, 1.608), angle = Angle(0, 0, 90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end