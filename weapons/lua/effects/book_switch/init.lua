function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	for i = 1, 25 do
		local p = self.Emitter:Add("sprites/orangeflare1", self.Start)
		p:SetDieTime(math.Rand(1, 4))
		p:SetStartAlpha(255)
		p:SetEndAlpha(255)
		p:SetStartSize(math.Rand(4, 5))
		p:SetEndSize(0)
		p:SetAirResistance(60)
		p:SetVelocity(VectorRand() * 100)
		p:SetGravity(Vector(0, 0, -50))
		p:SetColor(255, 255, 255)
		p:SetCollide(true)
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end