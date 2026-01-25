SWEP.Category = "M9K Sniper Rifles"
SWEP.PrintName = "SVT 40"
SWEP.DrawCrosshair = false
SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.Weight = 50
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_snip_svt40.mdl"
SWEP.WorldModel = Model("models/weapons/w_svt_40.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_SVT40.single")
SWEP.Primary.RPM = 60
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.KickUp = 4
SWEP.Primary.KickHorizontal = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SniperPenetratedRound"
SWEP.Secondary.ScopeZoom = 5
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 0.7
SWEP.ReticleScale = 0.6
SWEP.Primary.Damage = 90
SWEP.Primary.Spread	= 0.043
SWEP.Primary.IronAccuracy = 0.001
SWEP.SightsPos = Vector(-3.462, -1.775, 0.079)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(3.388, -4.501, 0)
SWEP.RunSightsAng = Vector(-9.096, 47.727, 0)
SWEP.WeaponType = "sniper"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end