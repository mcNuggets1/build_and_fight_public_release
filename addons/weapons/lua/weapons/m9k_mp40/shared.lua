SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "MP40"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_mp40smg.mdl"
SWEP.WorldModel = Model("models/weapons/w_mp40smg.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("mp40.Single")
SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.KickUp = 0.65
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.016
SWEP.SightsPos = Vector(3.881, 0.187, 1.626)
SWEP.SightsAng = Vector(-0.09, -0.025, 0)
SWEP.RunSightsPos = Vector(-9, -4.173, 0.865)
SWEP.RunSightsAng = Vector(-9.094, -56.496, 0)
SWEP.LoweredAng = Vector(-10, 0, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end