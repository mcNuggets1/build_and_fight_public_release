SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Colt Python"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight	= 20
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_python.mdl"
SWEP.WorldModel = Model("models/weapons/w_colt_python.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_ColtPython.Single")
SWEP.Primary.RPM = 150
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp	= 1.4
SWEP.Primary.KickHorizontal	= 0.5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 48
SWEP.Primary.Spread	= 0.019
SWEP.Primary.IronAccuracy = 0.0087
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-2.75, -1.676, 1.796)
SWEP.SightsAng = Vector(0.55, 0.03, 0)
SWEP.RunSightsPos = Vector(2.124, -9.365, -3.987)
SWEP.RunSightsAng = Vector(48.262, -8.214, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end