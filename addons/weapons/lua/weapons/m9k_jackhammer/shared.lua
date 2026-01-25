SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Pancor Jackhammer"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_jackhammer2.mdl"
SWEP.WorldModel = Model("models/weapons/w_pancor_jackhammer.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_Jackhammer.Single")
SWEP.Primary.RPM = 250
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 2.4
SWEP.Primary.KickHorizontal = 1.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.NumShots = 12
SWEP.Primary.Damage = 3.4
SWEP.Primary.Spread	= 0.11
SWEP.Primary.IronAccuracy = 0.1
SWEP.SightsPos = Vector(4.026, -2.296, 0.917)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-3.116, -3.935, 0.492)
SWEP.RunSightsAng = Vector(-19.894, -47.624, 10.902)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end