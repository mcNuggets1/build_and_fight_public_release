ENT.PrintName = "Kanonenkugel"
ENT.Type = "anim"

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self.flightvector = self:GetForward() * 25
		self.timeleft = CurTime() + 30
		self:SetModel("models/props_phx/misc/smallcannonball.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetNWBool("smoke", true)
		self.InFlight = true
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
		if CurTime() > self.timeleft then
			self:SuicideExplode()
			return
		end
		if self.InFlight then
			local trace = {}
			trace.start = self:GetPos()
			trace.endpos = self:GetPos() + self.flightvector
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
				self.flightvector = self:GetUp() * 25 + Vector(0, 0, -0.15)
				self:SetPos(self:GetPos() + self.flightvector)
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
		self.timeleft = CurTime() + 2
	end

	function ENT:HitWater()
		self.Think = function() end
		self:SetMoveType(MOVETYPE_VPHYSICS)
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(3)
		end
		self.Think = function()
		end
		self:SetPos(pos)
		self:SetAngles(ang)
		self.InFlight = false
		self:SetNWBool("smoke", false)
		SafeRemoveEntityDelayed(self, 5)
	end

	function ENT:SuicideExplode()
		local edata = EffectData()
		edata:SetOrigin(self:GetPos())
		edata:SetNormal(Vector(0, 0, 1))
		edata:SetEntity(self)
		edata:SetScale(1.2)
		edata:SetRadius(67)
		edata:SetMagnitude(12)
		util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
		util.BlastDamage(self, self.Owner, self:GetPos(), 300/2, 150/2)
		util.ScreenShake(self:GetPos(), 10/2, 5/2, 1/2, 3000/2)
		local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetPos() - Vector(0, 0, 3)
		trace.filter = {self.Owner, self}
		local tr = util.TraceLine(trace)
		if tr.Hit then
			util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		end
		self:Remove()
	end

	function ENT:Explode(tr)
		if self:WaterLevel() > 0 then
			local edata = EffectData()
			edata:SetOrigin(tr.HitPos)
			util.Effect("WaterSurfaceExplosion", edata, true, true)
		end
		local edata = EffectData()
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.HitNormal)
		edata:SetEntity(self)
		edata:SetScale(1.2)
		edata:SetRadius(tr.MatType)
		edata:SetMagnitude(12)
		util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
		util.BlastDamage(self, self.Owner, self:GetPos(), 300, 150)
		util.ScreenShake(self:GetPos(), 10, 5, 1, 3000)
		util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
		self:Remove()
	end
end

if CLIENT then
	function ENT:Initialize()
		self.Emitter = ParticleEmitter(self:GetPos())
	end

	function ENT:Think()
		if self:GetNWBool("smoke") and (self.NextParticle or 0) <= CurTime() then
			self.NextParticle = CurTime() + 0.0001
			local Muzzle = self.Emitter:Add("effects/muzzleflash"..math.random(1,4), self:GetPos() + self:GetForward() * -5)
			if Muzzle then
				Muzzle:SetVelocity((self:GetUp() * -2000) + (VectorRand() * 100))
				Muzzle:SetDieTime(math.Rand(0.4, 1))
				Muzzle:SetColor(255, 150, 0)
				Muzzle:SetStartAlpha(math.Rand(25, 35))
				Muzzle:SetEndAlpha(0)
				Muzzle:SetStartSize(math.Rand(10, 20))
				Muzzle:SetEndSize(math.Rand(50, 70))
				Muzzle:SetRoll(math.Rand(0, 360))
				Muzzle:SetRollDelta(math.Rand(-1, 1))
 				Muzzle:SetAirResistance(200)
 				Muzzle:SetGravity(Vector(100, 0, 0))
			end
		end
	end
end