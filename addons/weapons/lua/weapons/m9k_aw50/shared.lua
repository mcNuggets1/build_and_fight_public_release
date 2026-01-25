SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "AI AW50"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_aw50_awp.mdl"
SWEP.WorldModel = Model("models/weapons/w_acc_int_aw50.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weaponaw50.Single")
SWEP.Primary.RPM = 50
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 3.5
SWEP.Primary.KickHorizontal	= 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 9
SWEP.Secondary.UseParabolic = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 84
SWEP.Primary.Spread	= 0.04
SWEP.Primary.IronAccuracy = 0.0001
SWEP.DeployDelay = 0.84
SWEP.BoltAction = true
SWEP.SightsPos = Vector(3.68, 0, 1.08)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-5.3095, -2.0514, 1)
SWEP.RunSightsAng = Vector(-19.8471, -33.9181, 10)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end