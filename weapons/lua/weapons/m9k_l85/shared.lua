SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "L85"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_rif_l85.mdl"
SWEP.WorldModel = Model("models/weapons/w_l85a2.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_l85.Single")
SWEP.Primary.RPM = 675
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.65
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.ScopeZoom = 4	
SWEP.Secondary.UseACOG = true
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 31
SWEP.Primary.Spread = 0.036
SWEP.Primary.IronAccuracy = 0.01
SWEP.SightsPos = Vector(2.275, -2.9708, 0.5303)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-3.0328, 1, 1)
SWEP.RunSightsAng = Vector(-21.2146, -36.522, 10)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end