SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "FN P90"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_p90_smg.mdl"
SWEP.WorldModel = Model("models/weapons/w_fn_p90.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("P90_weapon.single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.KickUp = 0.55
SWEP.Primary.KickHorizontal = 0.45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 21
SWEP.Primary.Spread = 0.034
SWEP.Primary.IronAccuracy = 0.018
SWEP.SightsPos = Vector(2.707, -2.46, 2.219)
SWEP.SightsAng = Vector(-0.1, 0, 0)
SWEP.RunSightsPos = Vector(-2.3095, -3.0514, 2.3965)
SWEP.RunSightsAng = Vector(-19.8471, -33.9181, 10)
SWEP.LoweredAng = Vector(-10, 0, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end