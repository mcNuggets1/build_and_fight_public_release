SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Remington 7615P"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_remington_7615p.mdl"
SWEP.WorldModel = Model("models/weapons/w_remington_7615p.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.BoltAction = true
SWEP.Primary.Sound = Sound("7615p_remington.Single")
SWEP.Primary.RPM = 75
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 4
SWEP.Primary.KickHorizontal = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 7
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 78
SWEP.Primary.Spread = 0.057
SWEP.Primary.IronAccuracy = 0.0008
SWEP.SightsPos = Vector(3.079, -1.333, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-2.3095, -1.0514, -5)
SWEP.RunSightsAng = Vector(0, -33.9181, 10)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end