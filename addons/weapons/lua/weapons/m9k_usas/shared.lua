SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "USAS"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_usas12_shot.mdl"
SWEP.WorldModel = Model("models/weapons/w_usas_12.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_usas.Single")
SWEP.Primary.RPM = 240
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.KickUp	= 2
SWEP.Primary.KickHorizontal	= 1.2
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.NumShots = 10
SWEP.Primary.Damage = 4
SWEP.Primary.Spread = 0.105
SWEP.Primary.IronAccuracy = 0.095
SWEP.DeployDelay = 0.56
SWEP.SightsPos = Vector(4.519, -2.159, 1.039)
SWEP.SightsAng = Vector(0.072, 0.975, 0)
SWEP.RunSightsPos = Vector(-3.0328, 0, 1.888)
SWEP.RunSightsAng = Vector(-24.2146, -36.522, 10)
SWEP.SkipReload = true
SWEP.ReloadAmount = 20
SWEP.ShellTime = 1
SWEP.WeaponType = "shotgun"

SWEP.WElements = {
	["fix2"] = {type = "Model", model = "models/hunter/blocks/cube025x05x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(22.416, 2.073, -5.571), angle = Angle(0, 0, -90), size = Vector(0.899, 0.118, 0.1), color = Color(0, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["magfix"] = {type = "Model", model = "models/xqm/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.482, 1.389, 0.078), angle = Angle(-8.098, 0, 0), size = Vector(0.2, 0.589, 0.589), color = Color(0, 0, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end