SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "Steyr AUG"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/2_rif_aug.mdl"
SWEP.WorldModel = Model("models/weapons/3_rif_aug.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_AUG.1")
SWEP.Primary.RPM = 725
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.45
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.ScopeZoom = 5
SWEP.Secondary.UseACOG = true
SWEP.ScopeScale = 0.7
SWEP.Primary.Damage = 27
SWEP.Primary.Spread = 0.03
SWEP.Primary.IronAccuracy = 0.008
SWEP.SightsPos = Vector(2.839, 0, 0.56)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-6, -1.81, -0.5)
SWEP.RunSightsAng = Vector(-5.628, -70, 0.703)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end