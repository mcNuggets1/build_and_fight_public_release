SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "ACR"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_rif_msda.mdl"
SWEP.WorldModel = Model("models/weapons/w_masada_acr.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Masada.Single")
SWEP.Primary.RPM = 850
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp	= 0.5
SWEP.Primary.KickHorizontal	= 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Secondary.SightsFOV = 55	
SWEP.Primary.Damage = 25
SWEP.Primary.Spread	= 0.035
SWEP.Primary.IronAccuracy = 0.016
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(2.661, 0, 0.675)
SWEP.SightsAng = Vector(0, -0.03, 0)
SWEP.RunSightsPos = Vector(-3.0328, 0, 1.888)
SWEP.RunSightsAng = Vector(-24.2146, -36.522, 10)
SWEP.WeaponType = "assault"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end