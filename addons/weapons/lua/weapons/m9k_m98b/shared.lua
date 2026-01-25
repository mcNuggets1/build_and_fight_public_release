SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Barret M98B"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m98bravo.mdl"
SWEP.WorldModel = Model("models/weapons/w_barrett_m98b.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.BoltAction = true
SWEP.Primary.Sound = Sound("M98.Single")
SWEP.Primary.RPM = 50
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 2.4
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 9
SWEP.Secondary.UseParabolic = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage	= 76
SWEP.Primary.Spread	= 0.042
SWEP.Primary.IronAccuracy = 0.0002
SWEP.DeployDelay = 0.76
SWEP.SightsPos = Vector(-2.196, -2, 1)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(3.714, -2.714, -0.4)
SWEP.RunSightsAng = Vector(-7, 43, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end