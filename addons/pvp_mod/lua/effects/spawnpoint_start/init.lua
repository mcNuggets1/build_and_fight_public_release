function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos)
	local amount = math.random(3,5)
	local r = math.random(1,255)
	local g = math.random(1,255)
	local b = math.random(1,255)
	for i= 1,amount do
		local particle = emitter:Add("particle/fire", pos + VectorRand()*16)
		particle:SetVelocity(Vector(math.Rand(-3,3), math.Rand(-3,3), math.Rand(-1.5,3)))
		particle:SetDieTime(math.Rand(2,5))
		particle:SetStartAlpha(250)
		particle:SetEndAlpha(250)
		particle:SetStartSize(32)
		particle:SetEndSize(0)
		particle:SetRoll(math.random(0,360))
		particle:SetRollDelta(math.random(-1.5,1.5))
		particle:SetColor(r,g,b)	
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end