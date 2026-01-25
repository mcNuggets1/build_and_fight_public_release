function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.Yield = data:GetMagnitude()
	self.YieldSlow = self.Yield^0.75
	self.YieldSlowest = self.Yield^0.5
	self.YieldInverse = self.Yield^-1
	self.HalfTime = self.Yield*3.2
	self.TimeLeft = CurTime() + self.HalfTime
	self.dustparticles = {}
	local Pos = self.Position
	local emitter = ParticleEmitter(Pos)
	for i=1, math.ceil(self.YieldSlowest*240) do
		local spawnpos = Vector(math.Rand(-512,512),math.Rand(-512,512),math.Rand(-2,4))
		local Part = emitter:Add("particles/smokey", Pos + spawnpos)
		local velvec = spawnpos:GetNormalized()
		local velmult = math.Rand(3900,4100)
		Part:SetVelocity(velvec*velmult)
		Part:SetDieTime(self.HalfTime*2)
		Part:SetStartAlpha(0)
		Part:SetEndAlpha(130)
		Part:SetStartSize(self.YieldSlowest*math.Rand(800, 1000))
		Part:SetEndSize(self.YieldSlowest*math.Rand(1100, 1300))
		Part:SetRoll(math.Rand(480, 540))
		Part:SetRollDelta(math.Rand(-1, 1)*self.YieldInverse)
		Part:SetColor(160,152,120)
		table.insert(self.dustparticles, Part)
	end
	emitter:Finish()
end

function EFFECT:Think()
	if self.TimeLeft > CurTime() then
		return true
	else
		for _,Part in pairs(self.dustparticles) do
			Part:SetStartAlpha(100)
			Part:SetEndAlpha(0)
		end
		return false
	end
end

function EFFECT:Render()
end