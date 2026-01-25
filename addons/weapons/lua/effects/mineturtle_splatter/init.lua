function EFFECT:Init(data)
	self.Pos = data:GetOrigin() + Vector(0, 0, 5)
	self.Emitter = ParticleEmitter(self.Pos)
	self:Smoke()
end

function EFFECT:Smoke()
	for i=1, 100 do
		local Debris = self.Emitter:Add("effects/fleck_tile"..math.random(1, 2), self.Pos)
		if Debris then
			Debris:SetVelocity(Vector(math.Rand(-350, 350), math.Rand(-350, 350), math.Rand(0, 850)))
			Debris:SetDieTime(math.Rand(5, 7.5))
			Debris:SetStartAlpha(math.Rand(200, 255))
			Debris:SetEndAlpha(0)
			Debris:SetStartSize(3)
			Debris:SetRoll(math.Rand(-360, 360))
			Debris:SetRollDelta(math.Rand(-5, 5))
			Debris:SetAirResistance(40)
			Debris:SetColor(0, 255, 0)
			Debris:SetGravity(Vector(0, 0, -600))
			Debris:SetCollide(true)
			Debris:SetBounce(0.5)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end