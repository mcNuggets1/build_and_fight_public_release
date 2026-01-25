function EFFECT:Init(data)
	if !IsValid(data:GetEntity()) then return end
	self.Entity = data:GetEntity()
	self.Position = self.Entity:GetPos()
	local height = 2*self.Entity:BoundingRadius()
	local width = height/3
	local negwidth = width*-1
	local emitter = ParticleEmitter(self.Position)
	for i=1,math.ceil(height) do
		local Antlion = emitter:Add("effects/fleck_antlion"..math.random(1,2), self.Position + Vector(math.Rand(negwidth,width),math.Rand(negwidth,width),math.Rand(2,height)))
		if Antlion then
			Antlion:SetVelocity(VectorRand()*96)
			Antlion:SetDieTime(math.Rand(0.4, 0.8))
			Antlion:SetStartAlpha(255)
			Antlion:SetEndAlpha(0)
			Antlion:SetStartSize(math.Rand(1.5, 1.7))
			Antlion:SetEndSize(math.Rand(1.8, 2))
			Antlion:SetRoll(math.Rand(360, 520))
			Antlion:SetRollDelta(math.Rand(-2, 2))
			Antlion:SetColor(30, 30, 30)
		end
	end
	for i=1,math.ceil(width) do
		local Smoke = emitter:Add("particles/smokey", self.Position + Vector(math.Rand(negwidth,width),math.Rand(negwidth,width),math.Rand(2,height)))
		if Smoke then
			Smoke:SetVelocity(Vector(math.Rand(-24,24),math.Rand(-24,24),math.Rand(32,64)))
			Smoke:SetDieTime(math.Rand(0.4, 0.8))
			Smoke:SetStartAlpha(255)
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(math.Rand(12, 16))
			Smoke:SetEndSize(math.Rand(32, 48))
			Smoke:SetRoll(math.Rand(360, 520))
			Smoke:SetRollDelta(math.Rand(-2, 2))
			Smoke:SetColor(20, 20, 20)
		end
	end
	emitter:Finish()
	local trace = {}
	trace.startpos = self.Position + Vector(0,0,32)
	trace.endpos = trace.startpos - Vector(0,0,64)
	trace.filter = self.Entity
	local traceRes = util.TraceLine(trace)
	util.Decal("Scorch", traceRes.HitPos + traceRes.HitNormal, traceRes.HitPos - traceRes.HitNormal)
	for i=1,8 do
		trace.endpos = trace.startpos + Vector(math.Rand(-48,48),math.Rand(-48,48),-64)
		traceRes = util.TraceLine(trace)
		util.Decal("Blood", traceRes.HitPos + traceRes.HitNormal, traceRes.HitPos - traceRes.HitNormal)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end