function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

local particleDelay = 0.02
function EFFECT:Think()
	if IsValid(self.Entity) then
		local pos = self.Entity:GetPos()
		self.Emitter:SetPos(pos)
		local particle
		local ppos = Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-12, -18))
		if !self.NextParticle or self.NextParticle < CurTime() then
			particle = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), pos + ppos)
			self.NextParticle = CurTime() + particleDelay
		end
		ppos.z = 0
		ppos:Normalize()
		if particle then
			particle:SetVelocity(ppos * 15)
			particle:SetDieTime(math.Rand(1.4, 1.8))
			particle:SetStartAlpha(50)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(8, 10))
			particle:SetEndSize(math.Rand(16, 20))
			particle:SetRollDelta(math.Rand(-0.5, 0.5))
			particle:SetGravity(Vector(0, 0, -math.Rand(12, 16)))
		end
		return true
	else
		self.Emitter:Finish()
	end
	return false
end

function EFFECT:Render()
end