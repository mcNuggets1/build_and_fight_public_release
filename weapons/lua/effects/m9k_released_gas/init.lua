function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local radius = data:GetRadius()
	local magnitude = data:GetMagnitude()
	self.Emitter = ParticleEmitter(pos)
	for i=1, 150 do
		local gas = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9), pos)
		if gas then
			gas:SetVelocity(VectorRand() * (radius * 1.5))
			gas:SetDieTime(magnitude * math.Rand(1, 1.5))
			gas:SetStartAlpha(math.Rand(50, 60))
			gas:SetEndAlpha(0)
			gas:SetStartSize(math.Rand(40, 50))
			gas:SetEndSize(math.Rand(80, 100))
			gas:SetRoll(math.Rand(0, 360))
			gas:SetRollDelta(math.Rand(-0.5, 0.5))
			gas:SetColor(186, 17, 17) 
 			gas:SetAirResistance(100) 
			gas:SetCollide(true)
			gas:SetBounce(1)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end