SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Attack.\nSecondary Fire: Heavy attack.\nReload to Throw."
SWEP.PrintName = "Knife"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.Weight	= 10
SWEP.HoldType = "knife"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/khrcw2/doipack/kabar.mdl"
SWEP.WorldModel = Model("models/khrcw2/doipack/w_kabar.mdl")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DeployDelay = 0.75
SWEP.RunHoldType = "knife"
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-8, 0, 0)

SWEP.Primary.Damage = 25
SWEP.Secondary.Damage = 45
SWEP.ThrowDamage = 60

SWEP.Primary.RPM = 150
SWEP.Secondary.RPM = 75

SWEP.SwingSound1 = "Knife.Swing"
SWEP.HitSound1 = "Knife.HitWorld"
SWEP.FleshSound1 = "Knife.HitFlesh"

SWEP.SwingSound2 = SWEP.SwingSound1
SWEP.HitSound2 = SWEP.HitSound1
SWEP.FleshSound2 = SWEP.FleshSound1

SWEP.ThrowSound = "Knife.Swing"

SWEP.DamageType = DMG_SLASH

SWEP.HitRange1 = 45
SWEP.HitRange2 = 40

SWEP.AttackTime1 = 0.07
SWEP.AttackTime2 = 0.16

SWEP.ViewPunchThrow = Angle(-3, 0, 0)

SWEP.TraceHull1 = {Vector(-6, -6, -4), Vector(6, 6, 4)}
SWEP.TraceHull2 = SWEP.TraceHull1

SWEP.Throwable = true
SWEP.PrimaryAttackThrow = false
SWEP.SecondaryAttackThrow = false
SWEP.EffectsOnThrow = true
SWEP.ThrowTime = 0.2

SWEP.Bleed = true

SWEP.PhysicsForce1 = 100
SWEP.MaxPhysicsForce1 = 250

SWEP.PhysicsForce2 = SWEP.PhysicsForce1
SWEP.MaxPhysicsForce2 = SWEP.MaxPhysicsForce1

SWEP.PrimaryAnimations = {"hitcenter1"}
SWEP.SecondaryAnimations = {"hitcenter2"}
SWEP.ThrowAnimations = {"hitcenter2"}

SWEP.DrawSound = "Knife.Draw"

SWEP.WeaponType = "melee_sharp"

function SWEP:CreateThrownWeapon()
	if !SERVER then return end
	local owner = self:GetOwner()
	local knife = ents.Create("m9k_thrown_knife")
	if !IsValid(knife) then return end
	knife:SetPos(owner:GetShootPos())
	knife:SetAngles(owner:EyeAngles())
	knife:SetPhysicsAttacker(owner)
	knife:SetOwner(owner)
	knife.Owner = owner
	knife:Spawn()
	knife:Activate()
	knife.Damage = self.ThrowDamage
	local phys = knife:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(owner:EyeAngles():Forward() * 1500)
		phys:AddAngleVelocity(Vector(0, 500, 0))
	end
	MG_RemoveWeapon(self, owner)
end

function SWEP:DrawWorldModel()
	local owner = self:GetOwner()

	local hand, offset, rotate

	if !IsValid(owner) then
		self:DrawModel()
		return
	end

	hand = owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if !hand then return end
	local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
	local m = owner:GetBoneMatrix(hand)
	if m then
		pos, ang = m:GetTranslation(), m:GetAngles()
	end

	pos = pos + (ang:Right() * 1 + ang:Forward() * 4 + ang:Up() * -3)

	ang:RotateAroundAxis(ang:Right(), 120)
	ang:RotateAroundAxis(ang:Forward(), 0)
	ang:RotateAroundAxis(ang:Up(), 0)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)

	self:SetupBones()
	self:DrawModel()
end