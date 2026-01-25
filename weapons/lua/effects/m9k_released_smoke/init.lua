function EFFECT:Init(data)
	local pos = data:GetOrigin()
	self.Emitter = ParticleEmitter(pos)
	self.Length = data:GetScale()
	for i=1, 30 do
		local rpos = VectorRand() * 75
		rpos.z = rpos.z + 60
		local smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), pos + rpos)
		if smoke then
			smoke:SetColor(150, 150, 150)
			smoke:SetStartAlpha(255)
			smoke:SetEndAlpha(0)
			smoke:SetVelocity(VectorRand() * math.Rand(1000, 1500))
			smoke:SetDieTime(self.Length + 7.5)
			smoke:SetStartSize(math.Rand(225, 250))
			smoke:SetEndSize(math.Rand(100, 125))
			smoke:SetRoll(math.Rand(-180, 180))
			smoke:SetRollDelta(math.Rand(-0.1, 0.1))
			smoke:SetAirResistance(600)
			smoke:SetCollide(true)
			smoke:SetBounce(0.4)
			smoke:SetLighting(false)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end