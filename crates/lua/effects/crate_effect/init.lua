function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

local particleDelay = 0.04
function EFFECT:Think()
	if IsValid(self.Entity) then
		local pos = self.Entity:GetPos()
		self.Emitter:SetPos(pos)
		local particle
		local ppos = Vector(math.Rand(-22, 22), math.Rand(-22, 22), math.Rand(-18, -13))
		if !self.NextParticle or self.NextParticle < CurTime() then
			particle = self.Emitter:Add("effects/yellowflare", pos + ppos)
			self.NextParticle = CurTime() + particleDelay
		end
		ppos.z = 0
		ppos:Normalize()
		if particle then
			particle:SetVelocity(Vector(ppos.x, ppos.y, math.Rand(40, 60)))
			particle:SetDieTime(math.Rand(1.2, 1.6))
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(0)
			particle:SetStartSize(1)
			particle:SetEndSize(0.1)
			particle:SetGravity(Vector(0, 0, 0))
			particle:SetBounce(0)
		end
		return true
	else
		self.Emitter:Finish()
	end
	return false
end

function EFFECT:Render()
end