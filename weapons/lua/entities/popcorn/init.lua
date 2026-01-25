AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("Popcorn_Explosion")

function ENT:Initialize()
	self.lifetime = CurTime() + 45
	self:SetModel("models/teh_maestro/popcorn.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Think()
	if CurTime() > self.lifetime then
		self:Explode()
		return
	end
	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(colData)
	if colData.HitEntity:IsWorld() then
		local tr = util.TraceLine({
			start = colData.HitPos,
			endpos = colData.HitPos + colData.HitNormal,
			filter = self
		})
		if tr.HitSky then return end
	end
	self:Explode(colData)
end

local break_sounds = {
	Sound("physics/cardboard/cardboard_box_impact_hard1.wav"),
	Sound("physics/cardboard/cardboard_box_impact_hard2.wav"),
	Sound("physics/cardboard/cardboard_box_impact_hard3.wav"),
	Sound("physics/cardboard/cardboard_box_impact_hard4.wav"),
	Sound("physics/cardboard/cardboard_box_impact_hard5.wav"),
	Sound("physics/cardboard/cardboard_box_impact_hard6.wav"),
	Sound("physics/cardboard/cardboard_box_impact_hard7.wav")
}

function ENT:Explode(colData)
	if self.Exploded then return end
	self.Exploded = true
	self:EmitSound(break_sounds[math.random(#break_sounds)])
	local entid = self:EntIndex()
	net.Start("Popcorn_Explosion")
		net.WriteVector(self:GetPos())
		net.WriteVector(colData.HitNormal)
		net.WriteVector(colData.OurOldVelocity)
		net.WriteFloat(entid)
	net.Broadcast()
	local ent = colData.HitEntity
	if IsValid(ent) then
		ent:TakeDamage(150 * math.Rand(0.75, 1.25), self.Owner or self, self)
	end
	timer.Simple(0, function()
		SafeRemoveEntity(self)
	end)
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
end