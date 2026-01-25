if SERVER then
	AddCSLuaFile()
end

function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Start)
	for i = 1,25 do
		local p = self.Emitter:Add("sprites/orangeflare1", self.Start)
		p:SetDieTime(math.Rand(1, 2))
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(2)
		p:SetEndSize(0)
		p:SetVelocity(VectorRand() * 50)
		p:SetGravity(Vector(0, 0, -40))
		p:SetColor(0, 255, 0)
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end