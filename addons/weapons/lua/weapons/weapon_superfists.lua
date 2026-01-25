if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName= "Superfäuste"
SWEP.Author = "Modern Gaming & GMod"
SWEP.Purpose = "Mit nur ein paar Schlägen, kannst du deine Gegner aus dem Weg räumen.\nNutze diese Kraft bedacht!"
SWEP.Category = "Legendäre Waffen"
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel	= ""
SWEP.ViewModelFOV = 52
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "fist"
SWEP.CanExplode = true
SWEP.IsGun = true

local SwingSound = Sound("weapons/slam/throw.wav")
local HitSound = Sound("Flesh.ImpactHard")

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextMeleeAttack")
	self:NetworkVar("Int", 2, "Combo")
	self:NetworkVar("Float", 1, "NextIdle")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) and vm.SequenceDuration and isnumber(vm:SequenceDuration()) and vm.GetPlaybackRate and isnumber(vm:GetPlaybackRate()) then
		self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
	end
end

function SWEP:PrimaryAttack(right)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local anim = "fists_left"
	if right then anim = "fists_right" end
	if (self:GetCombo() >= 2) then
		anim = "fists_uppercut"
	end
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
		vm:SetPlaybackRate(2)
	end
	self:UpdateNextIdle()
	self:EmitSound(SwingSound)
	self:SetNextMeleeAttack(CurTime() + 0.05)
	self:SetNextPrimaryFire(CurTime() + 0.2)
	self:SetNextSecondaryFire(CurTime() + 0.2)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

function SWEP:DealDamage()
	local owner = self.Owner
	local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())
	owner:LagCompensation(true)
	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:EyeAngles():Forward() * 78,
		filter = owner,
		mask = MASK_SHOT_HULL
	})
	if !IsValid(tr.Entity) then 
		tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:EyeAngles():Forward() * 78,
			filter = owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL
		})
	end
	if (tr.Hit and !(game.SinglePlayer() and CLIENT)) then
		self:EmitSound(HitSound)
	end
	local hitplayer = false
	if SERVER and IsValid(tr.Entity) then
		if tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
			hitplayer = true
		end
		local dmginfo = DamageInfo()
		local attacker = owner
		if !IsValid(attacker) then attacker = self end
		dmginfo:SetAttacker(attacker)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(math.random(26, 28))
		if (anim == "fists_left") then
			dmginfo:SetDamageForce(owner:GetRight() * 4912 + owner:GetForward() * 99980)
		elseif (anim == "fists_right") then
			dmginfo:SetDamageForce(owner:GetRight() * -4912 + owner:GetForward() * 99890)
		elseif (anim == "fists_uppercut") then
			dmginfo:SetDamageForce(owner:GetUp() * 5158 + owner:GetForward() * 100120)
			dmginfo:SetDamage(math.random(38, 40))
		end
		local pos = owner:GetShootPos()
		local dest = pos + (owner:EyeAngles():Forward() * 78)
		tr.Entity:DispatchTraceAttack(dmginfo, pos + (owner:EyeAngles():Forward() * 3), dest)
	end
	if IsValid(tr.Entity) then
		local phys = tr.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceOffset(owner:EyeAngles():Forward() * 250 * phys:GetMass(), tr.HitPos)
		end
	end
	if (hitplayer and anim != "fists_uppercut") then
		self:SetCombo(self:GetCombo() + 1)
	else
		self:SetCombo(0)
	end
	owner:LagCompensation(false)
end

function SWEP:Reload()
	if !self.CanExplode then return end
	self.CanExplode = false
	if CLIENT then
		self.Owner:ConCommand("act zombie")
	end
	self:SetNextSecondaryFire(CurTime() + 1000)
	self:SetNextPrimaryFire(CurTime() + 1000)
	if SERVER then
		self.Owner:EmitSound("weapons/jihad/jihad.wav")
		timer.Simple(2, function()
			if IsValid(self) then
				self:Explode()
			end
		end)
	end
end

function SWEP:Explode()
	local owner = self.Owner
	local pos = owner:GetPos()
	util.BlastDamage(self, owner, pos, 200, 300)
	util.ScreenShake(pos, 512, 255, 2.5, 300)
	local edata = EffectData()
	edata:SetOrigin(pos)
	util.Effect("Explosion", edata, true, true)
	util.Decal("Scorch", pos, pos - Vector(0, 0, 30), owner)
	owner:EmitSound("weapons/jihad/big_explosion.wav")
	if owner:Alive() then
		owner:Kill()
	end
end

function SWEP:Deploy()
	self:SetNextMeleeAttack(0)
	if IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) and vm.LookupSequence and isnumber(vm:LookupSequence("fists_draw")) then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
			vm:SetPlaybackRate(2)
			self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() * 0.35)
			self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() * 0.35)
		end
	end
	self:UpdateNextIdle()
	self:SetCombo(0)
	return true
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	if (idletime > 0 and curtime > idletime) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0"..math.random(1,2)))
		self:UpdateNextIdle()
	end
	local meleetime = self:GetNextMeleeAttack()
	if (meleetime > 0 and curtime > meleetime) then
		self:DealDamage()
		self:SetNextMeleeAttack(0)
	end
	if (curtime > self:GetNextPrimaryFire() + 0.1) then
		self:SetCombo(0)
	end
end