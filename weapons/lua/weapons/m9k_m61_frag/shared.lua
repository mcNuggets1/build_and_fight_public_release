SWEP.Category = "M9K Specialties"
SWEP.PrintName = "M61-Frag Grenade"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Weight = 10
SWEP.DrawCrosshair = false
SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_invisible_nade.mdl"
SWEP.WorldModel = Model("models/weapons/w_m61_fraggynade.mdl")
SWEP.ShowWorldModel = false
SWEP.Base = "mg_nade_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "m61_frag"	
SWEP.Primary.Round = "m9k_thrown_m61"
SWEP.DetonateTime = 5
SWEP.Explode = true
SWEP.WeaponType = "grenade"

SWEP.WElements = {
	["nade"] = {type = "Model", model = "models/weapons/w_m61_fraggynade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.611, 1.751, -2.003), angle = Angle(-143.148, 5.699, 0), size = Vector(1.348, 1.348, 1.348), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}
SWEP.VElements = {
	["m61"] = {type = "Model", model = "models/weapons/w_m61_fraggynade.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(0.194, -1.316, 0.54), angle = Angle(95.096, -12.285, 97.221), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.ViewModelBoneMods = {
	["v_weapon.Root16"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.293, 0, 0)},
	["v_weapon.Left_Thumb03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-9.509, 4.019, -0.26)},
	["v_weapon.Left_Thumb01"] = {scale = Vector(1, 1, 1), pos = Vector(-0.362, 0, 0), angle = Angle(0.465, 15.345, 9.413)},
	["v_weapon.Root17"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.423, 12.668, 1.228)}
}