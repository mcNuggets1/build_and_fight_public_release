if CLIENT then
	killicon.Add("weapon_rainbowpistol", "laser/killicon", color_white)
	language.Add("rainbow_ammo", "Regenbogen")
	SWEP.BounceWeaponIcon = true
	SWEP.DrawWeaponInfoBox = true
end

game.AddAmmoType({name = "rainbow", dmgtype = DMG_BULLET})

SWEP.Base = "weapon_base"
SWEP.HoldType = "revolver"
SWEP.ViewModelFOV = 65
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = Model("models/weapons/w_357.mdl")
SWEP.Category = "Legendäre Waffen"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.PrintName = "Rainbow Pistol"
SWEP.Spawnable = true
SWEP.Purpose = "Schicke deine Gegner ins Auenland!"
SWEP.Author = "Modern Gaming"
SWEP.Primary.Sound = Sound("weapons/weapon_lasershotgun/explode.wav")
SWEP.Primary.Sound2 = Sound("weapons/weapon_lasershotgun/blast.wav")
SWEP.Primary.Ammo = "rainbow"
SWEP.Secondary.Ammo = ""
SWEP.Primary.Damage = 6
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 1
SWEP.Primary.Recoil = 30
SWEP.Primary.NumShots = 25
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.IsGun = true

SWEP.WeaponType = "pistol"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1.5)
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) or !self:CanPrimaryAttack() then return end
	if self.Owner:WaterLevel() > 2 then return end
	self.Owner:ViewPunch(Angle(-self.Primary.Recoil, 0, 0))
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local bullet = {}
	bullet.Num = self.Primary.NumShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward()
	bullet.Spread = Vector(self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 1
	bullet.TracerName = "laser_tracer"
	bullet.Force = 10
	bullet.Damage = self.Primary.Damage * math.Rand(0.75, 1.25)
	self:ShootEffects()
	self:TakePrimaryAmmo(1)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:EmitSound(self.Primary.Sound2)
	self.Owner:FireBullets(bullet)
end

function SWEP:SecondaryAttack()
end

if !CLIENT then return end

function SWEP:PreDrawViewModel(vm)
	if !IsValid(vm) then return end
	vm:SetMaterial("models/worldcraft/axis_helper/axis_helper")
end

function SWEP:PostDrawViewModel(vm)
	if !IsValid(vm) then return end
	vm:SetMaterial("")
end

function SWEP:DrawWorldModel(vm)
	self:SetMaterial("models/worldcraft/axis_helper/axis_helper")
	self:DrawModel()
end

local EFFECT = {}
function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Ent = data:GetEntity()
	self.Attachment = data:GetAttachment()
	if self.GetTracerShootPos then
		self.StartPos = self:GetTracerShootPos(self.Position, self.Ent, self.Attachment)
	else
		self.StartPos = Vector(0, 0, 0)
	end
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
	self.Dir = (self.EndPos - self.StartPos):GetNormalized()
	self.Dist = self.StartPos:Distance(self.EndPos)
	self.LifeTime = 1 - (1 / self.Dist)
	self.DieTime = CurTime() + self.LifeTime
end

function EFFECT:Think()
	if (CurTime() > self.DieTime) then return false end
	return true
end

local laser = Material("laser/laser")
function EFFECT:Render()
	if !self.DieTime or !self.LifeTime then return end
	local v1 = (CurTime() - self.DieTime) / self.LifeTime
	local v2 = (self.DieTime - CurTime()) / self.LifeTime
	local a = self.EndPos - self.Dir * math.min(1 - (v1 * self.Dist), self.Dist)
	render.SetMaterial(laser)
	render.DrawBeam(a, self.EndPos, v2 * 6, 0, self.Dist / 10, Color(255, 255, 255, v2 * 255))
end

effects.Register(EFFECT, "laser_tracer")