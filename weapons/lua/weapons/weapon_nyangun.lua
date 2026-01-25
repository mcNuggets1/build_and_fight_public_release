if CLIENT then
	SWEP.Slot = 2
	SWEP.SlotPos = 3
	killicon.Add("weapon_nyangun", "nyan/killicon", color_white)
end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Nyan Gun"
SWEP.Purpose = "Töten mit Stil."
SWEP.Category = "Legendäre Waffen"
SWEP.UseHands = true
SWEP.ViewModelFOV = 80
SWEP.ViewModel = "models/pwb/weapons/v_uzi.mdl"
SWEP.WorldModel = Model("models/pwb/weapons/w_uzi.mdl")
SWEP.Spawnable = true
SWEP.HoldType = "revolver"
SWEP.Primary.Damage = 14
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Delay = 0.5
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

SWEP.WeaponType = "smg"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

local nyan_loop = Sound("weapons/nyan/nyan_loop.wav")
function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	if (self:GetNextPrimaryFire() > CurTime()) then return end
	if (self:GetNextSecondaryFire() > CurTime()) then return end
	if self.Owner:WaterLevel() > 2 then return end
	if self.LoopSound then
		self.LoopSound:ChangeVolume(1, 0.1)
	else
		self.LoopSound = CreateSound(self.Owner, nyan_loop)
		if self.LoopSound then
			self.LoopSound:Play()
		end
	end
	if self.BeatSound then
		self.BeatSound:ChangeVolume(0, 0.1)
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	bullet.Spread = Vector(0.01, 0.01, 0)
	bullet.Tracer = 1
	bullet.Force = 5
	bullet.Damage = self.Primary.Damage * math.Rand(0.75,1.25)
	bullet.TracerName = "nyan_tracer"
	self.Owner:FireBullets(bullet)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) then return end
	if (self:GetNextPrimaryFire() > CurTime()) then return end
	if (self:GetNextSecondaryFire() > CurTime()) then return end
	if self.Owner:WaterLevel() > 2 then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound("weapons/nyan/nya"..math.random(1,2)..".wav", 100, math.random(85, 100))
	local bullet = {}
	bullet.Num = 6
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	bullet.Spread = Vector(0.1, 0.1, 0)
	bullet.Tracer = 1
	bullet.Force = 5
	bullet.Damage = self.Primary.Damage * 0.4
	bullet.TracerName = "nyan_tracer"
	self.Owner:FireBullets(bullet)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay) 
end

function SWEP:Reload()
	if !IsValid(self.Owner) then return end 
	if !self.Owner:KeyPressed(IN_RELOAD) then return end
	if (self:GetNextPrimaryFire() > CurTime()) then return end
	if (self:GetNextSecondaryFire() > CurTime()) then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if SERVER then
		local ang = self.Owner:EyeAngles()
		local ent = ents.Create("nyan_bomb")
		if !IsValid(ent) then return end
		ent:SetPos(self.Owner:GetShootPos() + ang:Forward() * 28 + ang:Right() * 24 - ang:Up() * 8)
		ent:SetAngles(ang)
		ent:SetOwner(self.Owner)
		ent:Spawn()
		ent:Activate()
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:AddVelocity(ent:GetForward() * 1337)
		end
	end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:EmitSound("weapons/nyan/nya"..math.random(1,2)..".wav", 100, math.random(60, 80))
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:DoImpactEffect(trace)
	if !IsFirstTimePredicted() then return end
	for i=1, math.random(1, 3) do
		local edata = EffectData()
		edata:SetStart(trace.HitPos)
		edata:SetOrigin(trace.HitNormal + Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5)))
		util.Effect("nyan_bounce", edata)
	end
	return true
end

function SWEP:FireAnimationEvent(pos, ang, event)
	return true
end

function SWEP:KillSounds()
	if self.BeatSound then
		self.BeatSound:Stop()
		self.BeatSound = nil
	end
	if self.LoopSound then
		self.LoopSound:Stop()
		self.LoopSound = nil
	end
end

function SWEP:Holster()
	self:KillSounds()
	return true
end

function SWEP:OnRemove()
	self:KillSounds()
end

function SWEP:OnDrop()
	self:KillSounds()
end

local nyan_beat = Sound("weapons/nyan/nyan_beat.wav")
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	if CLIENT then return true end
	self.BeatSound = CreateSound(self.Owner, nyan_beat)
	if self.BeatSound then
		self.BeatSound:Play()
	end
	return true
end

function SWEP:Think()
	if !IsValid(self.Owner) then return end
	if self.Owner:KeyReleased(IN_ATTACK) or !self.Owner:KeyDown(IN_ATTACK) or self.Owner:WaterLevel() > 2 then
		if self.LoopSound then
			self.LoopSound:ChangeVolume(0, 0.1)
		end
		if self.BeatSound then
			self.BeatSound:ChangeVolume(1, 0.1)
		end
	end
end