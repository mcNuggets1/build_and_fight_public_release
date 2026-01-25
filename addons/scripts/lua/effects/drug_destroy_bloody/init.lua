function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	for i=1, 50 do
		local p = self.Emitter:Add("effects/blood_core", self.Start)
		if p then
			p:SetDieTime(1)
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(15, 25))
			p:SetEndSize(math.Rand(35, 50))
			p:SetRoll(math.Rand(-5, 5))
			p:SetRollDelta(math.Rand(-0.5, 0.5))
			p:SetVelocity(Vector(math.Rand(-30, 30), math.Rand(-30, 30), math.Rand(0, 75)))
			p:SetGravity(Vector(0, 0, -125))
			p:SetColor(153, 0, 0, 255)
		end
	end
	self.Emitter:Finish()
	util.Decal("Blood", self.Start, self.Start - Vector(0, 0, 35))
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end