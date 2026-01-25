function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Emitter = ParticleEmitter(self.Pos)
	self:Smoke()
end

function EFFECT:Smoke()
	for i=0, 10*self.Scale do
		local Smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9), self.Pos)
		if Smoke then
			Smoke:SetVelocity(VectorRand():GetNormalized()*math.Rand(125,150)*self.Scale)
			local scale = ((self.Scale <= 0.11 and self.Scale * 10) or self.Scale)
			Smoke:SetDieTime(3 * scale)
			local scale = ((self.Scale <= 0.11 and self.Scale * 0.15) or self.Scale)
			Smoke:SetStartAlpha(100 * scale)
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(50)
			Smoke:SetEndSize(100)
			Smoke:SetRoll(math.Rand(0, 60))
			Smoke:SetRollDelta(math.Rand(-0.1, 0.1))
			Smoke:SetAirResistance(200)
			Smoke:SetGravity(Vector(math.Rand(-25, 25), math.Rand(-25, 25), math.Rand(-25, -250)))
			Smoke:SetColor(155,155,155)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end