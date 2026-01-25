SWEP.Category = "M9K Pistols"
SWEP.PrintName = "HK USP"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pist_fokkususp.mdl"
SWEP.WorldModel = Model("models/weapons/w_pist_fokkususp.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_fokkususp.Single")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.KickUp = 0.65
SWEP.Primary.KickHorizontal = 0.4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 29
SWEP.Primary.Spread = 0.025
SWEP.Primary.IronAccuracy = 0.012
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(-2.5944, 0, 1.1433)
SWEP.SightsAng = Vector(0.2, 0.06, 0)
SWEP.RunSightsPos = Vector(3.444, -7.823, -6.27)
SWEP.RunSightsAng = Vector(60.695, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end