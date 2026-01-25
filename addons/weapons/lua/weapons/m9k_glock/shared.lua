SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Glock 18"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight	= 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_dmg_glock.mdl"
SWEP.WorldModel = Model("models/weapons/w_dmg_glock.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.Primary.Sound = Sound("Dmgfok_glock.Single")
SWEP.Primary.RPM = 900
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 32
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal	= 0.4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 60
SWEP.Primary.Damage	= 18
SWEP.Primary.Spread	= 0.029
SWEP.Primary.IronAccuracy = 0.017
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(2.194, 0, 1.7661)
SWEP.SightsAng = Vector(0, -0.05, 0)
SWEP.RunSightsPos = Vector(-4, -8, -6)
SWEP.RunSightsAng = Vector(60, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end