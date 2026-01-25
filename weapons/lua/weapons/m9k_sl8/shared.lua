SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "HK SL8"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 50
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_hk_sl8.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_sl8.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_hksl8.Single")
SWEP.Primary.RPM = 300
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 1
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.ScopeZoom = 4
SWEP.Secondary.UseACOG = true
SWEP.ScopeScale = 0.9
SWEP.ReticleScale = 0.7
SWEP.Primary.Damage = 36
SWEP.Primary.Spread = 0.034
SWEP.Primary.IronAccuracy = 0.011
SWEP.SightsPos = Vector(3.079, -1.333, 0.437)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-8.22, -7.277, 0)
SWEP.RunSightsAng = Vector(-10.671, -64.598, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end