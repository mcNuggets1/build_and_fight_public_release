SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "HK MP7"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_mp7_silenced.mdl"
SWEP.WorldModel = Model("models/weapons/w_mp7_silenced.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_MP7.single")
SWEP.Primary.RPM = 950
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.55
SWEP.Primary.KickHorizontal = 0.35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSelectFire = true
SWEP.Secondary.ScopeZoom = 4
SWEP.Secondary.UseAimpoint = true
SWEP.ScopeScale = 0.7
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = 0.035
SWEP.Primary.IronAccuracy = 0.018
SWEP.SightsPos = Vector(3, -5, 1.5)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-3.1731, -2.3573, 1.7608)
SWEP.RunSightsAng = Vector(-18.7139, -28.1596, 0)
SWEP.WeaponType = "smg"

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end