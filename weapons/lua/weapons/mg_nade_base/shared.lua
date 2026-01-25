SWEP.IsGrenade = true
SWEP.Category = ""
SWEP.PrintName = ""
SWEP.Slot = 0
SWEP.SlotPos = 5
SWEP.DrawAmmo = true
SWEP.DrawWeaponInfoBox = true
SWEP.BounceWeaponIcon = false
SWEP.DrawCrosshair = false
SWEP.ForceWeaponIcon = true
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Primary Fire: Throw Grenade.\nSecondary Fire: Roll Grenade."
SWEP.Weight	= 10
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom	= true
SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 70
SWEP.Spawnable = false
SWEP.HoldNormal = "slam"
SWEP.HoldReady = "grenade"
SWEP.Primary.Sound = ""
SWEP.Primary.RPM = 50
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Grenade"
SWEP.Secondary.Ammo = "none"
SWEP.ThrowForce = 4000
SWEP.AllowShortThrows = true
SWEP.ShortThrowForce = 2500
SWEP.PreThrowDuration = 0.75
SWEP.ThrowDuration = 0.35
SWEP.CheckAmmoDuration = 0.2
SWEP.DrawGrenadeDuration = 0.1
SWEP.DetonateTime = 5
SWEP.Explode = false

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "ThrowTime")
	self:NetworkVar("Float", 1, "DetTime")
	self:NetworkVar("Float", 2, "PullPin")
	self:NetworkVar("Bool", 0, "Short")
end

function SWEP:Initialize()
	self:InitShared()
	if SERVER then
		self:InitServer()
	end
	if CLIENT then
		self:InitClient()
	end
	self:AddInit()
end

function SWEP:Deploy()
	self:DeployShared()
	if SERVER then
		self:DeployServer()
	end
	if CLIENT then
		self:DeployClient()
	end
	self:AddDeploy()
	self:CallOnClient("Deploy")
	return true
end

function SWEP:Holster()
	self:HolsterShared()
	if SERVER then
		self:HolsterServer()
	end
	if CLIENT then
		self:HolsterClient()
	end
	self:AddHolster()
	return true
end

function SWEP:OnRemove()
	if CLIENT then
		self:ClearAllModels(true)
	end
end

function SWEP:AddInit()
end

function SWEP:AddDeploy()
end

function SWEP:AddHolster()
end

function SWEP:InitShared()
	self:SetHoldType(self.HoldNormal)
end

function SWEP:DeployShared()
	self:SetHoldType(self.HoldNormal)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
	timer.Remove("PreThrowGrenade_"..self:EntIndex())
	timer.Remove("DrawNewGrenade_"..self:EntIndex())
	self:SetShort(false)
	self:SetThrowTime(0)
	self:SetPullPin(0)
	self:SetDetTime(0)
	timer.Simple(0, function()
		if !IsValid(self) or !IsValid(self.Owner) then return end
		if (self:Clip1() <= 0) then
			if (self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) > 0) then
				self:SetClip1(1)
				self.Owner:RemoveAmmo(1, self:GetPrimaryAmmoType())
			elseif SERVER then
				MG_RemoveWeapon(self)
			end
		end
	end)
end

function SWEP:HolsterShared()
	timer.Remove("PreThrowGrenade_"..self:EntIndex())
	timer.Remove("DrawNewGrenade_"..self:EntIndex())
	self:SetShort(false)
	self:SetThrowTime(0)
	self:SetPullPin(0)
	self:SetDetTime(0)
end

function SWEP:Throw(short)
	self:SendWeaponAnim(ACT_VM_THROW)
	self:SetPullPin(0)
	self:SetThrowTime(CurTime() + self.ThrowDuration)
	if short == true then
		self:SetShort(true)
	elseif short == false then
		self:SetShort(false)
	end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		return false
	end
	return true
end

function SWEP:PrimaryAttack(short)
	if !self:CanPrimaryAttack() or self:GetPullPin() != 0 or self:GetThrowTime() != 0 then return end
	self:SendWeaponAnim(ACT_VM_PULLPIN)
	self:SetNextPrimaryFire(CurTime() + 10)
	self:SetNextSecondaryFire(CurTime() + 10)
	self:SetPullPin(CurTime() + self.PreThrowDuration)
	self:SetDetTime(CurTime() + self.DetonateTime)
	self:SetHoldType(self.HoldReady)
	if self.AllowShortThrows then
		if short then
			self:SetShort(true)
		else
			self:SetShort(false)
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

function SWEP:Think()
	local owner = self.Owner
	if !IsValid(owner) then return end
	if self:GetPullPin() != 0 and self:GetPullPin() < CurTime() then
		if !owner:KeyDown(IN_ATTACK) and !owner:KeyDown(IN_ATTACK2) then
			local long = owner:KeyReleased(IN_ATTACK)
			local short = owner:KeyReleased(IN_ATTACK2)
			self:Throw(long and short and nil or long and false or short and true or nil)
		end
	end
	if self:GetThrowTime() != 0 and self:GetThrowTime() < CurTime() then
		self:SetThrowTime(0)
		owner:SetAnimation(PLAYER_ATTACK1)
		if SERVER then
			self:CreateGrenade(self:GetShort() and self.ShortThrowForce or self.ThrowForce)
		end
		self:SetDetTime(0)
		self:SetShort(false)
		self:TakePrimaryAmmo(1)
		self:CheckGrenades()
	end
	if self.Explode and self:GetDetTime() != 0 and self:GetDetTime() < CurTime() then
		self:SetPullPin(0)
		self:SetThrowTime(0)
		self:SetDetTime(0)
		if SERVER then
			self:BlowInFace()
		end
		self:SetShort(false)
		self:TakePrimaryAmmo(1)
		self:CheckGrenades()
	end
end

function SWEP:CheckGrenades()
	timer.Create("CheckAmmo_"..self:EntIndex(), self.CheckAmmoDuration, 1, function()
		if !IsValid(self) or !IsValid(self.Owner) then return end
		local wep = self.Owner:GetActiveWeapon()
		if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0) then
			if SERVER then
				MG_RemoveWeapon(self)
			end
		elseif (wep:IsValid() and wep:GetClass() == self.ClassName) then
			timer.Create("DrawNewGrenade_"..self:EntIndex(), self.DrawGrenadeDuration, 1, function()
				if IsValid(self) and IsFirstTimePredicted() then
					self:DefaultReload(ACT_VM_DRAW)
				end
			end)
		end
	end)
end

print("[MG] Grenade Base initialised.")