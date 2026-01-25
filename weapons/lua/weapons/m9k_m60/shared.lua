SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "M60"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 50
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m60machinegun.mdl"
SWEP.WorldModel = Model("models/weapons/w_m60_machine_gun.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_M_60.Single")
SWEP.Primary.RPM = 575
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.KickUp	= 0.7
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 27
SWEP.Primary.Spread = 0.04
SWEP.Primary.IronAccuracy = 0.03
SWEP.SightsPos = Vector(-5.851, -2.763, 3.141)
SWEP.SightsAng = Vector(0, 0.06, 0)
SWEP.RunSightsPos = Vector(8.689, -3.444, -0.82)
SWEP.RunSightsAng = Vector(0, 44.18, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end