function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Pos)
	self:Hit()
end

local cloud_effect
function EFFECT:Hit()
	for i=1, 10 do
		cloud_effect = cloud_effect or Material("effects/fire_cloud1")
		local particle = self.Emitter:Add(cloud_effect, self.Pos)
		if particle then
			particle:SetVelocity(VectorRand() * 40)
			particle:SetColor(0, 100, 255) 
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(0.75, 1.25))
			particle:SetAngles(Angle(math.Rand(0, 360), 0, 0))
			particle:SetAngleVelocity(Angle(math.Rand(-1, 1), 0, 0))
			particle:SetStartSize(20)
			particle:SetEndSize(10)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetGravity(Vector(0, 0, 60))
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end