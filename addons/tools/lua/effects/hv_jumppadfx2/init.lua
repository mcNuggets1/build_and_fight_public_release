function EFFECT:Init(data)
	self.pos = data:GetOrigin()
	self.velocity = data:GetStart()
	if !self.velocity then return end
	self.angle = self.velocity:Angle()
	self.jumppad = data:GetEntity()
	self.color = self.jumppad.GetEffectColor and self.jumppad:GetEffectColor()*255 or Vector(255, 170, 0)
	self.gravity = -GetConVar("sv_gravity"):GetInt()
	self.pDieTime = self.velocity:Length()/1000
	self.Emitter = ParticleEmitter(self.pos)	
	self.DieTime = CurTime() + 0.3
	debugoverlay.Line(self.pos, self.pos+self.angle:Forward()*100, 0.22, Color(255,0,0), true)
	debugoverlay.Cross(self.pos+self.angle:Forward()*100, 4, 0.22, Color(0,255,0), true)
	self.nextthink = CurTime()
end

function EFFECT:Think()
	if !self.Emitter then return end
	if self.nextthink < CurTime() then
		local particle = self.Emitter:Add("sprites/ut2k4/flashflare1", self.pos - (self.velocity:GetNormal() * 20) + Vector(math.Rand(-10, 10), math.Rand(-10, 10), math.Rand(-10, 10)))
		if particle then
			particle:SetVelocity(self.velocity / 80)
			particle.velocity = self.velocity / 1
			particle.g = self.gravity / (self.pDieTime < 1 and (self.pDieTime * 8) or 1)
			particle:SetStartLength(30)
			particle:SetStartLength(100)
			particle:SetDieTime(math.Clamp(self.pDieTime, 1, 1.6))
			particle:SetStartAlpha(255)
			particle:SetStartSize(5)
			particle:SetEndAlpha(1)
			particle:SetEndSize(1)
			particle:SetNextThink(CurTime())
			particle:SetThinkFunction(function(pa)
				local frac = pa:GetLifeTime() / pa:GetDieTime()
				pa:SetGravity(Vector(pa.velocity.x, pa.velocity.y, Lerp(frac, pa.velocity.z, pa.g)))
				pa:SetNextThink(CurTime())
			end)
			particle:SetColor(self.color[1], self.color[2], self.color[3])
			particle:SetAngles(Angle(77, 154, 45))
		end
		self.nextthink = CurTime()+ 0.05
	end
	if self.DieTime > CurTime() then
		return true
	else
		self.Emitter:Finish()
		return false
	end
end

function EFFECT:Render()	
end