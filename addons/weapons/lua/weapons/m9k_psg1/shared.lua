SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "PSG-1"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_psg1_snipe.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_psg1.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_psg_1.Single")
SWEP.Primary.RPM = 500
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 1.2
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 9	
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 42
SWEP.Primary.Spread = 0.043
SWEP.Primary.IronAccuracy = 0.005
SWEP.SightsPos = Vector(5.2, 0, 1.16)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-1.3095, -3.0514, -0.05)
SWEP.RunSightsAng = Vector(-19.8471, -33.9181, 10)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end