function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	self.Big = data:GetScale()
	if math.ceil(self.Big) > 0 then
		for i = 1, 75 do
			local w = self.Emitter:Add("effects/spark", self.Start)
			if w then
				w:SetVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(0, 170)))
				w:SetDieTime(1.5)
				w:SetStartAlpha(255)
				w:SetEndAlpha(0)
				w:SetStartSize(1)
				w:SetEndSize(0)
				w:SetRoll(math.Rand(0, 360))
				w:SetRollDelta(math.Rand(-5, 5))
				w:SetAirResistance(70)
				w:SetGravity(Vector(0, 0, -600))
				w:SetCollide(true)
				w:SetBounce(0.6)
			end
		end
	else
		local p = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), self.Start)
		if p then
			p:SetDieTime(math.Rand(0.7, 1.3))
			p:SetStartAlpha(math.Rand(50, 100))
			p:SetEndAlpha(0)
			p:SetStartSize(math.random(3, 5))
			p:SetEndSize(math.Rand(10, 20))
			p:SetRoll(math.Rand(-0.5, 0.5))
			p:SetRollDelta(math.Rand(-0.1, 0.1))
			p:SetVelocity(Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(-2, 3)))
			p:SetColor(255, 255, 255, 155)
		end
		for i = 1, 10 do
			local w = self.Emitter:Add("effects/spark", self.Start)
			if w then
				w:SetVelocity(Vector(math.Rand(-35, 35), math.Rand(-35, 35), math.Rand(0, 100)))
				w:SetDieTime(0.5)
				w:SetStartAlpha(255)
				w:SetEndAlpha(0)
				w:SetStartSize(1)
				w:SetEndSize(0)
				w:SetRoll(math.Rand(0, 360))
				w:SetRollDelta(math.Rand(-5, 5))
				w:SetAirResistance(70)
				w:SetGravity(Vector(0, 0, -600))
				w:SetCollide(true)
				w:SetBounce(0.6)
			end
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end