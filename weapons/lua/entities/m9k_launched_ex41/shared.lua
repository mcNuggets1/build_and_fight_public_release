ENT.PrintName = "EX41-Grenade"
ENT.Type = "anim"

if SERVER then
	AddCSLuaFile("shared.lua")

	function ENT:Initialize()
		self.flightvector = self:GetUp() * 30
		self.TimeLeft = CurTime() + 30
		self.InFlight = true
		self:SetModel("models/weapons/w_40mm_grenade_launched.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetNWBool("smoke", true)
	end

	function ENT:Think()
		if !IsValid(self.Owner) then
			self:Remove()
			return
		end
		if self:WaterLevel() > 2 then
			self.InWater = self.InWater or CurTime() + 0.1
			if self.InWater <= CurTime() then
				self:HitWater()
				return
			end
		else
			self.InWater = nil
		end
		if CurTime() > self.TimeLeft then
			self:SuicideExplode()
			return
		end
		if self.InFlight then
			local trace = {}
			trace.start = self:GetPos()
			trace.endpos = self:GetPos() + self.flightvector * (1 / (1 / engine.TickInterval() / 66))
			trace.filter = {self.Owner, self}
			local tr = util.TraceLine(trace)
			if tr.HitSky then
				self:Remove()
				return
			end
			if tr.Hit then
				if !(tr.MatType == 70 or tr.MatType == 50) then
					self:Explode(tr)
					return
				elseif (tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsRagdoll()) then
					self:HitSomething(tr)
					return
				else
					self:Remove()
					return
				end
			end
			if self.InFlight then
				self:SetPos(self:GetPos() + self.flightvector * (1 / (1 / engine.TickInterval() / 66)))
				self.flightvector = self:GetUp() * 30 + Vector(0, 0, -0.035)
				self:SetAngles(self.flightvector:Angle() + Angle(90, 0, 0))
			end
		end
		self:NextThink(CurTime())
		return true
	end

	function ENT:HitSomething(tr)
		tr.Entity:TakeDamage(math.random(250, 300), self.Owner, self)
		tr.Entity:EmitSound(("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav"), 500, 100)
		local edata = EffectData()
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.HitNormal)
		edata:SetEntity(self)
		edata:SetScale(1)
		edata:SetRadius(tr.MatType)
		edata:SetMagnitude(10)
		util.Effect("m9k_cinematic_blood_cloud", edata, true, true)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetPos(tr.HitPos)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(3)
		end
		self.InFlight = false
		self:SetNWBool("smoke", false)
		self.TimeLeft = CurTime() + 2
	end

	function ENT:HitWater()
		self:SetMoveType(MOVETYPE_VPHYSICS)
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(3)
			phys:SetVelocity(self:GetUp() * 1000)
		end
		self:SetPos(pos)
		self:SetAngles(ang)
		self.Think = function()
		end
		self.InFlight = false
		self:SetNWBool("smoke", false)
		SafeRemoveEntityDelayed(self, 5)
	end

	function ENT:SuicideExplode()
		local pos = self:GetPos()
		local edata = EffectData()
		edata:SetOrigin(self:GetPos())
		edata:SetNormal(Vector(0, 0, 1))
		edata:SetEntity(self)
		edata:SetScale(1.6)
		edata:SetRadius(50)
		edata:SetMagnitude(16)
		util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
		util.BlastDamage(self, self.Owner, pos, 450/2, 150/2)
		util.ScreenShake(pos, 10/2, 5/2, 1/2, 2500/2)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 10), self)
		self:Remove()
	end

	function ENT:Explode(tr)
		if self:WaterLevel() > 0 then
			local edata = EffectData()
			edata:SetOrigin(tr.HitPos)
			util.Effect("WaterSurfaceExplosion", edata, true, true)
		end
		local edata = EffectData()
		edata:SetOrigin(self:GetPos())
		edata:SetNormal(tr.HitNormal)
		edata:SetEntity(self)
		edata:SetScale(1.6)
		edata:SetRadius(tr.MatType)
		edata:SetMagnitude(16)
		util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
		util.BlastDamage(self, self.Owner, tr.HitPos, 450, 150)
		util.ScreenShake(tr.HitPos, 10, 5, 1, 2500)
		util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal * 10, self)
		self:Remove()
	end
end

if CLIENT then
	function ENT:Initialize()
		self.Emitter = ParticleEmitter(self:GetPos())
	end

	function ENT:Think()
		if self:GetNWBool("smoke") and (self.NextParticle or 0) <= CurTime() then
			self.NextParticle = CurTime() + 0.001
			local Smoke = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), self:GetPos() + (self:GetUp() * -30))
			if Smoke then
				Smoke:SetVelocity((self:GetUp() * -2000) + (VectorRand() * 100))
				Smoke:SetDieTime(math.Rand(1.7, 2.2))
				Smoke:SetStartAlpha(math.Rand(15, 25))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(math.Rand(30, 40))
				Smoke:SetEndSize(math.Rand(90, 110))
				Smoke:SetRoll(math.Rand(0, 360))
				Smoke:SetRollDelta(math.Rand(-1, 1))
				Smoke:SetColor(190, 190, 190)
 				Smoke:SetAirResistance(200)
 				Smoke:SetGravity(Vector(100, 0, 0))
			end
		end
	end
end