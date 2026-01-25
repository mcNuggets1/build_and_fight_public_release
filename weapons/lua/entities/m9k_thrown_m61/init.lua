AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_m61_fraggynade_thrown.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self.TimeLeft = CurTime() + 3
	self.NextImpact = 0
end

function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	if self.TimeLeft < CurTime() then
		self:Explode()
		return
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	local pos = self:GetPos()
	local edata = EffectData()
	edata:SetOrigin(pos)
	util.Effect(self:WaterLevel() > 0 and "WaterSurfaceExplosion" or "Explosion", edata, true)
	util.BlastDamage(self, self.Owner, pos, 250, 200)
	util.ScreenShake(pos, 25, 255, 1, 1000)
	util.Decal("Scorch", pos, pos - Vector(0, 0, 10), self)
	self:Remove()
end

local grenade_bounce = Sound("HEGrenade.Bounce")
function ENT:PhysicsCollide(data, phys)
	local vel = phys:GetVelocity()
	local len = vel:Length()
	if len > 500 then
		phys:SetVelocity(vel * 0.6)
	end
	if len > 100 then
		if CurTime() > self.NextImpact then
			self:EmitSound(grenade_bounce)
			self.NextImpact = CurTime() + 0.1
		end
	end
end

function ENT:OnTakeDamage()
	self:Explode()
end