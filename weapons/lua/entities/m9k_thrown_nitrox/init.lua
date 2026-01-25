AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.lifetime = CurTime() + 45
	self:SetModel("models/weapons/w_nitro.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(5)
		phys:Wake()
		phys:AddAngleVelocity(Vector(0, 500, 0))
	end
end

local bottle_break = Sound("GlassBottle.Break")
function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	if CurTime() > self.lifetime then
		self:EmitSound(bottle_break)
		self:QueueExplosion()
		return
	end
	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, phys)
	if data.HitEntity:IsWorld() then
		local tr = util.TraceLine({
			start = data.HitPos,
			endpos = data.HitPos + data.HitNormal,
			filter = self
		})
		if tr.HitSky then return end
	end
	self:QueueExplosion(data.HitNormal)
end

function ENT:QueueExplosion(normal)
	if self.Exploded then return end
	self.Exploded = true
	local pos = self:LocalToWorld(self:OBBCenter())
	timer.Simple(0, function()
		if !IsValid(self) then return end
		self:EmitSound(bottle_break)
		local vaporize = ents.Create("m9k_nitro_vapor")
		if !IsValid(vaporize) then return end
		vaporize:SetPos(pos)
		vaporize:SetOwner(self.Owner)
		vaporize.Owner = self.Owner
		vaporize:Spawn()
		vaporize:Activate()
		vaporize.Normal = normal
		self:Remove()
	end)
end

function ENT:OnTakeDamage()
	self:QueueExplosion()
end