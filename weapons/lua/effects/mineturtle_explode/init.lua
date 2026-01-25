function EFFECT:Init(data)
	self.Entity = data:GetEntity()
	self.Pos = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Radius = data:GetRadius() or 1
	self.DirVec = data:GetNormal()
	self.PenVec = data:GetStart()
	self.Particles = data:GetMagnitude()
	self.Angle = self.DirVec:Angle()
	self.DebrizzlemyNizzle = 10 + data:GetScale()
	self.Size = 5 * self.Scale
	self.Emitter = ParticleEmitter(self.Pos)
	if self.Scale < 1.2 then
		sound.Play("ambient/explosions/explode_"..math.random(1, 4)..".wav", self.Pos, 100, 100)
	else
		sound.Play("Explosion.Boom", self.Pos)
		sound.Play("ambient/explosions/explode_"..math.random(1, 4)..".wav", self.Pos, 100, 100)
	end
	self:Dust()
	self.Emitter:Finish()
end
 
function EFFECT:Dust()
	for i=1,5 do
		local Flash = self.Emitter:Add("effects/muzzleflash"..math.random(1,4), self.Pos)
		if Flash then
			Flash:SetVelocity(self.DirVec*100)
			Flash:SetAirResistance(200)
			Flash:SetDieTime(0.15)
			Flash:SetStartAlpha(255)
			Flash:SetEndAlpha(0)
			Flash:SetStartSize(self.Scale*300)
			Flash:SetEndSize(0)
			Flash:SetRoll(math.Rand(180,480))
			Flash:SetRollDelta(math.Rand(-1,1))
			Flash:SetColor(255,255,255)
		end
	end
	for i=1, 20*self.Scale do
		local Dust = self.Emitter:Add("particle/particle_composite", self.Pos)
		if Dust then
			Dust:SetVelocity(self.DirVec * math.random(100,400)*self.Scale + ((VectorRand():GetNormalized()*300)*self.Scale))
			Dust:SetDieTime(math.Rand(2, 3))
			Dust:SetStartAlpha(230)
			Dust:SetEndAlpha(0)
			Dust:SetStartSize((50*self.Scale))
			Dust:SetEndSize((100*self.Scale))
			Dust:SetRoll(math.Rand(150, 360))
			Dust:SetRollDelta(math.Rand(-1, 1))
			Dust:SetAirResistance(150)
			Dust:SetGravity(Vector(0, 0, math.Rand(-100, -400)))
			Dust:SetColor(80,80,80)
		end
	end
	for i=1, 10*self.Scale do
		local Dust = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9), self.Pos)
		if Dust then
			Dust:SetVelocity(self.DirVec * math.random(100,400)*self.Scale + ((VectorRand():GetNormalized()*400)*self.Scale))
			Dust:SetDieTime(math.Rand(1, 5)*self.Scale)
			Dust:SetStartAlpha(50)
			Dust:SetEndAlpha(0)
			Dust:SetStartSize((80*self.Scale))
			Dust:SetEndSize((100*self.Scale))
			Dust:SetRoll(math.Rand(150, 360))
			Dust:SetRollDelta(math.Rand(-0.25, 0.25))
			Dust:SetAirResistance(250)
			Dust:SetGravity(Vector(math.Rand(-200 , 200), math.Rand(-200 , 200), math.Rand(10 , 100)))
			Dust:SetColor(90,85,75)
		end
	end
	for i=1, 80*self.Scale do
		local Debris = self.Emitter:Add("effects/fleck_cement"..math.random(1,2), self.Pos)
		if Debris then
			Debris:SetVelocity (self.DirVec * math.random(0,700)*self.Scale + VectorRand():GetNormalized() * math.random(0,700)*self.Scale)
			Debris:SetDieTime(math.random(1, 2) * self.Scale)
			Debris:SetStartAlpha(255)
			Debris:SetEndAlpha(0)
			Debris:SetStartSize(math.random(5,10)*self.Scale)
			Debris:SetRoll(math.Rand(0, 360))
			Debris:SetRollDelta(math.Rand(-5, 5))
			Debris:SetAirResistance(40)
			Debris:SetColor(60,60,60)
			Debris:SetGravity(Vector(0, 0, -600))
		end
	end
	local Angle = self.DirVec:Angle()
	for i = 1, self.DebrizzlemyNizzle do
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 5) + (DustRing*math.Rand(2, 5))
		for k = 3, self.Particles do
			local Rcolor = math.random(-20,20)
			local particle1 = self.Emitter:Add("particle/smokesprites_000"..math.random(1,9), self.Pos)
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(1, 2) * self.Size) + (RanVec*self.Size*k*3.5))
			particle1:SetDieTime(math.Rand(0.5, 4)*self.Scale)
			particle1:SetStartAlpha(math.Rand(90, 100))
			particle1:SetEndAlpha(0)
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(5, 10)* self.Size) + Vector(0,0,-50))
			particle1:SetAirResistance(200+self.Scale*20)
			particle1:SetStartSize((5*self.Size)-((k/self.Particles)*self.Size*3))
			particle1:SetEndSize((20*self.Size)-((k/self.Particles)*self.Size))
			particle1:SetRoll(math.random(-500, 500)/100)
			particle1:SetRollDelta(math.random(-0.1, 0.1))
			particle1:SetColor(90+Rcolor,87+Rcolor,80+Rcolor)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end