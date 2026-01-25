if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	language.Add("cannonballs_ammo", "Kanonenbälle")
end

game.AddAmmoType({name = "cannonballs", dmgtype = DMG_BLAST})

SWEP.PrintName = "Mittelalterliche Kanone"
SWEP.Instructions = "Schiffe zerstören im 21. Jahrhundert."
SWEP.Category = "Legendäre Waffen"
SWEP.DrawCrosshair = false
SWEP.Spawnable = true
SWEP.Base = "weapon_basekit"
SWEP.Primary.Delay = 2.7
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "cannonballs"
SWEP.Primary.Recoil = 5
SWEP.Primary.Round = "cannon_ball"
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "shotgun"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = Model("models/weapons/w_shotgun.mdl")
SWEP.ViewModelFOV = 65
SWEP.IsGun = true

SWEP.VElements = {
	["cannon"] = {type = "Model", model = "models/props_phx/cannon.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 5.974, -3.603), angle = Angle(90, 0, -90), size = Vector(0.171, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["yadro"] = {type = "Model", model = "models/props_phx/misc/smallcannonball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(31.847, 0.882, -7.623), angle = Angle(0, 0, 0), size = Vector(0.398, 0.398, 0.398), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["cannon"] = {type = "Model", model = "models/props_phx/cannon.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.022, 0.595, -0.247), angle = Angle(-5.444, 0.796, 176.177), size = Vector(0.171, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	BaseClass.Initialize(self)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SetPlaybackRate(0.7)
	end
	self:SetNextPrimaryFire(CurTime() + (self:SequenceDuration() * 1.2))
	return true
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	if !IsValid(self.Owner) or self.Owner:WaterLevel() > 0 then return end
	self:EmitSound("ambient/explosions/explode_4.wav")
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:FireCannonball()
end

function SWEP:FireCannonball()
	if !IsValid(self.Owner) then return end
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:TakePrimaryAmmo(1)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()
	self.Owner:ViewPunch(Angle(-self.Primary.Recoil, util.SharedRandom(self:GetClass(), -1, 1, 0), 0))
	if !SERVER then return end
	local aim = self.Owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	local fuckthis = self.Owner:Crouching() and Vector(0, 0, 0) or up * -12
	local pos = self.Owner:GetShootPos() + side * 12 + fuckthis
	local grenade = ents.Create(self.Primary.Round)
	if !IsValid(grenade) then return end
	grenade:SetAngles(aim:Angle() + Angle(90, 0, 0))
	grenade:SetPos(pos)
	grenade:SetOwner(self.Owner)
	grenade:Spawn()
	grenade:Activate()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
	if (self:Ammo1() > 0 and self:Clip1() <= 0) then
		self.Owner:RemoveAmmo(1, self:GetPrimaryAmmoType())
		self:SetClip1(self:Clip1() + 1)
	end
end

local shoulddisable = {}
shoulddisable[6001] = true
function SWEP:FireAnimationEvent(pos, ang, event, options)
	if shoulddisable[event] then return true end
end