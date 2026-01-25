if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Medkit"
SWEP.Author = "robotboy655, MaxOfS2D & Modern Gaming"
SWEP.Purpose = "Heile andere Spieler mit primärer Feuertaste und dich selber mit sekundärer."

SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

SWEP.HealAmount = 15
SWEP.MaxAmmo = 100

local HealSound = Sound("HealthKit.Touch")
local DenySound = Sound("WallHealth.Deny")

function SWEP:Initialize()
	self:SetHoldType("slam")
	if CLIENT then return end
	timer.Create("medkit_ammo_"..self:EntIndex(), 0.5, 0, function()
		if IsValid(self) and self:Clip1() < self.MaxAmmo and self:GetNextPrimaryFire() <= CurTime() and self:GetNextSecondaryFire() <= CurTime() then
			self:SetClip1(math.min(self:Clip1() + 1, self.MaxAmmo))
		end
	end)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	if self.Owner:IsPlayer() then
		self.Owner:LagCompensation(true)
	end
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 64,
		filter = self.Owner
	})
	if self.Owner:IsPlayer() then
		self.Owner:LagCompensation(false)
	end
	local ent = tr.Entity
	local need = self.HealAmount
	if IsValid(ent) then
		need = math.min(ent:GetMaxHealth() - ent:Health(), self.HealAmount)
	end
	if (IsValid(ent) and self:Clip1() >= need and (ent:IsPlayer() or ent:IsNPC()) and ent:Health() < ent:GetMaxHealth()) then
		self:TakePrimaryAmmo(need)
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
		ent:EmitSound(HealSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.1)
		self:SetNextSecondaryFire(CurTime() + self:SequenceDuration() + 0.1)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		timer.Create("medkit_idle_"..self:EntIndex(), self:SequenceDuration(), 1, function()
			if IsValid(self) then
				self:SendWeaponAnim(ACT_VM_IDLE)
			end
		end)
	else
		self.Owner:EmitSound(DenySound)
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	local ent = self.Owner
	local need = self.HealAmount
	if IsValid(ent) then
		need = math.min(ent:GetMaxHealth() - ent:Health(), self.HealAmount)
	end
	if (IsValid(ent) and self:Clip1() >= need and ent:Health() < ent:GetMaxHealth()) then
		self:TakePrimaryAmmo(need)
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
		ent:EmitSound(HealSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.1)
		self:SetNextSecondaryFire(CurTime() + self:SequenceDuration() + 0.1)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		timer.Create("medkit_idle_"..self:EntIndex(), self:SequenceDuration(), 1, function()
			if IsValid(self) then
				self:SendWeaponAnim(ACT_VM_IDLE)
			end
		end)
	else
		ent:EmitSound(DenySound)
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

function SWEP:OnRemove()
	timer.Remove("medkit_ammo_"..self:EntIndex())
	timer.Remove("medkit_idle_"..self:EntIndex())
end

function SWEP:Holster()
	timer.Remove("medkit_idle_"..self:EntIndex())
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()
	return self.AmmoDisplay
end