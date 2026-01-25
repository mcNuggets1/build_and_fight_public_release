function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	local p = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), self.Start)
	if p then
		p:SetDieTime(math.Rand(0.75, 1))
		p:SetStartAlpha(math.Rand(25, 50))
		p:SetEndAlpha(0)
		p:SetStartSize(1)
		p:SetEndSize(5)
		p:SetRoll(math.Rand(-2, 2))
		p:SetRollDelta(math.Rand(-1, 1))
		p:SetVelocity(Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(5, 25)))
		p:SetColor(255, 100, 0, 100)
	end
	local g = self.Emitter:Add("sprites/orangeflare1", self.Start)
	if g then
		g:SetDieTime(math.Rand(0.9, 1.1))
		g:SetStartAlpha(math.Rand(25, 35))
		g:SetEndAlpha(0)
		g:SetStartSize(1)
		g:SetEndSize(0)
		g:SetRoll(math.Rand(-2, 2))
		g:SetRollDelta(math.Rand(-1, 1))
		g:SetVelocity(Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(10, 30)))
		g:SetColor(255, 200, 0, 255)
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end