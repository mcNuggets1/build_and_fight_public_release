function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos)
	for i = 1, 15 do
		local fire = emitter:Add("particle/fire", pos)
		fire:SetVelocity(Vector(math.Rand(-100, 100), math.Rand(-100, 100), math.Rand(100, 1000)))
		fire:SetLifeTime(0)
		fire:SetDieTime(1)
		fire:SetColor(0, 255, 0)
		fire:SetStartAlpha(255)
		fire:SetEndAlpha(0)
		fire:SetStartSize(math.Rand(1,2))
		fire:SetEndSize(0)
		fire:SetRoll(math.Rand(-360, 360))
		fire:SetRollDelta(math.Rand(-0.21, 0.21))
		fire:SetAirResistance(math.Rand(500, 1000))
		fire:SetGravity(Vector(0, 0, -300))
		fire:SetCollide(true)
		fire:SetBounce(0.9)
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end