SWEP.IsGun = true
SWEP.Category = ""
SWEP.PrintName = ""
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.DrawAmmo = true
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = true
SWEP.BounceWeaponIcon = false
SWEP.DrawCrosshair = true
SWEP.AimHideCrosshair = false
SWEP.ForceWeaponIcon = true
SWEP.CSMuzzleFlashes = true
SWEP.MuzzleAttachment = "1"
SWEP.WorldMuzzleFlashes = true
SWEP.ShellEjectAttachment = "2"
SWEP.TracerName = "Tracer"
SWEP.Tracer = 2
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Weight	= 25
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom	= true
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 65
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.Spawnable = false
SWEP.HoldType = ""
SWEP.Primary.Sound = ""
SWEP.Primary.Sound_Silenced = ""
SWEP.Primary.SoundLevel = 100
SWEP.Primary.Round = ""
SWEP.Primary.Damage = 10
SWEP.Primary.Spread = 0.01
SWEP.Primary.NumShots = 1
SWEP.Primary.RPM = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.KickUp = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.IronAccuracy = 0
SWEP.Secondary.SightsFOV = 55
SWEP.Secondary.Ammo = "none"
SWEP.DeployDelay = 1
SWEP.AimHideAttachments = false
SWEP.AimHideViewModel = false
SWEP.RunHoldType = "passive"
SWEP.AimHoldType = SWEP.HoldType
SWEP.LoweredHoldType = SWEP.RunHoldType
SWEP.CrouchedLoweredHoldType = "normal"
SWEP.ReloadAnim = ACT_VM_RELOAD
SWEP.ReloadAnim_Silenced = ACT_VM_RELOAD_SILENCED
SWEP.DeploySpeed = 1
SWEP.ReloadSpeed = 1
SWEP.SilenceSpeed = 1
SWEP.AimKey = IN_ATTACK2
SWEP.RunKey = IN_SPEED
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")
SWEP.FiresUnderwater = false
SWEP.CanAim = true
SWEP.CanRun = true
SWEP.CanReload = true
SWEP.CanSilence = false
SWEP.CanLower = true
SWEP.CanSelectFire = false
SWEP.NextAllowedAim = 0
SWEP.NextAllowedRun = 0
SWEP.AimingClientside = false
SWEP.RunningClientside = false
SWEP.SightsPos = Vector(0, 0, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(0, 0, 0)
SWEP.LoweredPos = Vector(0, 2, 0)
SWEP.LoweredAng = Vector(-15, 0, 0)
SWEP.VElements = {}
SWEP.WElements = {}

MODE_AUTO = "auto"
MODE_SEMI = "semi"
MODE_SAFE = "safe"

SWEP.Translations = {
	Shoot = "Shoot",
	Aim = "Aim",
	ReloadAction = "Reload Weapon",
	Silence = "(De)Attach Silencer",
	SelectFire = "Switch Firemode",

	Primary = "Primary Fire",
	Secondary = "Secondary Fire",
	Reload = "Reload Key",
	Use = "Use Key",

	AutomaticSelected = "Automatic selected.",
	SemiSelected = "Semi automatic selected.",
	LoweredWeapon = "Weapon lowered."
}

function SWEP:SetupDataTables()
	self:NetworkVar("String", 0, "FireMode")
	self:NetworkVar("Float", 0, "DrawAnim")
	self:NetworkVar("Float", 1, "ReloadingTimer")
	self:NetworkVar("Float", 2, "SilencingTimer")
	self:NetworkVar("Float", 3, "NextFireSelect")
	self:NetworkVar("Bool", 0, "Aiming")
	self:NetworkVar("Bool", 1, "Running")
	self:NetworkVar("Bool", 2, "Reloading")
	self:NetworkVar("Bool", 3, "Silencing")
	self:NetworkVar("Bool", 4, "Silenced")
end

function SWEP:GetLowered()
	return self:GetFireMode() == MODE_SAFE
end

function SWEP:Initialize()
	self.Initialized = true
	self:InitShared()
	if SERVER then
		self:InitServer()
	end
	if CLIENT then
		self:InitClient()
	end
	self:AddInit()
end

function SWEP:InitPredictionChanges()
	if self.Predicted then return end
	self.Predicted = true

	local old_Aiming = self.SetAiming
	function self:SetAiming(bool)
		old_Aiming(self, bool)
		self.NextAllowedRun = CurTime() + 0.3
		if CLIENT and IsFirstTimePredicted() or game.SinglePlayer() then
			self.AimingClientside = bool
		end
	end

	local old_Running = self.SetRunning
	function self:SetRunning(bool)
		old_Running(self, bool)
		self.NextAllowedAim = CurTime() + 0.3
		if CLIENT and IsFirstTimePredicted() or game.SinglePlayer() then
			self.RunningClientside = bool
		end
	end
end

function SWEP:Deploy()
	if !self.Initialized then self:Initialize() end
	self:DeployShared()
	if SERVER then
		self:DeployServer()
	end
	if CLIENT then
		self:DeployClient()
	end
	self:AddDeploy()
	self:CallOnClient("DeployClient")
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
	self:InitPredictionChanges()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(math.huge)
	self.DefaultFireMode = self.Primary.Automatic
	self:SetFireMode(self.DefaultFireMode and MODE_AUTO or MODE_SEMI)
end

function SWEP:DeployShared()
	self:SetHoldType(self.HoldType)
	if self.CanReload then
		self:SetReloading(false)
	end
	if self.CanSilence then
		self:SetSilencing(false)
	end
	if self.CanAim then
		self:SetAiming(false, true)
	end
	if self.CanRun then
		self:SetRunning(false, true)
	end
	self:SendWeaponAnim(self:GetSilenced() and ACT_VM_DRAW_SILENCED or ACT_VM_DRAW)
	local duration = self:SequenceDuration()
	local deploy_speed = self.DeploySpeed
	deploy_speed = hook.Run("M9K_DeployMultiplier", self, deploy_speed) or deploy_speed
	if deploy_speed != 1 and !self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			vm:SetPlaybackRate(1 * deploy_speed) 
		end
	end
	local deploy_dur = (duration * self.DeployDelay) / deploy_speed
	local actual_delay = deploy_dur
	actual_delay = CurTime() + actual_delay
	if self:GetNextPrimaryFire() < actual_delay then
		self:SetNextPrimaryFire(actual_delay)
	end
	if self:GetNextSecondaryFire() < actual_delay then
		self:SetNextSecondaryFire(actual_delay)
	end
	self:SetDrawAnim(actual_delay)
	if self.CanLower or self.CanSelectFire then
		self:SetNextFireSelect(CurTime() + 0.1)
	end
end

function SWEP:HolsterShared()
	if self.CanReload then
		self:SetReloading(false)
	end
	if self.CanSilence then
		self:SetSilencing(false)
	end
	if self.CanAim then
		self:SetAiming(false)
	end
	if self.CanRun then
		self:SetRunning(false)
	end
end

function SWEP:GetPredictedAiming()
	
	if SERVER then
		return self:GetAiming()
	else
		local owner = self:GetOwner()
		return owner:IsValid() and LocalPlayer() == owner and self.AimingClientside or false
	end
end

function SWEP:GetPredictedRunning()
	if SERVER then
		return self:GetRunning()
	else
		local owner = self:GetOwner()
		return owner:IsValid() and LocalPlayer() == owner and self.RunningClientside or false
	end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:Empty()
		return false
	end
	return true
end

function SWEP:CanSecondaryAttack()
	if self:Clip1() <= 0 then
		self:Empty()
		return false
	end
	return true
end

function SWEP:Empty()
	if self:GetReloading() or self:GetSilencing() then return end
	if !self:GetRunning() and !self:GetPredictedRunning() then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:SetNextSecondaryFire(CurTime() + 0.5)
		self:EmitSound(self.EmptySound)
	end
	self:Reload()
end

function SWEP:SetNextAttack()
	local delay = 1 / (self.Primary.RPM / 60)
	delay = hook.Run("M9K_SpeedMultiplier", self, delay) or delay
	self:SetNextPrimaryFire(CurTime() + delay)
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) or self:GetLowered() then return end
	if self:CanPrimaryAttack() and !self:GetRunning() and !self:GetPredictedRunning() and !self:GetReloading() and !self:GetSilencing() then
		if !self.FiresUnderWater then
			if IsValid(self.Owner) and self.Owner:WaterLevel() > 2 then
				return
			end
		end
		self:ShootBulletInformation()
		self:TakePrimaryAmmo(1)
		if SERVER then
			self:CheckWeaponsAndAmmo(0)
		end
		self:SetNextAttack()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:ShootBulletInformation()
	local CurrentDamage = (GetConVar("mg_m9k_damagemultiplicator"):GetFloat() or 1) * self.Primary.Damage * math.Rand(0.75, 1.25)
	local CurrentRecoil = Angle(-self.Primary.KickUp, util.SharedRandom(self:GetClass(), -self.Primary.KickHorizontal, self.Primary.KickHorizontal, 0), 0)
	local CurrentCone = self.Primary.Spread
	if self:GetPredictedAiming() then
		CurrentCone = self.Primary.IronAccuracy
		CurrentRecoil = Angle(CurrentRecoil.p / 1.5, CurrentRecoil.y / 1.5, 0)
	end
	local owner = self.Owner
	if !IsValid(owner) then return end
	if (owner:GetMoveType() != MOVETYPE_WALK or !owner:OnGround()) then
		local spread_mul = GetConVar("mg_m9k_jumppenaltymult"):GetFloat()
		CurrentCone = CurrentCone * spread_mul
		CurrentRecoil = Angle(CurrentRecoil.pitch * spread_mul, CurrentRecoil.yaw * spread_mul, CurrentRecoil.roll * spread_mul)
	end
	CurrentCone = hook.Run("M9K_ConeMultiplier", self, CurrentCone) or CurrentCone
	CurrentRecoil = hook.Run("M9K_RecoilMultiplier", self, CurrentRecoil) or CurrentRecoil
	if self:GetPredictedAiming() then
		self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, CurrentCone)
	else
		self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, CurrentCone)
	end
end

function SWEP:ShootBullet(Damage, Recoil, NumBullets, Cone)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if self.WorldMuzzleFlashes then
		self.Owner:MuzzleFlash()
	end
	if self:GetSilenced() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		self:EmitSound(self.Primary.Sound_Silenced, self.Primary.SoundLevel)
	else
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel)
	end
	NumBullets = NumBullets or 1
	Cone = Cone * (GetConVar("mg_m9k_spreadmultiplicator"):GetFloat() or 1)
	local Bullet = {}
	Bullet.Num = NumBullets
	Bullet.Src = self.Owner:GetShootPos()
	Bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	Bullet.Spread = Vector(Cone, Cone, 0)
	Bullet.Tracer = self.Tracer or 1
	Bullet.TracerName = self.TracerName or "Tracer"
	Bullet.Force = Damage * 0.1
	Bullet.Damage = Damage
	self.Owner:FireBullets(Bullet)
	if !IsValid(self.Owner) or !self.Owner.ViewPunch then return end
	local recoil_mult = GetConVar("mg_m9k_recoilmultiplicator"):GetFloat()
	Recoil = Angle(Recoil.pitch * (recoil_mult or 1), Recoil.yaw * (recoil_mult or 1), Recoil.roll)
	self.Owner:ViewPunch(Recoil)
	if !GetConVar("mg_m9k_dynamicrecoil"):GetBool() then return end
	if ((game.SinglePlayer() and SERVER) or (!game.SinglePlayer() and CLIENT and IsFirstTimePredicted())) then
		self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Recoil * 0.75)
	end
	hook.Run("M9K_ShootBullet", self, Damage, Recoil, NumBullets, Cone)
end

function SWEP:Reload()
	if self.CanReload then
		if self:GetDrawAnim() <= CurTime() and !self:GetReloading() and !self:GetSilencing() then
			if (!self.Owner:IsNPC() and (self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0)) then return end
			if (self.CanLower or self.CanSelectFire) and self.Owner:KeyDown(IN_USE) then return end
			if self:GetPredictedAiming() then
				self:RemoveIronSights()
			end
			if self:GetPredictedRunning() then
				self:StopRunning()
			end
			if self:GetSilenced() then
				self:SendWeaponAnim(self.ReloadAnim_Silenced)
			else
				self:SendWeaponAnim(self.ReloadAnim)
			end
			self.Owner:SetAnimation(PLAYER_RELOAD)
			self:SetReloading(true)
			local reload_speed = self.ReloadSpeed
			reload_speed = hook.Run("M9K_ReloadMultiplier", self, reload_speed) or reload_speed
			local seq_duration = self:SequenceDuration()
			local ReloadingTimer = seq_duration / reload_speed
			if reload_speed != 1 and !self.Owner:IsNPC() then
				local vm = self.Owner:GetViewModel()
				if IsValid(vm) then
					vm:SetPlaybackRate(1 * reload_speed) 
				end
			end
			self:SetReloadingTimer(CurTime() + ReloadingTimer)
			self:SetNextPrimaryFire(CurTime() + ReloadingTimer)
			self:SetNextSecondaryFire(CurTime() + ReloadingTimer)
		end
	end
end

function SWEP:Silence(self_tbl, self_dt)
	local owner = self:GetOwner()
	if !owner:IsValid() then return end
	if self_tbl.CanSilence then
		if self_dt.DrawAnim <= CurTime() and !self_dt.Reloading and !self_dt.Silencing then
			if owner:KeyDown(IN_USE) and owner:KeyPressed(IN_ATTACK2) then
				if self:GetPredictedAiming() then
					self:RemoveIronSights()
				end
				if self:GetPredictedRunning() then
					self:StopRunning()
				end
				if self_dt.Silenced then
					self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
				else
					self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
				end
				self_dt.Silencing = true
				local silence_speed = self_tbl.SilenceSpeed
				local seq_duration = self:SequenceDuration()
				local SilencingTimer = seq_duration / silence_speed
				if silence_speed != 1 and !owner:IsNPC() then
					local vm = owner:GetViewModel()
					if vm:IsValid() then
						vm:SetPlaybackRate(1 * silence_speed) 
					end
				end
				self_dt.SilencingTimer = CurTime() + SilencingTimer
			end
		end
	end
end

function SWEP:CheckReloading(self_tbl, self_dt)
	local owner = self:GetOwner()
	if !owner:IsValid() then return end
	if self_dt.Reloading then
		if self:GetPredictedAiming() then
			self:SetAiming(false)
		end
		if self_dt.ReloadingTimer < CurTime() then
			local MaxClip = self_tbl.Primary.ClipSize
			local Clip = self:Clip1()
			local AmmoCount = owner:GetAmmoCount(self_tbl.Primary.Ammo)
			owner:RemoveAmmo(math.Clamp(MaxClip - Clip, 0, AmmoCount), self_tbl.Primary.Ammo)
			self:SetClip1(math.Clamp(MaxClip, 0, Clip + AmmoCount))
			self_dt.Reloading = false
		end
	end
end

function SWEP:CheckSilencing(self_tbl, self_dt)
	if self_dt.Silencing then
		if self:GetPredictedAiming() then
			self_dt.Aiming = false
		end
		if self_dt.SilencingTimer < CurTime() then
			if self_dt.Silenced then
				self_dt.Silenced = false
				self_tbl.CSMuzzleX = false
			else
				self_dt.Silenced = true
				self_tbl.CSMuzzleX = true
			end
			self_dt.Silencing = false
		end
	end
end

if CLIENT then
	SWEP.QueueLowerAnim = 0
end
function SWEP:ApplySafeMode(newmode, prevmode)
	if newmode == MODE_SAFE or prevmode == MODE_SAFE then
		if newmode == MODE_SAFE then
			if CLIENT and IsFirstTimePredicted() then
				if self:GetPredictedAiming() or self:GetPredictedRunning() or self.NextAllowedAim > CurTime() or self.NextAllowedRun > CurTime() then
					self.QueueLowerAnim = CurTime() + 0.3
				end
			end
			self:SetAiming(false)
			self:SetRunning(false)
		end
		if prevmode == MODE_SAFE then
			self.NextAllowedAim = CurTime() + 0.3
			self.NextAllowedRun = CurTime() + 0.3
		end
		if self:GetNextPrimaryFire() < (CurTime() + 0.3) then
			self:SetNextPrimaryFire(CurTime() + 0.3)
		end
	end
end

function SWEP:ApplyFireMode(prevmode)
	local newmode = self:GetFireMode()
	if IsFirstTimePredicted() then
		if newmode == MODE_AUTO then
			self.Primary.Automatic = true
		elseif newmode == MODE_SEMI then
			self.Primary.Automatic = false
		end
	end
	self:ApplySafeMode(newmode, prevmode)
end

function SWEP:DecideFireMode(override)
	local mode = self:GetFireMode()
	if IsFirstTimePredicted() then
		if override then
			self:SetFireMode(override)
		elseif self.CanSelectFire then
			local nextmode = self.DefaultFireMode and (mode == MODE_AUTO and MODE_SEMI or mode == MODE_SEMI and (self.CanLower and MODE_SAFE or MODE_AUTO) or mode == MODE_SAFE and MODE_AUTO) or (mode == MODE_SEMI and MODE_AUTO or mode == MODE_AUTO and (self.CanLower and MODE_SAFE or MODE_SEMI) or mode == MODE_SAFE and MODE_SEMI)
			if !nextmode then return end
			self:SetFireMode(nextmode)
		else
			local nextmode = mode == MODE_SAFE and (self.DefaultFireMode and MODE_AUTO or MODE_SEMI) or MODE_SAFE
			if !nextmode then return end
			self:SetFireMode(nextmode)
		end
	end
	self:ApplyFireMode(mode)
end

function SWEP:DrawFireModeMessage()
	local mode = self:GetFireMode()
	self.Owner:PrintMessage(HUD_PRINTTALK, mode == MODE_AUTO and self.Translations.AutomaticSelected or mode == MODE_SEMI and self.Translations.SemiSelected or self.Translations.LoweredWeapon)
end

function SWEP:SelectFireMode(self_tbl, self_dt)
	local owner = self:GetOwner()
	if !owner:IsValid() then return end
	if self_dt.NextFireSelect <= CurTime() then
		local mode = self_dt.FireMode
		if (self_dt.DrawAnim > CurTime() or self_dt.Reloading or self_dt.Silencing) and mode != MODE_SAFE then return end
		if owner:KeyDown(IN_USE) and owner:KeyPressed(IN_RELOAD) then
			local is_singleplayer = game.SinglePlayer()
			if is_singleplayer and SERVER or !is_singleplayer then
				self:DecideFireMode()
				self_dt.NextFireSelect = CurTime() + 0.3
				if self_tbl.CanSelectFire and self_dt.FireMode != MODE_SAFE then
					self:EmitSound("Weapon_AR2.Empty")
				end
			end
			if IsFirstTimePredicted() and (CLIENT or is_singleplayer) then
				self:DrawFireModeMessage()
			end
		end
	end
end

function SWEP:BeginRunning()
	if self.NextAllowedRun > CurTime() then return end
	if self:GetPredictedAiming() then self:RemoveIronSights() return end
	if !self.NoRunningCooldown then
		if self:GetNextPrimaryFire() < (CurTime() + 0.3) then
			self:SetNextPrimaryFire(CurTime() + 0.3)
		end
		if self:GetNextSecondaryFire() < (CurTime() + 0.3) then
			self:SetNextSecondaryFire(CurTime() + 0.3)
		end
	end
	self:SetRunning(true)
end

function SWEP:StopRunning()
	if !self.NoRunningCooldown then
		if self:GetNextPrimaryFire() < (CurTime() + 0.3) then
			self:SetNextPrimaryFire(CurTime() + 0.3)
		end
		if self:GetNextSecondaryFire() < (CurTime() + 0.3) then
			self:SetNextSecondaryFire(CurTime() + 0.3)
		end
	end
	self:SetRunning(false)
end

function SWEP:SetIronSights()
	if self.NextAllowedAim > CurTime() then return end
	self:SetAiming(true)
end

function SWEP:RemoveIronSights()
	self:SetAiming(false)
end

function SWEP:CheckIronSights(self_tbl, self_dt)
	local owner = self:GetOwner()
	if !IsValid(owner) then return end
	local aiming = owner:KeyDown(self_tbl.AimKey)
	if aiming and !owner:KeyDown(self_tbl.RunKey) then
		if self_tbl.CanSilence and owner:KeyDown(IN_USE) then return end
		if !self:GetLowered() and !self:GetPredictedAiming() and !self:GetPredictedRunning() and !self_dt.Reloading and !self_dt.Silencing then
			self:SetIronSights()
		end
	end
	if self:GetPredictedAiming() and (!aiming or self:GetLowered()) then
		self:RemoveIronSights()
	end
end

function SWEP:CheckRunning(self_tbl, self_dt)
	local owner = self:GetOwner()
	if !owner:IsValid() then return end
	local down = owner:KeyDown(self_tbl.RunKey)
	local lowered = self:GetLowered()
	local running = self:GetPredictedRunning()
	local reloading = self_dt.Reloading
	local silencing = self_dt.Silencing
	local walking = owner:GetMoveType() == MOVETYPE_WALK
	local crouching = owner:Crouching()
	if down and !lowered and !running and !reloading and !silencing and walking and !crouching and owner:GetAbsVelocity():LengthSqr() > 2500 then
		self:BeginRunning()
	elseif running then
		if !down or lowered or reloading or silencing or !walking or crouching or (owner:GetAbsVelocity():LengthSqr() <= 2500 and owner:OnGround()) then
			self:StopRunning()
		end
	end
end

function SWEP:CheckHoldType(self_tbl, self_dt)
	local owner = self:GetOwner()
	if !owner:IsValid() then return end
	local hold_typ = self:GetHoldType()
	if self_tbl.CanLower and self:GetLowered() then
		if owner:Crouching() then
			if hold_typ != self_tbl.CrouchedLoweredHoldType then
				self:SetHoldType(self_tbl.CrouchedLoweredHoldType)
			end
		elseif hold_typ != self_tbl.LoweredHoldType then
			self:SetHoldType(self_tbl.LoweredHoldType)
		end
	elseif self_tbl.CanAim and self:GetPredictedAiming() then
		if hold_typ != self_tbl.AimHoldType then
			self:SetHoldType(self_tbl.AimHoldType)
		end
	elseif self_tbl.CanRun and self:GetPredictedRunning() then
		if hold_typ != self_tbl.RunHoldType then
			self:SetHoldType(self_tbl.RunHoldType)
		end
	elseif hold_typ != self_tbl.HoldType then
		self:SetHoldType(self_tbl.HoldType)
	end
end

if CLIENT then
	SWEP.LastAnimSysTime = 0
	SWEP.LastSwayScale = 1
	SWEP.LastBobScale = 1
end
function SWEP:ModifyClient(self_tbl, self_dt)
	local lowered = self:GetLowered()
	local running = self:GetPredictedRunning()
	local aiming = self:GetPredictedAiming()
	if lowered or running then
		if self_tbl.HasCrosshair then
			self_tbl.DrawCrosshair = false
		end
	elseif aiming then
		if self_tbl.HasCrosshair then
			if self_tbl.AimHideCrosshair  then
				self_tbl.DrawCrosshair = false
			else
				self_tbl.DrawCrosshair = true
			end
		end
	elseif self_tbl.HasCrosshair then
		self_tbl.DrawCrosshair = true
	end
	local sys_time = SysTime()
	self_tbl.SwayScale = running and Lerp((sys_time - self_tbl.LastAnimSysTime) * 10, self_tbl.LastSwayScale, 1.2) or aiming and Lerp((sys_time - self_tbl.LastAnimSysTime) * 10, self_tbl.LastSwayScale, 0.05) or Lerp((sys_time - self_tbl.LastAnimSysTime) * 10, self_tbl.LastSwayScale, 1)
	self_tbl.BobScale = running and Lerp((sys_time - self_tbl.LastAnimSysTime) * 10, self_tbl.LastBobScale, 1.6) or aiming and Lerp((sys_time - self_tbl.LastAnimSysTime) * 10, self_tbl.LastBobScale, 0.05) or Lerp((sys_time - self_tbl.LastAnimSysTime) * 10, self_tbl.LastBobScale, 1)
	self_tbl.LastSwayScale = self_tbl.SwayScale
	self_tbl.LastBobScale = self_tbl.BobScale
	self_tbl.LastAnimSysTime = sys_time
end

function SWEP:Think_MG()
	local self_tbl = self:GetTable()
	local self_dt = self_tbl.dt
	if CLIENT then
		self:ModifyClient(self_tbl, self_dt)
		self:CrosshairThink(self_tbl, self_dt)
	end
	if self_tbl.CanSilence then
		self:Silence(self_tbl, self_dt)
	end
	if self_tbl.CanAim then
		self:CheckIronSights(self_tbl, self_dt)
	end
	if self_tbl.CanRun then
		self:CheckRunning(self_tbl, self_dt)
	end
	if self_tbl.CanReload then
		self:CheckReloading(self_tbl, self_dt)
	end
	if self_tbl.CanSilence then
		self:CheckSilencing(self_tbl, self_dt)
	end
	if self_tbl.CanLower or self_tbl.CanSelectFire then
		self:SelectFireMode(self_tbl, self_dt)
	end
	self:CheckHoldType(self_tbl, self_dt)
end

function SWEP:Think()
	self:Think_MG()
end

print("[MG] Main Gun Base initialised.")