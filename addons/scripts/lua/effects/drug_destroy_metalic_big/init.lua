function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	for i = 1, 75 do
		local w = self.Emitter:Add("effects/spark", self.Start)
		if w then
			w:SetVelocity(Vector(math.Rand(-100,100), math.Rand(-100,100), math.Rand(0,170)))
			w:SetDieTime(1.5)
			w:SetStartAlpha(255)
			w:SetEndAlpha(0)
			w:SetStartSize(1)
			w:SetEndSize(0)
			w:SetRoll(math.Rand(0,360))
			w:SetRollDelta(math.Rand(-5,5))
			w:SetAirResistance(70)
			w:SetGravity(Vector(0,0,-600))
			w:SetCollide(true)
			w:SetBounce(0.6)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end