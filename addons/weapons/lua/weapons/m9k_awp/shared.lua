SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "AWP"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_snip_awp.mdl"
SWEP.WorldModel = Model("models/weapons/3_snip_awp.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_AWP.1")
SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 3.2
SWEP.Primary.KickHorizontal = 1.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 9
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.Primary.Damage = 74
SWEP.Primary.Spread	= 0.045
SWEP.Primary.IronAccuracy = 0.0003
SWEP.BoltAction = true
SWEP.SightsPos = Vector(5.559, 0, 1.72)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-2.599, -8.11, -0.709)
SWEP.RunSightsAng = Vector(0, -62.559, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end