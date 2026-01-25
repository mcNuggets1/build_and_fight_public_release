SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "G3SG1"
SWEP.DrawCrosshair = false
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_snip_g3sg1.mdl"
SWEP.WorldModel = Model("models/weapons/3_snip_g3sg1.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_G3SG1.1")
SWEP.Primary.RPM = 300
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp = 0.9
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.ScopeZoom = 8
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.Primary.Damage = 48
SWEP.Primary.Spread = 0.048
SWEP.Primary.IronAccuracy = 0.0033
SWEP.SightsPos = Vector(3.319, 0, 1.159)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-5.277, -5.592, 1.338)
SWEP.RunSightsAng = Vector(-15.157, -57.048, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end