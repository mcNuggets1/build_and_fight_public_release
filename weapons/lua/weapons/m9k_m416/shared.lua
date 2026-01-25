SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "HK 416"
SWEP.Slot = 2	
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"	
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_hk416rif.mdl"
SWEP.WorldModel = Model("models/weapons/w_hk_416.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("hk416weapon.UnsilSingle")
SWEP.Primary.Sound_Silenced = Sound("hk416weapon.SilencedSingle")
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.55
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.CanSilence = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.029
SWEP.Primary.IronAccuracy = 0.0093
SWEP.SightsPos = Vector(-2.892, -2.132, 0.5)
SWEP.SightsAng = Vector(-0.21, 0.05, 0)
SWEP.RunSightsPos = Vector(3, -1, 1.496)
SWEP.RunSightsAng = Vector(-18.08, 40, 0)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end