local mat
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local hitnormal = data:GetNormal()
	local emitter = ParticleEmitter(pos)
	for i = 1, math.random(150, 200) do
		mat = mat or Material("icon16/lightning.png")
		local particle = emitter:Add(mat, pos + hitnormal)
		if particle then
			particle:SetVelocity(hitnormal + (VectorRand():GetNormalized() * math.Rand(100, 400)))
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(1, 3))	
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(2)
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(-360, 360))
			particle:SetRollDelta(math.Rand(-10, 10))
			particle:SetAirResistance(100)
			particle:SetGravity(Vector(0, 0, -math.Rand(40, 60)))
			particle:SetCollide(true)
			particle:SetBounce(1)
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end