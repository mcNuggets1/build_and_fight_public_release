function EFFECT:Init(data)
	self.Entity = data:GetEntity()
	self.Pos = data:GetOrigin()
	self.Emitter = ParticleEmitter(self.Pos)
	if data:GetScale() == 1 then
		self:RingBlast()
	else
		local Pincher = self.Emitter:Add("pincher.vmt", self.Pos)
		if Pincher then
			Pincher:SetDieTime(2)
			Pincher:SetStartAlpha(255)
			Pincher:SetEndAlpha(255)
			Pincher:SetStartSize(1)
			Pincher:SetEndSize(2000)
			Pincher:SetRoll(0)
			Pincher:SetRollDelta(0)
 			Pincher:SetAirResistance(0) 
			Pincher:SetCollide(false)
			Pincher:SetBounce(0)
		end
		timer.Simple(2, function()
			if !IsValid(self.Pos) then return end
			local Emitter = ParticleEmitter(self.Pos)
			local Bulge = Emitter:Add("effects/strider_bulge_dudv.vmt", self.Pos)
			if Bulge then
				Bulge:SetDieTime(.25)
				Bulge:SetStartAlpha(255)
				Bulge:SetEndAlpha(255)
				Bulge:SetStartSize(5000)
				Bulge:SetEndSize(1)
				Bulge:SetRoll(0)
				Bulge:SetRollDelta(0)
				Bulge:SetAirResistance(0) 
				Bulge:SetCollide(false)
				Bulge:SetBounce(0)
			end
			Emitter:Finish()
		end)
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

function EFFECT:RingBlast()
	for i=1, 300 do
		local Smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9), self.Pos)
		if Smoke then
			Smoke:SetVelocity(Vector(math.Rand(-10,10),math.Rand(-10,10),0):GetNormal() * 10000)
			Smoke:SetDieTime(2.5)
			Smoke:SetStartAlpha(math.Rand(40, 60))
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(math.Rand(100,150))
			Smoke:SetEndSize(math.Rand(300,350))
			Smoke:SetRoll(math.Rand(0, 360))
			Smoke:SetRollDelta(math.Rand(-1, 1))
			Smoke:SetColor( 90,83,68) 
 			Smoke:SetAirResistance(50) 
			Smoke:SetCollide(false)
			Smoke:SetBounce(0)
		end
	end
end