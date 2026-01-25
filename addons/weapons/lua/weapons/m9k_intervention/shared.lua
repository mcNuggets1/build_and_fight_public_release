SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "Intervention"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_snip_int.mdl"
SWEP.WorldModel = Model("models/weapons/w_snip_int.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.BoltAction = true
SWEP.Primary.Sound = Sound("Weapon_INT.Single")
SWEP.Primary.RPM = 40
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickHorizontal = 1.4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 10
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.Primary.Damage = 80
SWEP.Primary.Spread	= 0.047
SWEP.Primary.IronAccuracy = 0.0003
SWEP.SightsPos = Vector(2.2263, -0.0007, 0.115)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-3, -2.0514, 0.3965)
SWEP.RunSightsAng = Vector(-22, -33.9181, 10)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end