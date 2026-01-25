SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "M134 Machine Gun"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 70
SWEP.HoldType = "crossbow"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel = Model("models/weapons/w_m134_minigun.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("BlackVulcan.Single")
SWEP.Primary.RPM = 1500
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.KickUp = 0.4
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.Primary.Damage = 14
SWEP.Primary.Spread = 0.043
SWEP.CanAim = false
SWEP.RunSightsPos = Vector(0, -11.148, -8.033)
SWEP.RunSightsAng = Vector(55.082, 0, 0)
SWEP.LoweredAng = Vector(-8, 0, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end