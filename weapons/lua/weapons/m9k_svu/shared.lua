SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Dragunov SVU"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_sniper_svu.mdl"
SWEP.WorldModel = Model("models/weapons/w_dragunov_svu.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_SVU.Single")
SWEP.Primary.RPM = 350
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 1
SWEP.Primary.KickHorizontal = 0.75
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 9
SWEP.Secondary.UseSVD = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 54
SWEP.Primary.Spread = 0.056
SWEP.Primary.IronAccuracy = 0.0007
SWEP.SightsPos = Vector(-3.24, 0, 0.88)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5, -4, -0.5)
SWEP.RunSightsAng = Vector(-5, 55, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end