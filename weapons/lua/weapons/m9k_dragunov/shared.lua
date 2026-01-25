SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "SVD Dragunov"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_dragunov02.mdl"
SWEP.WorldModel	= Model("models/weapons/w_svd_dragunov.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_svd01.Single")
SWEP.Primary.RPM = 100
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 1.5
SWEP.Primary.KickHorizontal	= 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 9
SWEP.Secondary.UseSVD = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage	= 66
SWEP.Primary.Spread	= 0.068
SWEP.Primary.IronAccuracy = 0.0007
SWEP.DeployDelay = 0.78
SWEP.SightsPos = Vector(-1.241, -1.476, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(3.934, -1.41, 0)
SWEP.RunSightsAng = Vector(-11.476, 35, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end