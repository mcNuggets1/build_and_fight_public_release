SWEP.Weight	= 50
SWEP.Base = "mg_gun_base"
SWEP.BoltAction = false
SWEP.AimHideAttachments = true
SWEP.AimHideViewModel = true
SWEP.Secondary.ScopeZoom = 0
SWEP.Secondary.UseACOG = false
SWEP.Secondary.UseMilDot = false
SWEP.Secondary.UseSVD = false
SWEP.Secondary.UseParabolic = false
SWEP.Secondary.UseElcan = false
SWEP.Secondary.UseGreenDuplex = false
SWEP.Secondary.UseAimpoint = false
SWEP.Secondary.UseMatador = false
SWEP.ScopeScale = 0.5
SWEP.ReticleScale = 0.5

DEFINE_BASECLASS("mg_gun_base")

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar("Float", 4, "BoltingTimer")
	self:NetworkVar("Bool", 5, "Bolting")
end

function SWEP:DeployShared()
	BaseClass.DeployShared(self)
	if self.BoltAction then
		self:SetBolting(false)
		self:SetBoltingTimer(0)
	end
end

function SWEP:HolsterShared()
	BaseClass.HolsterShared(self)
	if self.BoltAction then
		self:SetBolting(false)
		self:SetBoltingTimer(0)
	end
end

function SWEP:InitializeScopes()
	local iScreenWidth = surface.ScreenWidth()
	local iScreenHeight = surface.ScreenHeight()
	self.ScopeTable = {}
	self.ScopeTable.l = iScreenHeight * self.ScopeScale
	self.ScopeTable.x1 = 0.5 * (iScreenWidth + self.ScopeTable.l)
	self.ScopeTable.y1 = 0.5 * (iScreenHeight - self.ScopeTable.l)
	self.ScopeTable.x2 = self.ScopeTable.x1
	self.ScopeTable.y2 = 0.5 * (iScreenHeight + self.ScopeTable.l)
	self.ScopeTable.x3 = 0.5 * (iScreenWidth - self.ScopeTable.l)
	self.ScopeTable.y3 = self.ScopeTable.y2
	self.ScopeTable.x4 = self.ScopeTable.x3
	self.ScopeTable.y4 = self.ScopeTable.y1
	self.ScopeTable.l = (iScreenHeight + 1) * self.ScopeScale
	self.QuadTable = {}
	self.QuadTable.x1 = 0
	self.QuadTable.y1 = 0
	self.QuadTable.w1 = iScreenWidth
	self.QuadTable.h1 = 0.5 * iScreenHeight - self.ScopeTable.l
	self.QuadTable.x2 = 0
	self.QuadTable.y2 = 0.5 * iScreenHeight + self.ScopeTable.l
	self.QuadTable.w2 = self.QuadTable.w1
	self.QuadTable.h2 = self.QuadTable.h1
	self.QuadTable.x3 = 0
	self.QuadTable.y3 = 0
	self.QuadTable.w3 = 0.5 * iScreenWidth - self.ScopeTable.l
	self.QuadTable.h3 = iScreenHeight
	self.QuadTable.x4 = 0.5 * iScreenWidth + self.ScopeTable.l
	self.QuadTable.y4 = 0
	self.QuadTable.w4 = self.QuadTable.w3
	self.QuadTable.h4 = self.QuadTable.h3
	self.LensTable = {}
	self.LensTable.x = self.QuadTable.w3
	self.LensTable.y = self.QuadTable.h1
	self.LensTable.w = 2 * self.ScopeTable.l
	self.LensTable.h = 2 * self.ScopeTable.l
	self.ReticleTable = {}
	self.ReticleTable.wdivider = 3.125
	self.ReticleTable.hdivider = 1.7579 / self.ReticleScale
	self.ReticleTable.x = (iScreenWidth / 2) - ((iScreenHeight / self.ReticleTable.hdivider) / 2)
	self.ReticleTable.y = (iScreenHeight / 2) - ((iScreenHeight / self.ReticleTable.hdivider) / 2)
	self.ReticleTable.w = iScreenHeight / self.ReticleTable.hdivider
	self.ReticleTable.h = iScreenHeight / self.ReticleTable.hdivider
	self.FilterTable = {}
	self.FilterTable.wdivider = 3.125
	self.FilterTable.hdivider = 1.30214814815
	self.FilterTable.x = (iScreenWidth / 2) - ((iScreenHeight / self.FilterTable.hdivider) / 2)
	self.FilterTable.y = (iScreenHeight / 2) - ((iScreenHeight / self.FilterTable.hdivider) / 2)
	self.FilterTable.w = iScreenHeight / self.FilterTable.hdivider
	self.FilterTable.h = iScreenHeight / self.FilterTable.hdivider
end

function SWEP:InitClient()
	BaseClass.InitClient(self)
	self:InitializeScopes()
	if self.Secondary.SightsFOV != 0 then
		self.Secondary.SightsFOV = 75 / self.Secondary.ScopeZoom
	end
end

function SWEP:PrimaryAttack()
	if self:GetLowered() then return end
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
		if self.BoltAction then
			if self:GetPredictedAiming() then
				self:RemoveIronSights()
			end
			self:BeginBolting()
		else
			self:SetNextAttack()
		end
	end
end

function SWEP:BeginBolting()
	self:SetBolting(true)
	self:SetBoltingTimer(CurTime() + self:SequenceDuration())
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:CheckBolting()
	if self:GetBolting() and self:GetBoltingTimer() < CurTime() then
		self:SetBolting(false)
	end
end

function SWEP:CheckIronSights()
	local owner = self.Owner
	if !IsValid(owner) then return end
	if self:GetDrawAnim() > CurTime() then return end
	local aiming = owner:KeyDown(self.AimKey)
	if aiming and !owner:KeyDown(self.RunKey) then
		if self.CanSilence and owner:KeyDown(IN_USE) then return end
		if !self:GetLowered() and !self:GetPredictedAiming() and !self:GetPredictedRunning() and !self:GetReloading() and !self:GetSilencing() and !self:GetBolting() then
			self:SetIronSights()
		end
	end
	if self:GetPredictedAiming() and (!aiming or self:GetLowered()) then
		self:RemoveIronSights()
	end
end

function SWEP:Think_MG()
	BaseClass.Think_MG(self)
	if self.BoltAction then
		self:CheckBolting()
	end
end

print("[MG] Sniper Base initialised.")