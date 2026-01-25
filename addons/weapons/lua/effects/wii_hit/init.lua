function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()
	self.Emitter = ParticleEmitter(self.Pos)
	self:Hit()
end

function EFFECT:Hit()
	for i=1, math.random(2, 5) do
		local particle = self.Emitter:Add("effects/fleck_tile"..math.random(1, 2), self.Pos - self.Normal)
		if particle then
			particle:SetColor(200, 200, 200, 255)
			particle:SetVelocity((VectorRand():GetNormalized() * 25 + (-self.Normal * 75)) + Vector(0, 0, math.Rand(10, 30)))
			particle:SetGravity(Vector(0, 0, -200))
			particle:SetLifeTime(0)
			particle:SetDieTime(1)
			particle:SetStartSize(1)
			particle:SetEndSize(0)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetCollide(true)
			particle:SetBounce(0.25)
			particle:SetRoll(math.pi * math.Rand(-3, 3))
			particle:SetRollDelta(math.pi * math.Rand(-5, 5))
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end