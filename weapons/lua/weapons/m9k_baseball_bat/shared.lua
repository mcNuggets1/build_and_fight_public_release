SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Attack.\nSecondary Fire: Heavy attack."
SWEP.PrintName = "Baseball Bat"
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.Weight = 10
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/tfa_nmrih/v_me_bat_metal.mdl"
SWEP.WorldModel = Model("models/weapons/tfa_nmrih/w_me_bat_metal.mdl")
SWEP.Base = "mg_melee_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DeployDelay = 0.92
SWEP.RunHoldType = "melee2"
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-10, 0, 0)

SWEP.Primary.Damage = 40
SWEP.Secondary.Damage = 50

SWEP.Primary.RPM = 65
SWEP.Secondary.RPM = 54

SWEP.SwingSound1 = "BaseballBat.Swing"
SWEP.HitSound1 = "BaseballBat.HitWorld"
SWEP.FleshSound1 = "BaseballBat.HitFlesh"

SWEP.SwingSound2 = SWEP.SwingSound1
SWEP.HitSound2 = SWEP.HitSound1
SWEP.FleshSound2 = SWEP.FleshSound1

SWEP.DamageType = DMG_CLUB

SWEP.HitRange1 = 60
SWEP.HitRange2 = 50

SWEP.AttackTime1 = 0.3
SWEP.AttackTime2 = 0.26

SWEP.ViewPunch1 = nil

SWEP.TraceHull1 = {Vector(-8, -8, -6), Vector(8, 8, 6)}
SWEP.TraceHull2 = SWEP.TraceHull1

SWEP.Throwable = false

SWEP.NoImpactDecal = true
SWEP.Bleed = false

SWEP.PhysicsForce1 = 150

SWEP.PrimaryAnimations = {"Attack_Quick"}
SWEP.SecondaryAnimations = {"Shove"}

SWEP.DrawSound = "BaseballBat.Draw"

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

	pos = pos + (ang:Right() * 1 + ang:Forward() * 3 + ang:Up() * -1)

	ang:RotateAroundAxis(ang:Right(), 0)
	ang:RotateAroundAxis(ang:Forward(), 180)
	ang:RotateAroundAxis(ang:Up(), 0)

	self:SetRenderOrigin(pos)
	self:SetRenderAngles(ang)

	self:SetupBones()
	self:DrawModel()
end