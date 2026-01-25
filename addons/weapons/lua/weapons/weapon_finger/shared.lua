if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.SwayScale = 1.3
end

SWEP.PrintName = "Gottes kleiner Finger"
SWEP.Category = "Legendäre Waffen"
SWEP.Purpose = "Spaß mit Superkräften."
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_darocket.mdl"
SWEP.WorldModel	= "models/maxofs2d/balloon_gman.mdl"
SWEP.Spawnable = true
SWEP.Primary.Damage = 55
SWEP.Range = 125
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.Ammo	= ""
SWEP.IsGun = true

function SWEP:Initialize()
	self:DrawShadow(false)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() * 0.95)
	return true
end

local lol = Sound("weapons/god/lol.wav")
function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	self:SetNextPrimaryFire(CurTime () + 1.6)
	self:EmitSound(lol)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local trace = self.Owner:GetEyeTrace()
	if IsFirstTimePredicted() then
		local edata = EffectData()
		edata:SetOrigin(trace.HitPos)
		edata:SetNormal(trace.HitNormal)
		util.Effect("god_hit", edata)
	end
	if SERVER then
		sound.Play(lol, trace.HitPos)
		util.BlastDamage(self, self.Owner, trace.HitPos, self.Range, self.Primary.Damage)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end