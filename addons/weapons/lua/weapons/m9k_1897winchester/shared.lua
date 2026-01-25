SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Winchester 1897"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_1897trenchshot.mdl"
SWEP.WorldModel	= Model("models/weapons/w_winchester_1897_trench.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Trench_97.Single")
SWEP.Primary.RPM = 70
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.KickUp = 1.8
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.55
SWEP.Primary.NumShots = 12
SWEP.Primary.Damage = 9
SWEP.Primary.Spread	= 0.09
SWEP.Primary.IronAccuracy = 0.08
SWEP.SightsPos = Vector(2.809, 0, 1.48)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-5.116, -3.935, 0.492)
SWEP.RunSightsAng = Vector(-19.894, -47.624, 10.902)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end