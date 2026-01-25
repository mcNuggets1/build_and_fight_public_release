EFFECT.Duration	= 0.25
EFFECT.Size = 90

function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.Normal = data:GetNormal()
	self.LifeTime = self.Duration
	local emitter = ParticleEmitter(self.Position)
	for i = 1, 20 do
		local particle = emitter:Add("meowmere/effects/glow", self.Position + self.Normal * 2)
		if particle then
			local dir = VectorRand():GetNormalized()
			particle:SetVelocity((-self.Normal + dir):GetNormalized() * math.Rand(50, 75))
			particle:SetDieTime(math.Rand(0.75, 1.25))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(200)
			particle:SetStartSize(3)
			particle:SetEndSize(0)
			particle:SetRoll(0)
			particle:SetColor(255, 125, 255)
			particle:SetGravity(Vector(0, 0, 0))
			particle:SetCollide(true)
			particle:SetBounce(1)
			particle:SetAirResistance(5)
		end
	end
	local light = DynamicLight(0)
	if light then
		light.Pos = self.Position
		light.Size = 100
		light.Decay = 256
		light.R = 255
		light.G = 125
		light.B = 255
		light.Brightness = 1
		light.DieTime = CurTime() + self.Duration
	end
	emitter:Finish()
end

function EFFECT:Think()
	self.LifeTime = self.LifeTime - FrameTime()
	return self.LifeTime > 0
end

function EFFECT:Render()
end