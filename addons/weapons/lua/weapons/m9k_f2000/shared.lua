SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "F2000"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_tct_f2000.mdl"
SWEP.WorldModel	= Model("models/weapons/w_fn_f2000.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_F2000.Single")
SWEP.Primary.RPM = 850
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp	= 0.75
SWEP.Primary.KickHorizontal	= 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.ScopeZoom = 4
SWEP.Secondary.UseACOG = true
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage	= 24
SWEP.Primary.Spread	= 0.035
SWEP.Primary.IronAccuracy = 0.01
SWEP.DeployDelay = 0.95
SWEP.SightsPos = Vector(3.499, 0, 1.08)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-7.705, -2.623, 1.475)
SWEP.RunSightsAng = Vector(-11.476, -55.083, -2.296)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end