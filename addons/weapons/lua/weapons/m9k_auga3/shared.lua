SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "Steyr AUG A3"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_auga3sa.mdl"
SWEP.WorldModel	= Model("models/weapons/w_auga3.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("aug_a3.Single")
SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.5
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.ScopeZoom = 4
SWEP.Secondary.UseAimpoint = true
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 28
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.009
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(2.275, -2.9708, 0.5303)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-3.0328, 0, 1.888)
SWEP.RunSightsAng = Vector(-24.2146, -36.522, 10)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end