SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Winchester 87"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_1887winchester.mdl"
SWEP.WorldModel	= Model("models/weapons/w_winchester_1887.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.Primary.Sound = Sound("1887winch.Single")
SWEP.Primary.RPM = 72
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.KickUp	= 2.8
SWEP.Primary.KickHorizontal	= 1.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.55
SWEP.Primary.NumShots = 10
SWEP.Primary.Damage	= 10
SWEP.Primary.Spread	= 0.095
SWEP.Primary.IronAccuracy = 0.085
SWEP.SightsPos = Vector(4.84, 0, 1.2)
SWEP.SightsAng = Vector(0, 0, 3.8)
SWEP.RunSightsPos = Vector(-2.3095, -3.0514, 1.3965)
SWEP.RunSightsAng = Vector(-19.8471, -33.9181, 10)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end