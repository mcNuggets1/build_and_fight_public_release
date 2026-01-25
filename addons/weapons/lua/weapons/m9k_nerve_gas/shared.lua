SWEP.Category = "M9K Specialties"
SWEP.PrintName = "Nerve Gas"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Weight = 10
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_invisible_nade.mdl"
SWEP.WorldModel = Model("models/weapons/w_grenade.mdl")
SWEP.ShowWorldModel = false
SWEP.Base = "mg_nade_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("")
SWEP.Primary.RPM = 30
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Round = "m9k_nervegasnade"
SWEP.WeaponType = "grenade"
 
SWEP.ViewModelBoneMods = {
	["v_weapon.Left_Hand"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.3, 2.382, 5.651)},
	["v_weapon.Root16"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-2.968, 0, 0)},
	["v_weapon.Left_Thumb01"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10.123, 10.102, 0)},
	["v_weapon.Left_Thumb03"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(2.601, 7.284, 40.835)},
	["v_weapon.Right_Thumb01"] = {scale = Vector(1, 1, 1), pos = Vector(-0.362, 0, 0), angle = Angle(0.465, 15.345, 9.413)},
	["v_weapon.Root17"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.174, 19.604, 3.446)}
}
SWEP.VElements = {
	["nerve"] = {type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.Flashbang_Parent", rel = "", pos = Vector(-0.076, 0.24, 0.063), angle = Angle(-17.351, -8.782, -99.302), size = Vector(0.54, 0.54, 0.54), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/gv/nerve_vial.vmt", skin = 0, bodygroup = {}}
}
SWEP.WElements = {
	["nerveagent"] = {type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.22, 2.107, -4.025), angle = Angle(0, 0, 0), size = Vector(0.865, 0.865, 0.865), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/gv/nerve_vial.vmt", skin = 0, bodygroup = {}}
}

hook.Add("EntityTakeDamage", "M9K_PoisonChildChecker", function(victim, info)
	local inflictor = info:GetInflictor()
	if !IsValid(victim) or !IsValid(info:GetAttacker()) or !IsValid(inflictor) then return end
	if inflictor:GetClass() == "POINT_HURT" then
		local parent = inflictor:GetParent()
		if IsValid(parent) then
			if (parent:GetClass() == "m9k_poison_parent") then
				if IsValid(parent:GetOwner()) then
					info:SetAttacker(parent:GetOwner())
					info:SetInflictor(parent)
				end
			end
		end
	end
end)