SWEP.Category = "M9K Shotguns"
SWEP.PrintName = "Double Barrel-Shotgun"
SWEP.Slot = 3
SWEP.SlotPos = 5
SWEP.Weight	= 40
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_doublebarrl.mdl"
SWEP.WorldModel = Model("models/weapons/w_double_barrel_shotgun.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.Primary.Sound = Sound("Double_Barrel.Single")
SWEP.Primary.RPM = 285
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.KickUp	= 6
SWEP.Primary.KickHorizontal	= 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.ShellTime = 0.5
SWEP.Primary.NumShots = 10
SWEP.Primary.Damage	= 7.4
SWEP.Primary.Spread = 0.08
SWEP.CanAim = false
SWEP.SightsPos = Vector(0, 0, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(10, -5, -2.787)
SWEP.RunSightsAng = Vector(0.574, 51.638, 5.737)
SWEP.WeaponType = "shotgun"

function SWEP:SecondaryAttack()
	if self:GetLowered() then return end
	if self:CanSecondaryAttack() and !self:GetRunning() and !self:GetPredictedRunning() and !self:GetReloading() and !self:GetSilencing() then
		if !self.FiresUnderWater then
			if IsValid(self.Owner) and self.Owner:WaterLevel() > 2 then
				return
			end
		end
		if (self:Clip1() >= 2) then
			self.Primary.Sound = Sound("DBarrel_DBlast")
			self.Primary.KickUp	= self.Primary.KickUp * 2.5
			self.Primary.KickHorizontal	= self.Primary.KickHorizontal *  2.5
			self.Primary.NumShots = self.Primary.NumShots * 2
			self.Primary.Spread = self.Primary.Spread * 1.25
			self:ShootBulletInformation()
			self.Primary.Sound = Sound("Double_Barrel.Single")
			self.Primary.KickUp	= self.Primary.KickUp / 2.5
			self.Primary.KickHorizontal	= self.Primary.KickHorizontal / 2.5
			self.Primary.NumShots = self.Primary.NumShots / 2
			self.Primary.Spread = self.Primary.Spread / 1.25
			self:TakePrimaryAmmo(2)
			if SERVER then
				self:CheckWeaponsAndAmmo(0)
			end
			self:SetNextSecondaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		elseif (self:Clip1() <= 1) then
			self:PrimaryAttack()
		end
	end
end

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end