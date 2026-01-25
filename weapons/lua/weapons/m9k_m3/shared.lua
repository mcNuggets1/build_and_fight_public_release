SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Benelli M3"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_benelli_m3_s90.mdl"
SWEP.WorldModel = Model("models/weapons/w_benelli_m3.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("BenelliM3.Single")
SWEP.Primary.RPM = 77
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.45
SWEP.Primary.NumShots = 8
SWEP.Primary.Damage = 11
SWEP.Primary.Spread = 0.084
SWEP.Primary.IronAccuracy = 0.074
SWEP.SightsPos = Vector(2.279, -1.007, 1.302)
SWEP.SightsAng = Vector(0.47, -0.04, 0)
SWEP.RunSightsPos = Vector(-10.639, -9.796, 0.865)
SWEP.RunSightsAng = Vector(-17.362, -69.724, 0)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end