function EFFECT:Init(data)
	local particles = 30
	local emitter = ParticleEmitter(data:GetOrigin())
	for i=1, particles do
		local particle = emitter:Add("particle/fire", data:GetOrigin())
		if particle then
			particle:SetVelocity(VectorRand() * math.Rand(80, 150))
			particle:SetLifeTime(0)
			particle:SetDieTime(1.3)
			particle:SetColor(255, 190, 0)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(0.1)
			particle:SetRoll(math.Rand(-360, 360))
			particle:SetRollDelta(math.Rand(-0.21, 0.21))
			particle:SetAirResistance(math.Rand(1000, 2000))
			particle:SetGravity(Vector(0, 0, -30))
			particle:SetCollide(true)
			particle:SetBounce(0.6)
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end