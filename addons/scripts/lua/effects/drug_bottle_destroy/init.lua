function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	local p = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), self.Start)
	if p then
		p:SetDieTime(math.Rand(0.8, 1.5))
		p:SetStartAlpha(math.Rand(50, 100))
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(3, 5))
		p:SetEndSize(math.Rand(10, 15))
		p:SetRoll(math.Rand(-2, 2))
		p:SetRollDelta(math.Rand(-1, 1))
		p:SetVelocity(Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(-2, 3)))
		p:SetColor(255, 255, 255, 55)
	end
	for i = 1, 30 do
		local d = self.Emitter:Add("effects/fleck_glass"..math.random(1,3), self.Start)
		if d then
			d:SetDieTime(math.Rand(3, 5))
			d:SetStartAlpha(255)
			d:SetEndAlpha(0)
			d:SetStartSize(1)
			d:SetRoll(math.Rand(0, 360))
			d:SetRollDelta(math.Rand(-15, 15))
			d:SetAirResistance(-55)
			d:SetColor(200, 200, 200)
			d:SetVelocity(Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(0, 40)))
			d:SetGravity(Vector(0, 0, -100))
			d:SetCollide(true)
			d:SetBounce(0.3)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end