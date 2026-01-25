SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Attack.\nSecondary Fire: Short attack."
SWEP.PrintName = "Sledgehammer"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.Weight = 10
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_sledge.mdl"
SWEP.WorldModel = Model("models/weapons/tfa_nmrih/w_me_sledge.mdl")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.RunHoldType = "melee2"
SWEP.DeployDelay = 0.9
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-8, 0, 0)

SWEP.Primary.Damage = 80
SWEP.Secondary.Damage = 55

SWEP.Primary.RPM = 40
SWEP.Secondary.RPM = 55

SWEP.SwingSound1 = "Sledgehammer.Swing"
SWEP.HitSound1 = "Sledgehammer.HitWorld"
SWEP.FleshSound1 = "Sledgehammer.HitFlesh"

SWEP.SwingSound2 = SWEP.SwingSound1
SWEP.HitSound2 = SWEP.HitSound1
SWEP.FleshSound2 = SWEP.FleshSound1

SWEP.DamageType = DMG_CLUB

SWEP.HitRange1 = 65
SWEP.HitRange2 = 50

SWEP.AttackTime1 = 0.4
SWEP.AttackTime2 = 0.25

SWEP.TraceHull1 = {Vector(-10, -10, -8), Vector(10, 10, 8)}
SWEP.TraceHull2 = SWEP.TraceHull1

SWEP.Throwable = false

SWEP.NoImpactDecal = true
SWEP.Bleed = false

SWEP.PhysicsForce1 = 200

SWEP.PrimaryAnimations = {"Attack_Quick"}
SWEP.SecondaryAnimations = {"Shove"}

SWEP.DrawSound = "Sledgehammer.Draw"

SWEP.WeaponType = "melee_dull"

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

	pos = pos + (ang:Right() * 1 + ang:Forward() * 3.5 + ang:Up() * -1)

	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Forward(), 180)
	ang:RotateAroundAxis(ang:Up(), 0)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)

	self:SetupBones()
	self:DrawModel()
end