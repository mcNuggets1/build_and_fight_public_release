SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Sticky Grenade"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Weight = 10	
SWEP.DrawCrosshair = false
SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_sticky_grenade.mdl"
SWEP.WorldModel = Model("models/weapons/w_sticky_grenade.mdl")
SWEP.ShowWorldModel = false
SWEP.Base = "mg_nade_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "sticky_nade"
SWEP.Primary.Round = "m9k_thrown_sticky_grenade"
SWEP.DetonateTime = 6
SWEP.Explode = true
SWEP.WeaponType = "grenade"

SWEP.ViewModelBoneMods = {
	["v_weapon.Flashbang_Parent"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.391), angle = Angle(0, 0, 0)},
	["v_weapon.Root17"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.864, 11.555, 0)}
}
SWEP.WElements = {
	["Mr_Blue"] = {type = "Model", model = "models/weapons/w_sticky_grenade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.322, 2.828, -1.349), angle = Angle(180, -3.81, 5.743), size = Vector(1.376, 1.376, 1.376), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}