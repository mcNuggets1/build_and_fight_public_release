SWEP.Category = "M9K Machine Guns"
SWEP.PrintName = "M249"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 50
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_machinegun249.mdl"
SWEP.WorldModel = Model("models/weapons/w_m249_machine_gun.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_249M.Single")
SWEP.Primary.RPM = 850
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "lmg"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage	= 22
SWEP.Primary.Spread	= 0.034
SWEP.Primary.IronAccuracy = 0.024
SWEP.SightsPos = Vector(-4.017, 0, 1.764)
SWEP.SightsAng = Vector(0.15, 0.01, 0)
SWEP.RunSightsPos = Vector(5.081, -4.755, -1.476)
SWEP.RunSightsAng = Vector(0, 41.884, 0)
SWEP.WeaponType = "mg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end