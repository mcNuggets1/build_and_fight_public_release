if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.PrintName = "Wiimote"
SWEP.Purpose = "Schlage deine Gegner mit einer Wii-Fernbedingung.\nIch meine, wieso nicht?"
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = false
SWEP.Spawnable = true
SWEP.Category = "Legendäre Waffen"
SWEP.ViewModel = "models/weapons/v_wiimote_meow.mdl"
SWEP.WorldModel = Model("models/weapons/w_wiimote_meow.mdl")
SWEP.Primary.Sound = Sound("weapons/iceaxe/iceaxe_swing1.wav")
SWEP.Primary.Damage = 65
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.55
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Damage = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() * 0.95)
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration() * 0.95)
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	local owner = self.Owner
	if !IsValid(owner) then return end
	owner:SetAnimation(PLAYER_ATTACK1)
	owner:LagCompensation(true)
	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:EyeAngles():Forward() * 74,
		filter = owner,
		mask = MASK_SHOT_HULL
	})
	if !IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:EyeAngles():Forward() * 74,
			filter = owner,
			mins = Vector(-2, -2, -2),
			maxs = Vector(2, 2, 2),
			mask = MASK_SHOT_HULL
		})
	end
	local ent = tr.Entity
	local vm = owner:GetViewModel()
	if tr.Hit then
		local rand = {1, 2, 3, 5}
		self:EmitSound("physics/plastic/plastic_box_impact_bullet"..rand[math.random(4)]..".wav")
		if IsValid(vm) then
			vm:SendViewModelMatchingSequence(4)
		end
		local pos = owner:GetShootPos()
		local edata = EffectData()
		edata:SetStart(pos)
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.Normal)
		edata:SetSurfaceProp(tr.SurfaceProps)
		edata:SetHitBox(tr.HitBox)
		edata:SetEntity(tr.HitEntity)
		if IsFirstTimePredicted() then
			util.Effect("wii_hit", edata)
		end
		if IsValid(ent) then
			if ent:IsPlayer() or ent:IsNPC() then
				if IsFirstTimePredicted() and tr.MatType == MAT_FLESH then
					local edata = EffectData()
					edata:SetOrigin(tr.HitPos)
					util.Effect("BloodImpact", edata)
				end
			end
			if SERVER then
				local dmginfo = DamageInfo()
				dmginfo:SetDamageType(DMG_CLUB)
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(self.Primary.Damage * math.Rand(0.75, 1.25))
				dmginfo:SetDamageForce(tr.Normal * 24)
				dmginfo:SetDamagePosition(tr.HitPos) -- Fixes an error -> "AddMultiDamage:  g_MultiDamage.GetDamagePosition() == vec3_origin"
				local dest = pos + (owner:EyeAngles():Forward() * 78)
				ent:DispatchTraceAttack(dmginfo, pos + (owner:EyeAngles():Forward() * 3), dest)
			end
		end
	else
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	if IsValid(vm) then
		vm:SetPlaybackRate(1.5)
	end
	if IsValid(ent) then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceOffset(owner:EyeAngles():Forward() * 120 * phys:GetMass(), tr.HitPos)
		end
	end
	owner:LagCompensation(false)
end

local throw = Sound("weapons/slam/throw.wav")
function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) then return end
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() * 0.95)
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
	self:EmitSound(throw)
	self.Owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -3, -3, 0), util.SharedRandom(self:GetClass(), -3, 3, 0), util.SharedRandom(self:GetClass(), -1, 1, 0)))
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		local wii = ents.Create("wiimote")
		if !IsValid(wii) then return end
		wii:SetAngles(self.Owner:EyeAngles())
		wii:SetPos(self.Owner:GetShootPos() + self.Owner:EyeAngles():Right() * 10 + self.Owner:EyeAngles():Forward() * 3 - self.Owner:EyeAngles():Up() * 2)
		wii:SetPhysicsAttacker(self.Owner)
		wii:SetOwner(self.Owner)
		wii.Owner = self.Owner
		wii:Spawn()
		wii:Activate()
		local phys = wii:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self.Owner:EyeAngles():Forward() * 1500)
			phys:AddAngleVelocity(Vector(0, 355, 0))
		end
	end
end