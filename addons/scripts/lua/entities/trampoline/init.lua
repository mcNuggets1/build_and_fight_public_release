AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Boing()
	local seq = self:LookupSequence("bounce")
	if (seq == -1) then return end
	self:ResetSequence(seq)
end

function ENT:Initialize()
	self:SetModel("models/gmod_tower/trampoline.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(100)
	end
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if !IsValid(ent) then return end

	local norm = data.HitNormal * -1
	local dot = self:GetUp():Dot(data.HitNormal)
	if math.abs(dot) < 0.5 then return end
	self.NextCollision = self.NextCollision or {}
	if (self.NextCollision[ent] or 0) > CurTime() then return end
	self.NextCollision[ent] = CurTime() + 0.2
 
	local scale = math.Rand(1, 1.5)
	local dist = 250 * scale
	local pitch = 100 * scale
	local mulNorm = norm * dist

	if (mulNorm.z < 0) then
		mulNorm.z = -mulNorm.z
	end

	if ent:IsPlayer() or ent:IsNPC() then
		physent = ent
	else
		physent = ent:GetPhysicsObject()
	end

	if IsValid(physent) then
		if ent:IsPlayer() then
			physent:SetPos(ent:GetPos() + Vector(0, 0, 6))
		end
		physent:SetVelocity(mulNorm)
	end

	self:OnBounce(ent, pitch)
end

function ENT:OnBounce(ent, pitch)
	ent:EmitSound("gmt/misc/boing.wav", 85, pitch)
	self:Boing()
	local stars = EffectData()
	stars:SetOrigin(ent:GetPos())
	util.Effect("trampoline_stars", stars)
	umsg.Start("TrampolineJump")
		umsg.Entity(self)
	umsg.End()
end