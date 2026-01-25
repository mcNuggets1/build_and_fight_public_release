SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Remington 1858"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_pist_re1858.mdl"
SWEP.WorldModel = Model("models/weapons/w_remington_1858.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Remington.single")
SWEP.Primary.RPM = 185
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp = 1.4
SWEP.Primary.KickHorizontal = 0.8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 46
SWEP.Primary.Spread = 0.025
SWEP.Primary.IronAccuracy = 0.011
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(5.44, 0, 0)
SWEP.SightsAng = Vector(0, -0.03, 0)
SWEP.RunSightsPos = Vector(-0.165, -13, -5.41)
SWEP.RunSightsAng = Vector(70, 0, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end