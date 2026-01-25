SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Nitro Glycerine"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Weight = 10
SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_invisible_nade.mdl"
SWEP.WorldModel = Model("models/weapons/w_nitro.mdl")
SWEP.Base = "mg_nade_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""	
SWEP.Primary.Round = "m9k_thrown_nitrox"
SWEP.PreThrowDuration = 0.63
SWEP.WeaponType = "grenade"

SWEP.VElements = {
	["bottle_o_boom"] = {type = "Model", model = "models/weapons/w_nitro.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(-4.538, -7.218, -14.072), angle = Angle(164.236, -6.253, 97.573), size = Vector(0.666, 0.666, 0.666), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}
SWEP.ViewModelBoneMods = {
	["v_weapon.Left_Middle01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 17.5, 0)},
	["v_weapon.Left_Ring01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 23.271, 0)},
	["v_weapon.Left_Index01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 25.108, 0)},
	["v_weapon.Left_Pinky01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 34.459, 0)}
}

function SWEP:OffsetGrenade(grenade)
	local owner = self.Owner
	local aim = owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	grenade:SetPos(owner:GetShootPos() + aim * -13 - side * 10)
	grenade:SetAngles(aim:Angle() + Angle(90, 0, 0))
	return false
end