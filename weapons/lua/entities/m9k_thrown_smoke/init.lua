AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_eq_smokegrenade_thrown.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetBuoyancyRatio(0)
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

function ENT:PhysicsCollide(data, phys)
	local vel = phys:GetVelocity()
	local len = vel:Length()
	if len > 500 then
		phys:SetVelocity(vel * 0.6)
	end
	if len > 100 then
		if CurTime() > self.NextImpact then
			self:EmitSound("weapons/smokegrenade/grenade_hit1.wav")
			self.NextImpact = CurTime() + 0.1
		end
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	local pos = self:GetPos()
	util.Decal("SmallScorch", pos, pos - Vector(0, 0, 10), self)
	local screen = ents.Create("m9k_smokescreen")
	if IsValid(screen) then
		screen:SetPos(pos)
		screen:Spawn()
		screen:CreateParticles()
	end
	self:Remove()
end

function ENT:OnTakeDamage()
	self:Explode()
end