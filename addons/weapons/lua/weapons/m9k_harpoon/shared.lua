SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Throw."
SWEP.PrintName = "Harpoon"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Weight = 1
SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = Model("models/weapons/w_harpooner.mdl")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Round = "m9k_thrown_harpoon"
SWEP.DeployDelay = 0.8
SWEP.DeploySpeed = 0.75
SWEP.CanRun = false

SWEP.Primary.Damage = 125

SWEP.Primary.RPM = 50

SWEP.ThrowSound = Sound("weapons/blades/woosh.mp3")

SWEP.ViewPunchThrow = Angle(-10, 0, 0)

SWEP.Throwable = true
SWEP.PrimaryAttackThrow = true
SWEP.SecondaryAttackThrow = false
SWEP.EffectsOnThrow = true
SWEP.ThrowTime = 0.1

SWEP.Bleed = true

SWEP.CanAim = true

SWEP.WeaponType = "melee_sharp"

SWEP.VElements = {
	["harpoon"] = {type = "Model", model = Model("models/props_junk/harpoon002a.mdl"), bone = "v_weapon.knife_Parent", rel = "", pos = Vector(6.3, -6.481, -5.825), angle = Angle(128.731, -17.442, -142.782), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}
SWEP.ViewModelBoneMods = {
	["v_weapon.Knife_Handle"] = {scale = Vector(1, 1, 1), pos = Vector(-30, 30, -30), angle = Angle(0, 0, 0)},
	["v_weapon.Right_Arm"] = {scale = Vector(1, 1, 1), pos = Vector(-30, 30, 30), angle = Angle(0, 0, 0)}
}

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CreateThrownWeapon()
	if !SERVER then return end
	local owner = self:GetOwner()
	local aim = owner:GetAimVector()
	local pos = owner:GetShootPos()
	local harp = ents.Create(self.Primary.Round)
	if !IsValid(harp) then return end
	harp:SetAngles(aim:Angle())
	harp:SetPos(pos + owner:GetForward() * -50)
	harp:SetPhysicsAttacker(owner)
	harp:SetOwner(owner)
	harp.Owner = owner
	harp:Spawn()
	harp:Activate()
	harp.Damage = self.Primary.Damage
	local phys = harp:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(aim * 2000)
	end
	MG_RemoveWeapon(self, owner)
end