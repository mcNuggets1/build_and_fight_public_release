SWEP.Base = "mg_gun_base"
SWEP.Weight	= 40
SWEP.ShellTime = 0.35
SWEP.SkipReload = false
SWEP.ReloadAmount = 1
SWEP.EmptySound = Sound("Weapon_Shotgun.Empty")

DEFINE_BASECLASS("mg_gun_base")

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar("Bool", 5, "CancelReload")
	self:NetworkVar("Bool", 6, "ReloadedOnce")
end

function SWEP:DeployShared()
	self:SetCancelReload(false)
	self:SetReloadedOnce(false)
	BaseClass.DeployShared(self)
end

function SWEP:HolsterShared()
	self:SetCancelReload(false)
	self:SetReloadedOnce(false)
	BaseClass.HolsterShared(self)
end

function SWEP:Reload()
	if self.CanReload then
		if self:GetDrawAnim() <= CurTime() and self:Clip1() != self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 and !self:GetReloading() and !self:GetSilencing() then
			if (self.CanLower or self.CanSelectFire) and self.Owner:KeyDown(IN_USE) then return end
			if self:GetPredictedAiming() then
				self:RemoveIronSights()
			end
			if self:GetPredictedRunning() then
				self:StopRunning()
			end
			self.Owner:SetAnimation(PLAYER_RELOAD)
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			local actual_delay = self.ShellTime
			actual_delay = hook.Run("M9K_ShotgunReloadMultiplier", self, actual_delay) or actual_delay
			if actual_delay != self.ShellTime and !self.Owner:IsNPC() then
				local vm = self.Owner:GetViewModel()
				if IsValid(vm) then
					vm:SetPlaybackRate(1 * (self.ShellTime / actual_delay)) 
				end
			end
			self:SetNextPrimaryFire(CurTime() + actual_delay)
			self:SetNextSecondaryFire(CurTime() + actual_delay)
			self:SetReloading(true)
			self:SetReloadingTimer(CurTime() + actual_delay)
		end
	end
end

function SWEP:ReloadBucks(owner, amount)
	local MaxClip = self.Primary.ClipSize
	local Clip = self:Clip1()
	local AmmoCount = math.min(amount or self.ReloadAmount, owner:GetAmmoCount(self.Primary.Ammo))
	owner:RemoveAmmo(math.Clamp(MaxClip - Clip, 0, AmmoCount), self.Primary.Ammo)
	self:SetClip1(math.Clamp(MaxClip, 0, Clip + AmmoCount))
end

function SWEP:CheckReloading()
	local owner = self.Owner
	if !IsValid(owner) then return end
	if self:GetReloading() then
		if owner:KeyPressed(IN_ATTACK) then
			self:SetCancelReload(true)
		end
		if self:GetPredictedAiming() then
			self:SetAiming(false)
		end
		if self:GetReloadingTimer() < CurTime() then
			if self:GetCancelReload() and self:GetReloadedOnce() then
				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				local actual_delay = self:SequenceDuration()
				actual_delay = hook.Run("M9K_ShotgunReloadMultiplier", self, actual_delay) or actual_delay
				if actual_delay != self:SequenceDuration() and !self.Owner:IsNPC() then
					local vm = self.Owner:GetViewModel()
					if IsValid(vm) then
						vm:SetPlaybackRate(1 * (self:SequenceDuration() / actual_delay)) 
					end
				end
				self:SetNextPrimaryFire(CurTime() + actual_delay)
				self:SetNextSecondaryFire(CurTime() + actual_delay)
				self:SetReloading(false)
				self:SetCancelReload(false)
				self:SetReloadedOnce(false)
				return
			end
			if self.SkipReload or self:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				if self.SkipReload then
					self:ReloadBucks(owner, math.huge)
				end
				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				local actual_delay = self:SequenceDuration()
				actual_delay = hook.Run("M9K_ShotgunReloadMultiplier", self, actual_delay) or actual_delay
				if actual_delay != self:SequenceDuration() and !self.Owner:IsNPC() then
					local vm = self.Owner:GetViewModel()
					if IsValid(vm) then
						vm:SetPlaybackRate(1 * (self:SequenceDuration() / actual_delay)) 
					end
				end
				self:SetNextPrimaryFire(CurTime() + actual_delay)
				self:SetNextSecondaryFire(CurTime() + actual_delay)
				self:SetReloading(false)
				self:SetCancelReload(false)
				self:SetReloadedOnce(false)
			elseif self:Clip1() <= self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 0 then
				self:SetReloadedOnce(true)
				self:ReloadBucks(owner)
				self:SendWeaponAnim(ACT_VM_RELOAD)
				local actual_delay = self.ShellTime
				actual_delay = hook.Run("M9K_ShotgunReloadMultiplier", self, actual_delay) or actual_delay
				if actual_delay != self.ShellTime and !self.Owner:IsNPC() then
					local vm = self.Owner:GetViewModel()
					if IsValid(vm) then
						vm:SetPlaybackRate(1 * (self.ShellTime / actual_delay)) 
					end
				end
				self:SetReloadingTimer(CurTime() + actual_delay)
			else
				self:SetReloading(false)
				self:SetCancelReload(false)
				self:SetReloadedOnce(false)
			end
		end
	end
end

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
	local att = dmginfo:GetAttacker()
	if !IsValid(att) then return 2 end
	local dist = victim:GetPos():Distance(att:GetPos())
	local d = math.max(0, dist - 200)
	return 1 + math.max(0, (1 - 0.002 * (d ^ 1.25)))
end

hook.Add("ScalePlayerDamage", "M9K_ShotgunDamage", function(ply, hitgroup, dmginfo)
	if hitgroup == HITGROUP_HEAD then
		local wep
		local inf = dmginfo:GetInflictor()
		if inf:IsPlayer() then
			wep = inf:GetActiveWeapon()
		end
		if IsValid(wep) and wep.GetHeadshotMultiplier then
			local s = wep:GetHeadshotMultiplier(ply, dmginfo)
			dmginfo:ScaleDamage(s)
		end
	end
end)

print("[MG] Shotgun Base initialised.")