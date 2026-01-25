SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "73 Winchester Carbine"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_winchester1873.mdl"
SWEP.WorldModel = Model("models/weapons/w_winchester_1873.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_73.Single")
SWEP.Primary.RPM = 66
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 2
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.46
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0.021
SWEP.Primary.IronAccuracy = 0.008
SWEP.SightsPos = Vector(4.356, 0, 2.591)
SWEP.SightsAng = Vector(-0.2, -0.03, 0)
SWEP.RunSightsPos = Vector(-2.3095, -3.0514, 1.9)
SWEP.RunSightsAng = Vector(-19.8471, -33.9181, 10)
SWEP.WeaponType = "assault"

SWEP.GetHeadshotMultiplier = false

SWEP.ViewModelBoneMods = {
	["shell"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
}

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end