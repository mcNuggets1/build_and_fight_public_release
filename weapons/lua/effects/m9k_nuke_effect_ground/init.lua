local matRefraction	= Material("refract_ring")
matRefraction:SetInt("$nocull",1)
local tMats = {}
tMats.Glow1 = Material("sprites/nuke_light_glow02")
tMats.Glow2 = Material("sprites/nuke_yellowflare")
tMats.Glow3 = Material("sprites/nuke_redglow2")

function EFFECT:Init(data)
	self.Position = data:GetOrigin()
	self.Position.z = self.Position.z + 5
	self.Yield = data:GetMagnitude()
	self.YieldFast = self.Yield^1.3
	self.YieldSlow = self.Yield^0.7
	self.YieldSlowest = self.Yield^0.5
	self.YieldInverse = self.Yield^-0.8
	self.TimeLeft = CurTime() + 27
	self.GAlpha = 255
	self.GSize = 100*self.Yield
	self.FAlpha = 254
	self.CloudHeight = data:GetScale()
	if self.CloudHeight < 100 then self.CloudHeight = 100 end
	self.Refract = 0.5
	self.DeltaRefract = 0.06
	self.Size = 0
	self.MaxSize = 4e5
	if render.GetDXLevel() <= 81 then
		matRefraction = Material("effects/strider_pinch_dudv")
		self.Refract = 0.3
		self.DeltaRefract = 0.03
		self.MaxSize = 2e5
	end
	self.smokeparticles = {}
	local Pos = self.Position
	local emitter = ParticleEmitter(Pos)
		for i=1, 150 do
			local vecang = Vector(math.Rand(-32,32),math.Rand(-32,32),math.Rand(-18,18)):GetNormalized()
			local Flame = emitter:Add("particles/flamelet"..math.random(1,5), Pos + self.Yield*(vecang*(math.Rand(200,600)) + Vector(0,0,self.CloudHeight)))
			if Flame then
				vecang.z = vecang.z + self.YieldSlowest*3.5
				Flame:SetVelocity(math.Rand(30,33)*vecang)
				Flame:SetDieTime(math.Rand(23, 32))
				Flame:SetStartAlpha(math.Rand(230, 250))
				Flame:SetStartSize(self.YieldSlow*math.Rand(200, 300))
				Flame:SetEndSize(self.YieldSlow*math.Rand(350, 450))
				Flame:SetRoll(math.Rand(150, 170))
				Flame:SetRollDelta(self.YieldInverse*math.Rand(-1, 1))
				Flame:SetColor(math.Rand(150,255), math.Rand(100,150), 100)
			end
		end
		for i=1, 84 do
			local vecang = Vector(math.Rand(-32,32),math.Rand(-32,32),math.Rand(-16,24)):GetNormalized()
			local Flame2 = emitter:Add("particles/flamelet"..math.Rand(1,5), Pos + self.Yield*(vecang*(math.Rand(2,340)) + Vector(0,0,math.Rand(-30,60))))
			if Flame2 then
				vecang.z = 0.2*vecang.z
				Flame2:SetVelocity(math.Rand(24,32)*vecang)
				Flame2:SetDieTime(math.Rand(20, 23))
				Flame2:SetStartAlpha(math.Rand(230, 250))
				Flame2:SetStartSize(self.YieldSlow*math.Rand(200, 300))
				Flame2:SetEndSize(self.YieldSlow*math.Rand(350, 450))
				Flame2:SetRoll(math.Rand(150, 170))
				Flame2:SetRollDelta(self.YieldInverse*math.Rand(-1, 1))
				Flame2:SetColor(math.random(150,255), math.random(100,150), 100)
			end
		end
	for i=1, 72 do
		local spawnpos = self.YieldSlow*Vector(math.Rand(-72,72),math.Rand(-72,72),math.Rand(0,self.CloudHeight))
		local Flame3 = emitter:Add("particles/flamelet"..math.random(1,5), Pos + spawnpos)
		if Flame3 then
			Flame3:SetVelocity(self.YieldSlowest*Vector(0,0,math.Rand(2,96)) + self.YieldSlowest*6*VectorRand())
			Flame3:SetDieTime(math.Rand(24, 27))
			Flame3:SetStartAlpha(math.Rand(230, 250))
			Flame3:SetStartSize(self.YieldSlow*math.Rand(130, 150))
			Flame3:SetEndSize(self.YieldSlow*math.Rand(190, 210))
			Flame3:SetRoll(math.Rand(150, 170))
			Flame3:SetRollDelta(self.YieldInverse*math.Rand(-1, 1))
			Flame3:SetColor(math.random(150,255), math.random(100,150), 100)
		end
	end
	for i=1, 160 do
		local vecang = Vector(math.Rand(-32,32),math.Rand(-32,32),math.Rand(-18,18)):GetNormalized()
		local Smoke = emitter:Add("particles/smokey", Pos + self.Yield*(vecang*(math.Rand(4,685)) + Vector(0,0,self.CloudHeight)))
		if Smoke then
			local startalpha = math.Rand(0, 5)
			vecang.z = vecang.z + self.YieldSlowest*4.2
			Smoke:SetVelocity(math.Rand(24,26)*vecang)
			Smoke:SetLifeTime(math.Rand(-23, -14))
			Smoke:SetDieTime(62)
			Smoke:SetStartAlpha(startalpha)
			Smoke:SetEndAlpha(250 + startalpha)
			Smoke:SetStartSize(self.YieldSlow*math.Rand(300, 380))
			Smoke:SetEndSize(self.YieldSlow*math.Rand(450, 550))
			Smoke:SetRoll(math.Rand(150, 170))
			Smoke:SetRollDelta(self.YieldInverse*math.Rand(-2, 2))
			Smoke:SetColor(60,58,54)
			table.insert(self.smokeparticles, Smoke)
		end
	end
	for i=1, 100 do
		local vecang = Vector(math.Rand(-32,32),math.Rand(-32,32),math.Rand(-2,4)):GetNormalized()
		local Smoke2 = emitter:Add("particles/smokey", Pos + self.Yield*(vecang*(math.Rand(2,650))))
		if Smoke2 then
			local startalpha = math.Rand(0, 5)
			Smoke2:SetVelocity(math.Rand(8,32)*vecang)
			Smoke2:SetLifeTime(math.Rand(-21, -12))
			Smoke2:SetDieTime(62)
			Smoke2:SetStartAlpha(startalpha)
			Smoke2:SetEndAlpha(250 + startalpha)
			Smoke2:SetStartSize(self.YieldSlow*math.Rand(300, 380))
			Smoke2:SetEndSize(self.YieldSlow*math.Rand(400, 500))
			Smoke2:SetRoll(math.Rand(150, 170))
			Smoke2:SetRollDelta(self.YieldInverse*math.Rand(-1, 1))
			Smoke2:SetColor(60,58,54)
			table.insert(self.smokeparticles, Smoke2)
		end
	end
	for i=1, 115 do
		local spawnpos = self.YieldSlow*Vector(math.random(-68,68),math.random(-68,68),math.Rand(0,self.CloudHeight))
		local Smoke3 = emitter:Add("particles/smokey", Pos + spawnpos)
		if Smoke3 then
			local startalpha = math.Rand(0, 5)
			Smoke3:SetVelocity(self.YieldSlowest*Vector(0,0,math.Rand(0,96)) + self.YieldSlowest*math.Rand(4,9)*VectorRand())
			Smoke3:SetLifeTime(math.Rand(-22, -13))
			Smoke3:SetDieTime(62)
			Smoke3:SetStartAlpha(startalpha)
			Smoke3:SetEndAlpha(250 + startalpha)
			Smoke3:SetStartSize(self.YieldSlow*math.Rand(240, 260))
			Smoke3:SetEndSize(self.YieldSlow*math.Rand(270, 300))
			Smoke3:SetRoll(math.Rand(150, 170))
			Smoke3:SetRollDelta(self.YieldInverse*math.Rand(-1, 1))
			Smoke3:SetColor(60,58,54)
			table.insert(self.smokeparticles, Smoke3)
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	local timeleft = self.TimeLeft - CurTime()
	if timeleft > 0 then
		local ftime = FrameTime()
		if self.FAlpha > 0 then
			self.FAlpha = self.FAlpha - 100*ftime
		end
		self.GAlpha = self.GAlpha - 9.48*ftime
		self.GSize = self.GSize - 0.1*timeleft*ftime*self.Yield
		self.CloudHeight = self.CloudHeight + 120*ftime*self.YieldSlowest
		self.Refract = self.Refract - self.DeltaRefract*ftime
		self.Size = self.Size + 2e4*ftime
		return true
	else
		for __,particle in pairs(self.smokeparticles) do
		particle:SetStartAlpha(70)
		particle:SetEndAlpha(0)
		end
		return false	
	end
end

function EFFECT:Render()
	local startpos = self.Position
	render.SetMaterial(tMats.Glow1)
	render.DrawSprite(startpos + Vector(0,0,128),450*self.GSize,60*self.GSize,Color(255,240,220,self.GAlpha))
	render.DrawSprite(startpos + Vector(0,0,self.CloudHeight),140*self.GSize,90*self.GSize,Color(255,240,220,0.7*self.GAlpha))
	if self.FAlpha > 0 then
		render.DrawSprite(startpos + Vector(0,0,256),80*(self.GSize^2),55*(self.GSize^2),Color(255,247,238,self.FAlpha))
	end
	render.SetMaterial(tMats.Glow2)
	render.DrawSprite(startpos + Vector(0,0,800),600*self.GSize,500*self.GSize,Color(255,50,10,0.7*self.GAlpha))
	render.SetMaterial(tMats.Glow3)
	render.DrawSprite(startpos + Vector(0,0,self.CloudHeight),40*self.GSize,500*self.GSize,Color(130,120,240,0.23*self.GAlpha))
	render.DrawSprite(startpos + Vector(0,0,self.CloudHeight),700*self.GSize,60*self.GSize,Color(80,73,255,self.GAlpha))
	if self.Size < self.MaxSize then
		matRefraction:SetFloat("$refractamount", math.sin(self.Refract*math.pi) * 0.2)
		render.SetMaterial(matRefraction)
		render.UpdateRefractTexture()
		render.DrawQuadEasy(startpos,
		Vector(0,0,1),
		self.Size, self.Size)
	end
end