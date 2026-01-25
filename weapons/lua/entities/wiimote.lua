ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("Wiimote_Explode")

	function ENT:Initialize()
		self:SetModel("models/weapons/w_wiimote_meow.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(0.5)
		end
	end

	function ENT:Think()
		self.lifetime = self.lifetime or CurTime() + 30
		if CurTime() > self.lifetime then
			self:Remove()
		end
	end

	function ENT:Disable(data)
		self.Disabled = self.Disabled and self.Disabled + 1 or 1
		self.lifetime = CurTime() + 30
		if self.Disabled >= 2 then
			timer.Simple(0, function()
				if !IsValid(self) then return end
				self:BreakEffect(data)
				self:Remove()
			end)
		end
	end

	function ENT:BreakEffect(data)
		net.Start("Wiimote_Explode")
			net.WriteVector(data.HitPos - data.HitNormal)
			net.WriteVector(data.HitNormal)
			net.WriteVector(data.OurOldVelocity)
			net.WriteFloat(self:EntIndex())
		net.Broadcast()
	end

	local rand = {1, 2, 3, 5}
	function ENT:PhysicsCollide(data, phys)
		if (self.NextCollide or 0) > CurTime() then return end
		self.NextCollide = CurTime() + 0.1
		if self.Disabled and self.Disabled >= 2 then return end
		local Ent = data.HitEntity
		if !IsValid(Ent) and !Ent:IsWorld() then return end
		if Ent:IsWorld() then
			local tr = util.TraceLine({
				start = data.HitPos,
				endpos = data.HitPos + data.HitNormal,
				filter = self
			})
			if tr.HitSky then return end
		end
		if data.Speed > 100 then
			local damagedice = 75 * math.Rand(0.9, 1.1)
			if Ent:IsWorld() and self:WaterLevel() < 3 then
				self:EmitSound("physics/plastic/plastic_box_impact_bullet"..rand[math.random(4)]..".wav")
			elseif IsEntity(Ent) then
				if (Ent:IsPlayer() or Ent:IsNPC() or Ent:IsRagdoll()) then
					local edata = EffectData()
					edata:SetOrigin(data.HitPos)
					util.Effect("BloodImpact", edata, true, true)
					self:EmitSound("physics/plastic/plastic_box_impact_bullet"..rand[math.random(4)]..".wav")
					Ent:TakeDamage(damagedice, self.Owner, self)
				else
					self:EmitSound("physics/plastic/plastic_box_impact_bullet"..rand[math.random(4)]..".wav")
					Ent:TakeDamage(damagedice / 3, self.Owner, self)
				end
			else
				self:EmitSound("physics/plastic/plastic_box_impact_bullet"..rand[math.random(4)]..".wav")
			end
		elseif data.Speed > 50 then
			self:EmitSound("physics/plastic/plastic_box_impact_bullet"..rand[math.random(4)]..".wav")
		end
		self:Disable(data)
	end
end

if CLIENT then
	local emitter = ParticleEmitter(Vector(0, 0, 0))
	local function wiimote_explode(particle, vel)
		particle:SetColor(200, 200, 200, 255)
		particle:SetVelocity(vel or VectorRand():GetNormalized() * 15)
		particle:SetGravity(Vector(0, 0, -200))
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(3, 5))
		particle:SetStartSize(2)
		particle:SetEndSize(0)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(0)
		particle:SetCollide(true)
		particle:SetBounce(0.25)
		particle:SetRoll(math.pi * math.Rand(0, 1))
		particle:SetRollDelta(math.pi * math.Rand(-10, 10))
	end

	net.Receive("Wiimote_Explode", function()
		if !emitter then return end
		local pos = net.ReadVector()
		local norm = net.ReadVector()
		local vel = net.ReadVector()
		local entid = net.ReadFloat()
		for i = 1, 30 do
			local particle = emitter:Add("effects/fleck_tile"..math.random(1, 2), pos)
			if particle then
				local dir = VectorRand():GetNormalized()
				wiimote_explode(particle, ((-norm) + dir):GetNormalized() * math.Rand(0, 200) + vel * 0.5)
			end
		end
	end)
end