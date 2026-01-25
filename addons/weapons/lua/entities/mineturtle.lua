if SERVER then
	AddCSLuaFile()
end

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Schildkrötenmine"

if SERVER then
	ENT.StepSound = Sound("turtlegrenade/hello.wav")

	function ENT:Initialize()
		self:SetModel("models/props/de_tides/vending_turtle.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
		self.CanExplode = true
		self.Step = false
		self.TimeLeft = CurTime() + 3
	end

	function ENT:Think()
		if !IsValid(self.Owner) then
			self:Remove()
		end
		if self.TimeLeft < CurTime() and !self.Step then
			local pos = self:GetPos()
 			for _,v in ipairs(ents.FindInSphere(pos, 150)) do
				if v:IsPlayer() or v:IsNPC() and v:IsSolid() and v != self then
					local trace = {}
					trace.start = pos
					trace.endpos = v:GetPos()
					trace.filter = {self, v}
					local tr = util.TraceLine(trace)
					local hit = tr.Hit
					if !tr.Hit then
						self:EmitSound(self.StepSound)
						self.Step = true
						timer.Simple(0.75, function()
				   			if IsValid(self) then
		  						self:Explode()
							end
						end)
						break
					end 
				end
			end	
		end
		self:NextThink(CurTime() + 0.1)
		return true
	end

	function ENT:OnTakeDamage(dmginfo)
		self:Explode()
	end

	function ENT:Explode()
		if !self.CanExplode then return end
		self.CanExplode = false
		local pos = self:GetPos()
		local edata = EffectData()
		edata:SetOrigin(pos)
		util.Effect("HelicopterMegaBomb", edata, true, true)
		util.Effect("ThumperDust", edata, true, true)
		util.Effect("Explosion", edata, true, true)
		local edata = EffectData()
		edata:SetOrigin(pos)
		edata:SetNormal(Vector(0, 0, 1))
		edata:SetEntity(self)
		edata:SetScale(1)
		edata:SetRadius(67)
		edata:SetMagnitude(18)
		util.Effect("mineturtle_explode", edata, true, true)
		util.Effect("mineturtle_splatter", edata, true, true)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 10), self)
		util.BlastDamage(self, self.Owner, pos, 400, 500)
		util.ScreenShake(pos, 2500, 255, 3, 2500)
		self:Remove()
	end
end