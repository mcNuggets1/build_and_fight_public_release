SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Five SeveN"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_pist_fiveseven.mdl"
SWEP.WorldModel = Model("models/weapons/3_pist_fiveseven.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_FiveSeven.1")
SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 32
SWEP.Primary.Spread = 0.02
SWEP.Primary.IronAccuracy = 0.011
SWEP.RunHoldType = "normal"
SWEP.SightsPos = Vector(2.686, 0, 1.12)
SWEP.SightsAng = Vector(1.55, -0.032, 0)
SWEP.RunSightsPos = Vector(-1.098, -7.132, -5.106)
SWEP.RunSightsAng = Vector(59.402, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end