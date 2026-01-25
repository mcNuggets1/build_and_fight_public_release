SWEP.Category = "M9K Pistols"
SWEP.PrintName = "P228"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_pist_p228.mdl"
SWEP.WorldModel = Model("models/weapons/3_pist_p228.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_P228.1")
SWEP.Primary.RPM = 400
SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 36
SWEP.Primary.Spread = 0.023
SWEP.Primary.IronAccuracy = 0.0125
SWEP.RunHoldType = "normal"
SWEP.SightsPos = Vector(2.52, 2.793, 1.399)
SWEP.SightsAng = Vector(0.115, 0.07, 0)
SWEP.RunSightsPos = Vector(-2.437, -6.748, -5.019)
SWEP.RunSightsAng = Vector(59.777, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end