AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/w_sticky_grenade_thrown.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self.TimeLeft = CurTime() + 3
end

function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	if self.TimeLeft < CurTime() then
		self:Explode()
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.Weld then return end
	local hit_entity = data.HitEntity
	if hit_entity:IsWorld() then
		local tr = util.TraceLine({
			start = data.HitPos,
			endpos = data.HitPos + data.HitNormal,
			filter = self
		})
		if tr.HitSky then return end
	end
	if IsValid(hit_entity) then
		if hit_entity:IsNPC() or hit_entity:IsPlayer() then
			self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			self:SetParent(hit_entity)
			self.Normal = data.HitNormal
			self.Weld = true
		else
			phys:EnableMotion(false)
			timer.Simple(0, function()
				if !IsValid(self) or !IsValid(hit_entity) then return end
				phys:EnableMotion(true)
				constraint.Weld(self, hit_entity, 0, 0, 0, true, false)
				self.Weld = true
			end)
		end
	else
		phys:EnableMotion(false)
		self.Normal = data.HitNormal
		self.Weld = true
	end
end

function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	local pos = self:GetPos()
	local edata = EffectData()
	edata:SetOrigin(pos)
	util.Effect(self:WaterLevel() > 0 and "WaterSurfaceExplosion" or "Explosion", edata, true)
	util.BlastDamage(self, self.Owner, pos, 300, 200)
	util.ScreenShake(pos, 25, 255, 1, 1500)
	util.Decal("Scorch", pos, pos - (self.Normal and -self.Normal or Vector(0, 0, 1)) * 10, self)
	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:Explode()
end