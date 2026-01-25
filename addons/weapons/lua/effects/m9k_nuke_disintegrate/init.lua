function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.Angle = data:GetNormal()
	self.Angle.z = 0.4*self.Angle.z
	local Emitter = ParticleEmitter(self.Position)
	for i=1,50 do
		local Antlion = Emitter:Add("effects/fleck_antlion"..math.random(1,2), self.Position + Vector(math.Rand(-8,8),math.Rand(-8,8),math.Rand(-32,32)))
		Antlion:SetVelocity(self.Angle*math.Rand(256,385) + VectorRand()*64)
		Antlion:SetLifeTime(math.Rand(-0.3, 0.1))
		Antlion:SetDieTime(math.Rand(0.7, 1))
		Antlion:SetStartAlpha(255)
		Antlion:SetEndAlpha(0)
		Antlion:SetStartSize(math.Rand(1.5, 1.7))
		Antlion:SetEndSize(math.Rand(1.8, 2))
		Antlion:SetRoll(math.Rand(360, 520))
		Antlion:SetRollDelta(math.Rand(-2, 2))
		Antlion:SetColor(30, 30, 30)
	end
	for i=1,20 do
		local Smoke = Emitter:Add("particles/smokey", self.Position + Vector(math.Rand(-8,9),math.Rand(-8,8),math.Rand(-32,32)) - self.Angle*8)
		Smoke:SetVelocity(self.Angle*math.Rand(256,385) + VectorRand()*64)
		Smoke:SetDieTime(math.Rand(0.4, 0.8))
		Smoke:SetStartAlpha(255)
		Smoke:SetEndAlpha(0)
		Smoke:SetStartSize(math.Rand(8, 12))
		Smoke:SetEndSize(math.Rand(24, 32))
		Smoke:SetRoll(math.Rand(360, 520))
		Smoke:SetRollDelta(math.Rand(-2, 2))
		Smoke:SetColor(20, 20, 20)
	end
	Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end