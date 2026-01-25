SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "M1918 BAR"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight	= 50
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_m1918bar.mdl"
SWEP.WorldModel	= Model("models/weapons/w_m1918_bar.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_bar1.Single")
SWEP.Primary.RPM = 450
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp	= 0.8
SWEP.Primary.KickHorizontal	= 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 38
SWEP.Primary.Spread = 0.029
SWEP.Primary.IronAccuracy = 0.019
SWEP.SightsPos = Vector(3.313, 0, 1.399)
SWEP.SightsAng = Vector(0, -0.03, 0)
SWEP.RunSightsPos = Vector(-7.049, -8.525, -2.132)
SWEP.RunSightsAng = Vector(0, -58.526, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end