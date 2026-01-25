SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Thompson Contender G2"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight	= 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_contender2.mdl"
SWEP.WorldModel = Model("models/weapons/w_g2_contender.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("contender_g2.Single")
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.KickUp = 3
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Primary.RPM = 40
SWEP.BoltAction = true
SWEP.Secondary.ScopeZoom = 9
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 75
SWEP.Primary.Spread = 0.035
SWEP.Primary.IronAccuracy = 0.001
SWEP.SightsPos = Vector(-3, -0.857, 0.36)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(3.714, -1.429, 0)
SWEP.RunSightsAng = Vector(-11, 31, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end