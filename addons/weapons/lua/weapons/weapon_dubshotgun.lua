if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	SWEP.Slot = 3
	SWEP.SlotPos = 4
	killicon.Add("weapon_dubshotgun", "bender/killicon", color_white)
end

SWEP.HoldType = "shotgun"
SWEP.Base = "weapon_basekit"
SWEP.PrintName = "Dubstep Shotgun"
SWEP.Purpose = "Der Beat tötet."
SWEP.Category = "Legendäre Waffen"
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_shot_bulkcn.mdl"
SWEP.WorldModel = Model("models/weapons/w_shotgun.mdl")
SWEP.ShowWorldModel = false
SWEP.ShowWorldModelNoOwner = true
SWEP.Spawnable = true
SWEP.Primary.Damage = 15
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

SWEP.WeaponType = "shotgun"

SWEP.WElements = {
	["dubshotgun"] = {type = "Model", model = "models/weapons/w_shot_bulkcn.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, -1), angle = Angle(-5.144, 0.823, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1)
	BaseClass.Initialize(self)
end

local dub_loop = Sound("weapons/bender/dub_loop.wav")
function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	if (self:GetNextPrimaryFire() > CurTime()) then return end
	if (self:GetNextSecondaryFire() > CurTime()) then return end
	if self.Owner:WaterLevel() > 2 then return end
	if self.LoopSound then
		self.LoopSound:ChangeVolume(1, 0.1)
	else
		self.LoopSound = CreateSound(self.Owner, dub_loop)
		if self.LoopSound then
			self.LoopSound:Play()
		end
	end
	if self.BeatSound then
		self.BeatSound:ChangeVolume(0, 0.1)
	end
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	bullet.Spread = Vector(0.015, 0.015, 0)
	bullet.Tracer = 1
	bullet.Force = 5
	bullet.Damage = self.Primary.Damage * math.Rand(0.75, 1.25)
	bullet.TracerName = "dub_tracer"
	self.Owner:FireBullets(bullet)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) then return end
	if (self:GetNextPrimaryFire() > CurTime()) then return end
	if (self:GetNextSecondaryFire() > CurTime()) then return end
	if self.Owner:WaterLevel() > 2 then return end
	self:EmitSound("weapons/bender/nya"..math.random(1, 2)..".wav", 100, math.random(85, 100))
	local bullet = {}
	bullet.Num = 8
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	bullet.Spread = Vector(0.14, 0.14, 0)
	bullet.Tracer = 1
	bullet.Force = 5
	bullet.Damage = self.Primary.Damage * 0.4
	bullet.TracerName = "dub_tracer"
	self.Owner:FireBullets(bullet)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay) 
end

function SWEP:Reload()
end

function SWEP:DoImpactEffect(trace)
	if !IsFirstTimePredicted() then return end
	for i=1, math.random(1, 3) do
		local edata = EffectData()
		edata:SetStart(trace.HitPos)
		edata:SetOrigin(trace.HitNormal + Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5)))
		util.Effect("dub_bounce", edata)
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
	return BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self:KillSounds()
	return BaseClass.OnRemove(self)
end

function SWEP:OnDrop()
	self:KillSounds()
end

local dub_beat = Sound("weapons/bender/drop.wav")
function SWEP:Deploy()
	if SERVER then
		self.BeatSound = CreateSound(self.Owner, dub_beat)
		if self.BeatSound then
			self.BeatSound:Play()
		end
	end
	return BaseClass.Deploy(self)
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

function SWEP:ViewModelDrawn(vm)
	if (self.NextViewParticle or 0) > CurTime() then return end
	self.NextViewParticle = CurTime() + 0.01
	local attach = vm:GetAttachment(1)
	if !attach or !attach.Pos then return end
	local pos = attach.Pos
	local edata = EffectData()
	edata:SetOrigin(pos)
	util.Effect("dub_fire", edata)
end

function SWEP:DrawWorldModel()
	BaseClass.DrawWorldModel(self)
	if !IsValid(self.Owner) or (self.NextWorldParticle or 0) > CurTime() then return end
	self.NextWorldParticle = CurTime() + 0.01
	local ent = IsValid(self.WElements["dubshotgun"].modelEnt) and self.WElements["dubshotgun"].modelEnt
	if ent then
		local attach = ent:GetAttachment(1)
		if !attach or !attach.Pos then return end
		local pos = attach.Pos + ent:GetForward() * -10
		local edata = EffectData()
		edata:SetOrigin(pos)
		util.Effect("dub_fire", edata)
	end
end