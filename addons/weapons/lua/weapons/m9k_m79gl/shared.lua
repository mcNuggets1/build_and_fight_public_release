SWEP.Category = "M9K Specialties"
SWEP.PrintName = "M79 GL"
SWEP.DrawCrosshair = false
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Weight = 70
SWEP.HoldType = "shotgun"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m79_grenadelauncher.mdl"
SWEP.WorldModel = Model("models/weapons/w_m79_grenadelauncher.mdl")
SWEP.Base = "mg_shotgun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("40mmGrenade.Single")
SWEP.Primary.RPM = 100
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "m79_nade"
SWEP.Primary.Round = "m9k_launched_m79"
SWEP.ShellTime = 0.5
SWEP.CanAim = false
SWEP.RunSightsPos = Vector(3.279, -5.574, 0)
SWEP.RunSightsAng = Vector(-1.721, 49.917, 0)
SWEP.WeaponType = "rpg"

function SWEP:AddDeploy()
	if SERVER then
		self:CheckWeaponsAndAmmo(0)
	end
end

function SWEP:PrimaryAttack()
	if self:GetLowered() then return end
	if self:CanPrimaryAttack() and !self:GetRunning() and !self:GetPredictedRunning() and !self:GetReloading() then
		if !self.FiresUnderWater then
			if self.Owner:WaterLevel() > 2 then
				return
			end
		end
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:MuzzleFlash()
		self:TakePrimaryAmmo(1)
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self.Owner:ViewPunch(Angle(-3, util.SharedRandom(self:GetClass(), -0.5, 0.5, 0), 0))
		if SERVER then
			self:FireGrenade()
			self:CheckWeaponsAndAmmo(self:SequenceDuration() * 0.25)
		end
	end
end

function SWEP:FireGrenade()
	local aim = self.Owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	local pos = self.Owner:GetShootPos() + side * 6 + up * -5
	local grenade = ents.Create(self.Primary.Round)
	if !IsValid(grenade) then return end
	grenade:SetAngles(aim:Angle() + Angle(90, 0, 0))
	grenade:SetPos(pos)
	grenade:SetOwner(self.Owner)
	grenade:Spawn()
	grenade:Activate()
end

function SWEP:CheckWeaponsAndAmmo(Wait)
	if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0) then
		timer.Simple(Wait, function()
			if !IsValid(self) then return end
			MG_RemoveWeapon(self)
		end)
	end
end

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end