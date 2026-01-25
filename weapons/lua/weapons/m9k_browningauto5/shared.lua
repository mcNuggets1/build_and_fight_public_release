SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Browning Auto 5"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_brown_auto5.mdl"
SWEP.WorldModel = Model("models/weapons/w_browning_auto.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_a5.Single")
SWEP.Primary.RPM = 260
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp	= 1.8
SWEP.Primary.KickHorizontal	= 1.2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Secondary.SightsFOV = 60
SWEP.ShellTime = 0.35
SWEP.Primary.NumShots = 12
SWEP.Primary.Damage	= 5.2
SWEP.Primary.Spread	= 0.11
SWEP.Primary.IronAccuracy = 0.1
SWEP.SightsPos = Vector(1.953, 0, 1.388)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-5, -3, 0.492)
SWEP.RunSightsAng = Vector(-19.894, -47.624, 10.902)
SWEP.WeaponType = "shotgun"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end