if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Schildgranate"
SWEP.Purpose = "Granate, die ein holographisches Schild, dass Deckung bietet, errichtet!"

SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Spawnable = true
SWEP.DrawCrosshair = false
SWEP.ViewModel = "models/weapons/c_hexshield_grenade.mdl"
SWEP.WorldModel = Model("models/weapons/w_hexshield_grenade.mdl")
SWEP.UseHands =	true
SWEP.ViewModelFOV =	54

SWEP.Primary.ClipSize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo =	""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

function SWEP:SetupDataTables()
	self:NetworkVar("Vector", 0, "ShieldColor")
end

function SWEP:Initialize()
	self:SetHoldType("grenade")
	self:SetDeploySpeed(1)
	if SERVER then
		self.Events = {}
	end
end

function SWEP:Deploy()
	timer.Remove("hexshield_throw_"..self:EntIndex())
	if SERVER then
		self:SetShieldColor(Vector(self.Owner:GetInfo("cl_hexshieldcolor")))
	end
	return true
end

function SWEP:Holster()
	timer.Remove("hexshield_throw_"..self:EntIndex())
	return true
end

function SWEP:PrimaryAttack()
	if self.Thrown then return end
	self:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	timer.Create("hexshield_throw_"..self:EntIndex(), 0.07, 1, function()
		if !IsValid(self) or !IsValid(self.Owner) then return end
		self:Throw()
	end)
end

function SWEP:SecondaryAttack()
end

function SWEP:Throw()
	self.Thrown = true
	if !SERVER then return end
	local aim = self.Owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	local ent = ents.Create("hexshield_grenade")
	if !IsValid(ent) then return end
	ent:SetPos(self.Owner:GetShootPos() + side * 5 + up * -1)
	ent:SetAngles(aim:Angle() + Angle(0, -45, 0))
	ent:SetShieldColor(self:GetShieldColor())
	ent:SetOwner(self.Owner)
	ent.OwnerPlayer = self.Owner
	ent:Spawn()
	ent:Activate()
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(self.Owner:EyeAngles():Forward() * 1000)
		phys:AddAngleVelocity(Vector(0, 600, math.Rand(400, 500)))
	end
	timer.Simple(0.16, function()
		if IsValid(self) and IsValid(self.Owner) then
			self.Owner:StripWeapon(self.ClassName)
		end
	end)
end