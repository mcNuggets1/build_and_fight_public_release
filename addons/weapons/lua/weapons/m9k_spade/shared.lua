SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Attack.\nSecondary Fire: Heavy attack."
SWEP.PrintName = "Spade"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.Weight = 10
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/khrcw2/doipack/etoolus.mdl"
SWEP.WorldModel = Model("models/khrcw2/doipack/w_etoolus.mdl")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.RunHoldType = "melee2"
SWEP.DeployDelay = 0.95
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-12, 0, 0)

SWEP.Primary.Damage = 40
SWEP.Secondary.Damage = 55

SWEP.Primary.RPM = 100
SWEP.Secondary.RPM = 70

SWEP.SwingSound1 = "Spade.Swing"
SWEP.HitSound1 = "Spade.HitWorld"
SWEP.FleshSound1 = "Spade.HitFlesh"

SWEP.SwingSound2 = SWEP.SwingSound1
SWEP.HitSound2 = SWEP.HitSound1
SWEP.FleshSound2 = SWEP.FleshSound1

SWEP.DamageType = DMG_CLUB

SWEP.HitRange1 = 60
SWEP.HitRange2 = 50

SWEP.AttackTime1 = 0.2
SWEP.AttackTime2 = 0.4

SWEP.TraceHull1 = {Vector(-10, -10, -8), Vector(10, 10, 8)}
SWEP.TraceHull2 = SWEP.TraceHull1

SWEP.Throwable = false

SWEP.NoImpactDecal = true
SWEP.Bleed = false

SWEP.PhysicsForce1 = 150

SWEP.PrimaryAnimations = {"swing_left_miss"}
SWEP.SecondaryAnimations = {"base_attack_kill"}

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

	pos = pos + (ang:Right() * 1.5 + ang:Forward() * 3.5 + ang:Up() * -6)

	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Forward(), 160)
	ang:RotateAroundAxis(ang:Up(), 0)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)

	self:SetupBones()
	self:DrawModel()
end