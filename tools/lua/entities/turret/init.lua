AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self.Firing = false
	self.NextShot = 0
end

function ENT:SetDamage(f)
	self.Damage = f
end

function ENT:GetDamage()
	return self.Damage
end

function ENT:SetDelay(f)
	self.Delay = f
end

function ENT:GetDelay()
	return self.Delay
end

function ENT:SetForce(f)
	self.Force = f
end

function ENT:GetForce()
	return self.Force
end

function ENT:SetNumBullets(f)
	self.NumBullets = f
end

function ENT:GetNumBullets(f)
	return self.NumBullets
end

function ENT:SetSpread(f)
	self.Spread = Vector(f, f, 0)
end

function ENT:GetSpread()
	return self.Spread
end

function ENT:SetToggle(b)
	self.Toggle = b
end

function ENT:GetToggle()
	return self.Toggle
end

function ENT:SetSound(str)
	self.Sound = str
end

function ENT:GetSound()
	return self.Sound
end

function ENT:SetOn(b)
	self.Firing=b
end

function ENT:GetOn()
	return self.Firing
end

function ENT:SetTracer(trcer)
	self.Tracer = trcer
end

function ENT:GetTracer()
	return self.Tracer
end

function ENT:FireShot()
	if self.NextShot > CurTime() then return end
	self.NextShot = CurTime() + self.Delay
	if self:GetSound() then
		self:EmitSound(self:GetSound())
	end
	local Attachment = self:GetAttachment(1)
	local shootOrigin = Attachment.Pos
	local shootAngles = self:GetAngles()
	local shootDir = shootAngles:Forward()
	local bullet = {}
	bullet.Num = self:GetNumBullets()
	bullet.Src = shootOrigin
	bullet.Dir = shootDir
	bullet.Spread = self:GetSpread()
	bullet.Tracer = 1
	bullet.TracerName = self:GetTracer()
	bullet.Force = self:GetForce()
	bullet.Damage = self:GetDamage()
	bullet.Attacker = self:GetPlayer()		
	self:FireBullets(bullet)
	local edata = EffectData()
	edata:SetOrigin(shootOrigin)
	edata:SetAngles(shootAngles)
	edata:SetScale(1)
	util.Effect("MuzzleEffect", edata)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end

function ENT:Think()
	if self.Firing then
		self:FireShot()
	end
	self:NextThink(CurTime())
	return true
end

local function On(ply, ent)
	if !IsValid(ent) then return end
	if !numpad.FromButton() then
		if (ply.TurretMessage or 0) <= CurTime() then
			ply:ChatPrint("Du kannst Geschütze nicht mit der Tastatur bedienen! Benutze einen Knopf/Keypad dafür.")
			ply.TurretMessage = CurTime() + 120
		end
		return
	end
	if ent:GetToggle() then
		ent:SetOn(!ent:GetOn())
	else
		ent:SetOn(true)
	end
end

local function Off(ply, ent)
	if !IsValid(ent) then return end
	if ent:GetToggle() then return end
	if !numpad.FromButton() then
		if (ply.TurretMessage or 0) <= CurTime() then
			ply:ChatPrint("Du kannst Geschütze nicht mit der Tastatur bedienen! Benutze einen Knopf/Keypad dafür.")
			ply.TurretMessage = CurTime() + 120
		end
		return
	end
	ent:SetOn(false)
end

numpad.Register("Turret_On", On)
numpad.Register("Turret_Off", Off)