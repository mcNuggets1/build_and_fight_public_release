SWEP.Category = "M9K Pistols"
SWEP.PrintName = "Raging Bull"
SWEP.Slot = 1
SWEP.SlotPos = 5
SWEP.Weight = 20
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_raging_bull.mdl"
SWEP.WorldModel = Model("models/weapons/w_taurus_raging_bull.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("weapon_r_bull.single")
SWEP.Primary.RPM = 120
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6
SWEP.Primary.KickUp = 1.6
SWEP.Primary.KickHorizontal = 0.75
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Secondary.SightsFOV = 65
SWEP.Primary.Damage = 50
SWEP.Primary.Spread = 0.02
SWEP.Primary.IronAccuracy = 0.01
SWEP.RunHoldType = "normal"
SWEP.LoweredHoldType = "normal"
SWEP.SightsPos = Vector(2.773, 0, 0.846)
SWEP.SightsAng = Vector(-0.157, -0.02, 0)
SWEP.RunSightsPos = Vector(0, 2.95, 0)
SWEP.RunSightsAng = Vector(-13.197, 5.737, 0)
SWEP.WeaponType = "pistol"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end