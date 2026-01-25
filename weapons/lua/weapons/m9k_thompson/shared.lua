SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "Tommy Gun"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_tommy_g.mdl"
SWEP.WorldModel = Model("models/weapons/w_tommy_gun.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_tmg.Single")
SWEP.Primary.RPM = 625
SWEP.Primary.ClipSize = 75
SWEP.Primary.DefaultClip = 75
SWEP.Primary.KickUp = 0.65
SWEP.Primary.KickHorizontal = 0.45
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage = 26
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.014
SWEP.SightsPos = Vector(3.359, 0, 1.84)
SWEP.SightsAng = Vector(-1.9, -4.03, 0)
SWEP.RunSightsPos = Vector(-8.3095, -7.0514, 0)
SWEP.RunSightsAng = Vector(-15.8471, -65.9181, 10)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end