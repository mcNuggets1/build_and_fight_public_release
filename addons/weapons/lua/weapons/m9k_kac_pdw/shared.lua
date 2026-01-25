SWEP.Category = "M9K Submachine Guns"
SWEP.PrintName = "KAC PDW"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_kac_pdw1.mdl"
SWEP.WorldModel = Model("models/weapons/w_kac_pdw.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.Primary.Sound = Sound("KAC_PDW.Single")
SWEP.Primary.Sound_Silenced = Sound("KAC_PDW.SilentSingle")
SWEP.Primary.RPM = 700
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.45
SWEP.Primary.KickHorizontal = 0.25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.CanSilence = true
SWEP.CanSelectFire = true
SWEP.Secondary.SightsFOV = 55
SWEP.Primary.Damage = 23
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.013
SWEP.SightsPos = Vector(3.337, 0, 0.759)
SWEP.SightsAng = Vector(2.46, -0.055, 0)
SWEP.RunSightsPos = Vector(-4.646, -4.173, 0)
SWEP.RunSightsAng = Vector(-10.197, -53.189, 0)
SWEP.WeaponType = "smg"

SWEP.WElements = {
	["eotech"] = {type = "Model", model = "models/wystan/attachments/eotech557sight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7.539, 1.485, 10.295), angle = Angle(-172.297, 180, 0), size = Vector(1.378, 1.378, 1.378), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}
SWEP.VElements = {
	["eotech"] = {type = "Model", model = "models/wystan/attachments/eotech557sight.mdl", bone = "DrawCall_0", rel = "", pos = Vector(-0.281, 10.85, -6.398), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}
SWEP.ViewModelBoneMods = {
	["DrawCall_0009"] = {scale = Vector(1, 1, 1), pos = Vector(-0.4, 0, 0), angle = Angle(0, 0, 0)}
}

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end