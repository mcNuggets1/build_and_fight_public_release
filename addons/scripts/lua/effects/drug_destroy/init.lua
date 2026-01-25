function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	self.Glass = data:GetRadius() or 0
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
		p:SetColor(255,255,255,155)
	end
	for i=1, math.ceil(self.Glass) == 1 and 8 or 10 do
		local p = self.Emitter:Add(math.ceil(self.Glass) == 1 and "effects/fleck_glass"..math.random(1, 3) or "effects/fleck_cement"..math.random(1, 2), self.Start)
		p:SetVelocity(Vector(math.Rand(-25, 25), math.Rand(-25, 25), math.Rand(0, 100)))
		p:SetDieTime(math.random(0.9, 1.7))
		p:SetStartAlpha(155)
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(1, 2))
		p:SetRoll(math.Rand(0, 70))
		p:SetRollDelta(math.Rand(-3, 3))
		p:SetAirResistance(240)
		p:SetColor(255, 255, 255)
		p:SetGravity(Vector(0, 0, -366))
		p:SetCollide(true)
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end