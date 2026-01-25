local gravity = Vector(0, 0, 50)
local offset = Vector(0, 0, 10)
local velocity = Vector(0, 0, 1.1)
local dietime = 0.9

function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)

	local particle = emitter:Add("sprites/music", pos + offset)
	particle:SetVelocity(velocity * math.random(15, 30))
	particle:SetDieTime(dietime)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(3)
	particle:SetEndSize(1.5)
	particle:SetRoll(math.random(-8, 8))
	particle:SetRollDelta(math.random(-0.2, 0.2))
	particle:SetColor(255, 255, 255)
	particle:SetCollide(false)

	particle:SetGravity(gravity)

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end