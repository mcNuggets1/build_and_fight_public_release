local PRIMARY_DAMAGE = 28

SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AN-94"
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 40
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_rif_an_94.mdl"
SWEP.WorldModel = Model("models/weapons/w_rif_an_94.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("an94.Single")
SWEP.Primary.RPM = 400
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp	= 0.75
SWEP.Primary.KickHorizontal	= 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Damage	= PRIMARY_DAMAGE
SWEP.Primary.Spread	= 0.033
SWEP.Primary.IronAccuracy = 0.0098
SWEP.Secondary.SightsFOV = 55
SWEP.CanSelectFire = true
SWEP.SightsPos = Vector(4.552, 0, 3.062)
SWEP.SightsAng = Vector(0.93, -0.52, 0)
SWEP.RunSightsPos = Vector(-5.277, -8.584, 2.598)
SWEP.RunSightsAng = Vector(-12.954, -52.088, 0)
SWEP.WeaponType = "assault"

SWEP.BurstModeDamageMod = 0.65
SWEP.BurstModeRecoilMod = 1.4
SWEP.BurstModeAccuracyMod = 1.2
SWEP.BurstModeRPMMod = 1.2

SWEP.SpreadFireSelectedText = "Spread-Fire selected."

MODE_BURST = "burst"

function SWEP:ApplyFireMode(prevmode)
	local newmode = self:GetFireMode()
	if IsFirstTimePredicted() then
		if newmode == MODE_BURST then
			self.Primary.Automatic = false
			self.Primary.Sound = Sound("an94.double")
			self.Primary.Damage = PRIMARY_DAMAGE * self.BurstModeDamageMod
			self.Primary.NumShots = 2
			self.Primary.KickUp = self.Primary.KickUp * self.BurstModeRecoilMod
			self.Primary.KickHorizontal = self.Primary.KickHorizontal * self.BurstModeRecoilMod
			self.Primary.Spread = self.Primary.Spread * self.BurstModeAccuracyMod
			self.Primary.IronAccuracy = self.Primary.IronAccuracy * self.BurstModeAccuracyMod
			self.Primary.RPM = self.Primary.RPM / self.BurstModeRPMMod
		elseif newmode == MODE_AUTO then
			self.Primary.Automatic = true
			self.Primary.Sound = Sound("an94.single")
			self.Primary.Damage = PRIMARY_DAMAGE
			self.Primary.NumShots = 1
			self.Primary.KickUp = self.Primary.KickUp / self.BurstModeRecoilMod
			self.Primary.KickHorizontal = self.Primary.KickHorizontal / self.BurstModeRecoilMod
			self.Primary.Spread = self.Primary.Spread / self.BurstModeAccuracyMod
			self.Primary.IronAccuracy = self.Primary.IronAccuracy / self.BurstModeAccuracyMod
			self.Primary.RPM = self.Primary.RPM * self.BurstModeRPMMod
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
			local nextmode = self.DefaultFireMode and (mode == MODE_AUTO and MODE_BURST or mode == MODE_BURST and (self.CanLower and MODE_SAFE or MODE_AUTO) or mode == MODE_SAFE and MODE_AUTO) or (mode == MODE_BURST and MODE_AUTO or mode == MODE_AUTO and (self.CanLower and MODE_SAFE or MODE_BURST) or mode == MODE_SAFE and MODE_BURST)
			if !nextmode then return end
			self:SetFireMode(nextmode)
		else
			local nextmode = mode == MODE_SAFE and (self.DefaultFireMode and MODE_AUTO or MODE_BURST) or MODE_SAFE
			if !nextmode then return end
			self:SetFireMode(nextmode)
		end
	end
	self:ApplyFireMode(mode)
end

function SWEP:DrawFireModeMessage()
	local mode = self:GetFireMode()
	self.Owner:PrintMessage(HUD_PRINTTALK, mode == MODE_AUTO and self.Translations.AutomaticSelected or mode == MODE_BURST and self.SpreadFireSelectedText or self.Translations.LoweredWeapon)
end

function SWEP:PrimaryAttack()
	if self:GetLowered() then return end
	if self:CanPrimaryAttack() and !self:GetRunning() and !self:GetPredictedRunning() and !self:GetReloading() then
		if !self.FiresUnderWater then
			if IsValid(self.Owner) and self.Owner:WaterLevel() > 2 then
				return
			end
		end
		self.ForceChange = nil
		if self:GetFireMode() == "burst" and self.Primary.NumShots > self:Clip1() then
			self:DecideFireMode("auto")
			self.ForceChange = true
		end
		self:ShootBulletInformation()
		self:TakePrimaryAmmo(self.Primary.NumShots)
		if self.ForceChange then
			self:DecideFireMode("burst")
		end
		if SERVER then
			self:CheckWeaponsAndAmmo(0)
		end
		self:SetNextAttack()
	end
end

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end