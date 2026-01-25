SWEP.Base = "mg_gun_base"
SWEP.Weight	= 10

SWEP.CanAim = false
SWEP.CanLower = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Primary.Damage = 10
SWEP.Secondary.Damage = 20

SWEP.Primary.RPM = 150
SWEP.Secondary.RPM = 100

SWEP.SwingSound1 = ""
SWEP.HitSound1 = ""
SWEP.FleshSound1 = ""

SWEP.SwingSound2 = ""
SWEP.HitSound2 = ""
SWEP.FleshSound2 = ""

SWEP.ThrowSound = ""

SWEP.DamageType = DMG_SLASH

SWEP.HitRange1 = 42
SWEP.HitRange2 = 42

SWEP.AttackTime1 = 0.1
SWEP.AttackTime2 = 0.1

SWEP.ViewPunch1 = nil
SWEP.ViewPunch2 = nil
SWEP.ViewPunchThrow = Angle(-1, 0, 0)

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

SWEP.PrimaryAnimations = {}
SWEP.SecondaryAnimations = {}
SWEP.ThrowAnimations = {}

SWEP.AttackAnimations = {}

SWEP.HaltAnimation = false
SWEP.NoRunningCooldown = true
SWEP.CanAttackWhileAiming = true

SWEP.DrawSound = ""

SWEP.AnimationSync = 1

DEFINE_BASECLASS("mg_gun_base")

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Float", 4, "Attack1Time")
	self:NetworkVar("Float", 5, "Attack2Time")
	self:NetworkVar("Float", 6, "ThrowTime")
end

function SWEP:AddDeploy()
	self:SetAttack1Time(0)
	self:SetAttack2Time(0)
	self:SetThrowTime(0)

	self.AnimationSync = 1

	if self.DrawSound != "" then
		self:EmitSound(self.DrawSound)
	end
end

function SWEP:SelectAnimation(primary)
	if self.HaltAnimation then
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
	local owner = self:GetOwner()
	local anim_tbl = primary == 1 and self.ThrowAnimations or primary and self.PrimaryAnimations or self.SecondaryAnimations
	if anim_tbl and #anim_tbl > 0 then
		local vm = owner:GetViewModel()
		if vm:IsValid() then
			if #anim_tbl > 1 then
				if (self.AnimationSync <= 1) then
					vm:SendViewModelMatchingSequence(vm:LookupSequence(anim_tbl[1]))
					self.AnimationSync = 2
				else
					vm:SendViewModelMatchingSequence(vm:LookupSequence(anim_tbl[2]))
					self.AnimationSync = 1
				end
			else
				vm:SendViewModelMatchingSequence(vm:LookupSequence(anim_tbl[1]))
			end
		end
	elseif self.AttackAnimations and #self.AttackAnimations > 0 then
		self:SendWeaponAnim(self.AttackAnimations[primary == 1 and 0 and 1 or 2])
	end
end

function SWEP:Attack(primary)
	local owner = self:GetOwner()
	self:SelectAnimation(primary)
	self:EmitSound(!primary and self.SwingSound2 or self.SwingSound1)
	owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1 / ((primary and self.Primary.RPM or self.Secondary.RPM) / 60))
	self:SetNextSecondaryFire(CurTime() + 1 / ((primary and self.Primary.RPM or self.Secondary.RPM) / 60))
	local viewpunch = primary and self.ViewPunch1 or !primary and self.ViewPunch2
	if viewpunch then
		owner:ViewPunch(viewpunch)
	end
	if primary then
		self:SetAttack1Time(CurTime() + self.AttackTime1)
	else
		self:SetAttack2Time(CurTime() + self.AttackTime2)
	end
end

function SWEP:PrimaryAttack()
	if self.Throwable and self.PrimaryAttackThrow then
		if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() or self:GetDrawAnim() > CurTime()then return end
		self:ThrowWeapon()
	else
		if !self.CanAttackWhileAiming and (self:GetAiming() or self:GetPredictedAiming()) then return end
		self:Attack(true)
	end
end

function SWEP:SecondaryAttack()
	if self.Throwable and self.SecondaryAttackThrow then
		if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() or self:GetDrawAnim() > CurTime()then return end
		self:ThrowWeapon()
	else
		if !self.CanAttackWhileAiming and (self:GetAiming() or self:GetPredictedAiming()) then return end
		self:Attack(false)
	end
end

function SWEP:Reload()
	if !self.Throwable or self.SecondaryAttackThrow then return end
	if !self:GetOwner():KeyPressed(IN_RELOAD) then return end
	if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() or self:GetDrawAnim() > CurTime()then return end
	self:ThrowWeapon()
end

function SWEP:AttackTrace(primary, pos, ang, leng)
	local owner = self:GetOwner()
	pos = pos or owner:GetShootPos()
	ang = ang or owner:EyeAngles():Forward()
	local trace = util.TraceLine({
		start = pos,
		endpos = pos + (ang * (leng or (primary and self.HitRange1 or self.HitRange2))),
		filter = owner,
		mask = MASK_SHOT_HULL
	})
	local trace2
	if !IsValid(trace.Entity) and !trace.HitWorld then 
		trace2 = util.TraceHull({
			start = pos,
			endpos = pos + (ang * (leng or (primary and self.HitRange1 or self.HitRange2))),
			filter = owner,
			mins = self.TraceHull1[1],
			maxs = self.TraceHull1[2],
			mask = MASK_SHOT_HULL
		})
	end
	if trace2 and IsValid(trace2.Entity) and (trace2.Entity:IsPlayer() or trace2.Entity:IsNPC()) then
		trace = trace2
	end
	return trace
end

function SWEP:InflictDamage(primary)
	local owner = self:GetOwner()
	local damagedice = math.Rand(0.75, 1.25)
	local pain = (primary and self.Primary.Damage or self.Secondary.Damage) * damagedice
	owner:LagCompensation(true)
	local pos = owner:GetShootPos()
	local ang = owner:EyeAngles():Forward()
	local trace = self:AttackTrace(primary, pos, ang)
	owner:LagCompensation(false)
	if trace.Hit then
		local targ = trace.Entity
		if IsValid(targ) then
			local paininfo = DamageInfo()
			if targ:IsNPC() or targ:IsPlayer() or targ:IsRagdoll() then
				self:EmitSound(!primary and self.FleshSound2 or self.FleshSound1)
				paininfo:SetDamage(pain)
			else
				self:EmitSound(!primary and self.HitSound2 or self.HitSound1)
				paininfo:SetDamage(pain / 3)
			end
			paininfo:SetDamageForce(owner:EyeAngles():Forward() * (damagedice * 2500))
			paininfo:SetDamageType(self.DamageType)
			paininfo:SetDamagePosition(trace.HitPos)
			paininfo:SetAttacker(owner)
		 	paininfo:SetInflictor(self)
			if SERVER then
				local dest = pos + (ang * (primary and self.HitRange1 or self.HitRange2))
				targ:DispatchTraceAttack(paininfo, pos + (ang * 3), dest)
			end
			if IsFirstTimePredicted() then
				local mat_type = trace.MatType
				mat_type = mat_type == MAT_FLESH or mat_type == MAT_BLOODYFLESH or mat_type == MAT_ANTLION or mat_type == MAT_ALIENFLESH
				if self.Bleed and mat_type then
					local edata = EffectData()
					edata:SetOrigin(trace.HitPos)
					edata:SetNormal(trace.HitNormal)
					edata:SetColor(targ.GetBloodColor and targ:GetBloodColor() or 0)
					util.Effect(self.BloodImpact or "BloodImpact", edata)
				elseif !mat_type then
					local edata = EffectData()
					edata:SetStart(pos)
					edata:SetOrigin(trace.HitPos)
					edata:SetNormal(trace.Normal)
					edata:SetSurfaceProp(trace.SurfaceProps)
					edata:SetHitBox(trace.HitBox)
					edata:SetEntity(targ)
					util.Effect("Impact", edata)
				end
			end
		else
			if SERVER and !self.NoImpactDecal then
				util.Decal(self.ImpactDecal or "ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal, owner)
			end
			self:EmitSound(!primary and self.HitSound2 or self.HitSound1)
		end
		if IsValid(targ) then
	   	 	local phys = targ:GetPhysicsObject()
			if IsValid(phys) and phys:GetMass() < (primary and self.MaxPhysicsForce1 or self.MaxPhysicsForce2) then
		   		phys:ApplyForceOffset(ang * (primary and self.PhysicsForce1 or self.PhysicsForce2) * phys:GetMass(), trace.HitPos)
		   	end
		end
	end
end

function SWEP:ThrowWeapon()
	local owner = self:GetOwner()
	if !self.EffectsOnThrow then
		if self.ViewPunchThrow then
			owner:ViewPunch(self.ViewPunchThrow)
		end
		self:EmitSound(self.ThrowSound)
	end
	self:SelectAnimation(1)
	owner:SetAnimation(PLAYER_ATTACK1)
	self:SetThrowTime(CurTime() + self.ThrowTime)
	self:SetNextPrimaryFire(CurTime() + self.ThrowTime + 0.1)
	self:SetNextSecondaryFire(CurTime() + self.ThrowTime + 0.1)
end

function SWEP:CreateThrownWeapon()
end

function SWEP:CheckAttacking()
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	local curtime = CurTime()
	local attack1 = self:GetAttack1Time()
	if attack1 > 0 and attack1 <= curtime then
		self:SetAttack1Time(0)
		self:InflictDamage(true)
	end
	local attack2 = self:GetAttack2Time()
	if attack2 > 0 and attack2 <= curtime then
		self:SetAttack2Time(0)
		self:InflictDamage(false)
	end
	local throw = self:GetThrowTime()
	if throw > 0 and throw <= curtime then
		self:SetThrowTime(0)
		if self.EffectsOnThrow then
			if self.ViewPunchThrow then
				owner:ViewPunch(self.ViewPunchThrow)
			end
			self:EmitSound(self.ThrowSound)
		end
		self:CreateThrownWeapon()
	end
end

function SWEP:Think_MG()
	BaseClass.Think_MG(self)
	self:CheckAttacking()
end

print("[MG] Melee Base initialised.")