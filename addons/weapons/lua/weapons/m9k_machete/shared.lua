SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Attack.\nSecondary Fire: Throw."
SWEP.PrintName = "Machete"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.Weight = 10
SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/khrcw2/owo/v_me_machete.mdl"
SWEP.WorldModel = Model("models/weapons/tfa_nmrih/w_me_machete.mdl")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.RunHoldType = "melee"
SWEP.DeployDelay = 0.85
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-10, 0, 0)

SWEP.Primary.Damage = 50

SWEP.ThrowDamage = 100

SWEP.Primary.RPM = 85

SWEP.SwingSound1 = "Machete.Swing"
SWEP.HitSound1 = "Machete.HitWorld"
SWEP.FleshSound1 = "Machete.HitFlesh"

SWEP.ThrowSound = SWEP.SwingSound1

SWEP.HitRange1 = 60

SWEP.AttackTime1 = 0.28

SWEP.ViewPunch1 = nil
SWEP.ViewPunchThrow = Angle(-8, 0, 0)

SWEP.TraceHull1 = {Vector(-8, -8, -6), Vector(8, 8, 6)}
SWEP.TraceHull2 = SWEP.TraceHull1

SWEP.Throwable = true
SWEP.PrimaryAttackThrow = false
SWEP.SecondaryAttackThrow = true
SWEP.EffectsOnThrow = true
SWEP.ThrowTime = 1.2

SWEP.Bleed = true

SWEP.PhysicsForce1 = 150

SWEP.PrimaryAnimations = {"Attack_Quick"}
SWEP.ThrowAnimations = {"Attack_Charge_Begin"}

SWEP.DrawSound = "Machete.Draw"

SWEP.WeaponType = "melee_sharp"

function SWEP:CreateThrownWeapon()
	if !SERVER then return end
	local owner = self:GetOwner()
	local mach = ents.Create("m9k_thrown_machete")
	if !IsValid(mach) then return end
	mach:SetAngles(owner:EyeAngles())
	mach:SetPos(owner:GetShootPos())
	mach:SetPhysicsAttacker(owner)
	mach:SetOwner(owner)
	mach.Owner = owner
	mach:Spawn()
	mach:Activate()
	mach.Damage = self.ThrowDamage
	local phys = mach:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(owner:GetForward() * 1500)
		phys:AddAngleVelocity(Vector(0, 500, 0))
	end
	MG_RemoveWeapon(self)
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

	pos = pos + (ang:Right() * 0.6 + ang:Forward() * 3.5 + ang:Up() * -11)

	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Forward(), 180)
	ang:RotateAroundAxis(ang:Up(), 0)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)

	self:SetupBones()
	self:DrawModel()
end