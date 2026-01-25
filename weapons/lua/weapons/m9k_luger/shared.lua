SWEP.Category = "M9K Pistols"
SWEP.PrintName = "P08 Luger"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_p08_luger.mdl"
SWEP.WorldModel = Model("models/weapons/w_luger_p08.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("weapon_luger.single")
SWEP.Primary.RPM = 825
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.KickUp = 0.8
SWEP.Primary.KickHorizontal = 0.5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.SightsFOV = 55	
SWEP.Primary.Damage = 32
SWEP.Primary.Spread = 0.021
SWEP.Primary.IronAccuracy = 0.011
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(2.71, -2.122, 2.27)
SWEP.SightsAng = Vector(0.36, -0.03, 0)
SWEP.RunSightsPos = Vector(0, 0.45, 0)
SWEP.RunSightsAng = Vector(-10.657, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end