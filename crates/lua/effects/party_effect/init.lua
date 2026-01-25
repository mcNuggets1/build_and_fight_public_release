function EFFECT:Init(data) 	
	self.Pos = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Pos)
end  

function EFFECT:Think()		
	local pos = self.Pos
	self.Emitter:SetPos(pos)
	for i=1, 100 do
		local particle = self.Emitter:Add("effects/spark", pos + Vector(math.random(-5, 5), math.random(-5, 5), math.random(25, 35))) 
		if particle then
			particle:SetVelocity(Vector(math.Rand(-150, 150), math.Rand(-150, 150), math.Rand(100, 250)))
			particle:SetLifeTime(0)
			particle:SetDieTime(math.Rand(4, 6))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			local size = math.random(2, 3)
			particle:SetStartSize(size)
			particle:SetEndSize(size)
			particle:SetRollDelta(math.random(-20, 20))
			particle:SetColor(math.random(100, 255), math.random(100, 255), math.random(100, 255))
			particle:SetGravity(Vector(0, 0, -math.Rand(170, 210)))
			particle:SetCollide(true)
			particle:SetAirResistance(200)
			particle:SetBounce(0.3)
		end
	end
	self.Emitter:Finish()
	return false
end

function EFFECT:Render()
end