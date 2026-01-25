if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	language.Add("electric_ammo", "Elektrischegeladene Patronen")
end

game.AddAmmoType({name = "electric", dmgtype = DMG_BULLET})

SWEP.PrintName = "Desorientierungspistole"
SWEP.Instructions = "Desorientiert Ziele. Wie nützlich, oder?"
SWEP.Author = "Modern Gaming"
SWEP.Category = "Legendäre Waffen"
SWEP.Spawnable = true
SWEP.Base = "weapon_basekit"
SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 0.14
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Cone = 0.015
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "electric"
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.ViewModelFOV = 65
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")
SWEP.ShowWorldModel = false
SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.IsGun = true

SWEP.WeaponType = "pistol"

SWEP.VElements = {
	["alyx"] = {type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2.55, -5), angle = Angle(5, 190, 190), size = Vector(1.66, 1.66, 1.66), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

SWEP.WElements = {
	["alyx"] = {type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 2.55, -5), angle = Angle(5, 190, 190), size = Vector(1.66, 1.66, 1.66), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1.3)
	BaseClass.Initialize(self)
end

local usp = Sound("weapons/usp/usp1.wav")
function SWEP:PrimaryAttack()
	if (!IsValid(self.Owner) or self.Owner:WaterLevel() > 2 or !self:CanPrimaryAttack()) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()
	self.Owner:ViewPunch(Angle(util.SharedRandom(self:GetClass(), -1, -self.Primary.Recoil, 0) * self.Primary.Cone * 40, util.SharedRandom(self:GetClass(), -1, self.Primary.Recoil, 0) * self.Primary.Cone * 40, 0))
	self:EmitSound(usp)
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	bullet.Spread = Vector(self.Primary.Cone, self.Primary.Cone, 0)
	bullet.Tracer = 2
	bullet.Force = 1
	bullet.Damage = self.Primary.Damage * math.Rand(0.75, 1.25)
	bullet.Callback = function(att, tr, dmginfo)
		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			local ent = tr.Entity
			if !tr.HitWorld and IsValid(ent) then
				if ent:IsPlayer() and ent.IsBuilder and ent:IsBuilder() or ent.SP_GodModeActive or ent.SZ_Protected then return end
				local edata = EffectData()
				edata:SetEntity(ent)
				edata:SetMagnitude(3)
				edata:SetScale(2)
				util.Effect("TeslaHitBoxes", edata)
				ent:EmitSound("weapons/stunstick/spark"..math.random(1,3)..".wav")
				if SERVER and ent:IsPlayer() then
					local eyeang = ent:EyeAngles()
					local j = 10
					eyeang.pitch = math.Clamp(eyeang.pitch + math.Rand(-j, j), -90, 90)
					eyeang.yaw = math.Clamp(eyeang.yaw + math.Rand(-j, j), -90, 90)
					ent:SetEyeAngles(eyeang)
				end
			end
		end
	end
	self.Owner:FireBullets(bullet)
	self:TakePrimaryAmmo(1)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if !IsValid(self.Owner) or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or self:Clip1() == self.Primary.DefaultClip then return end
	self:EmitSound(self.ReloadSound)
	return self.BaseClass.Reload(self)
end