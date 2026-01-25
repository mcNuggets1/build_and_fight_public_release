include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent=ents.Create(ClassName)
	ent:SetPos(tr.HitPos+Vector(0,0,5))
	ent:Spawn()
	ent:Activate()
	ent.Owner=ply
	ent:SetSkin(math.random(0,3))
	return ent
end

function ENT:PhysicsUpdate(ph)
	self:base("wac_hc_base").PhysicsUpdate(self,ph)
	
	if self.topRotor and IsValid(self.topRotor.vis) then
		if self.rotorRpm > 0.4 and self.rotorRpm < 0.59 then
			self.topRotor.vis:SetBodygroup(1,1)
		end
		if self.rotorRpm > 0.6 and self.rotorRpm < 0.79 then
			self.topRotor.vis:SetBodygroup(1,2)
		end
		if self.rotorRpm > 0.8 and self.rotorRpm < 0.89 then
			self.topRotor.vis:SetBodygroup(1,3)
		end
		if self.rotorRpm > 0.9 then
			self.topRotor.vis:SetBodygroup(1,4)
		end
		if self.rotorRpm < 0.4 then
			self.topRotor.vis:SetBodygroup(1,0)
		end
	end
	
	local phys=self:GetPhysicsObject()
	if IsValid(phys) and not self.disabled then
		if phys:GetVelocity():Length() > 850 then
			self:SetBodygroup(2,1)
		else
			self:SetBodygroup(2,0)
		end
	end
	
	if self.disabled and not self.backgib then
		self:KillBackRotor()
		self:SetBodygroup(1,1)
		self.backgib = ents.Create("prop_physics")
		self.backgib:SetModel("models/sentry/uh-1d_tail.mdl")
		self.backgib:SetSkin(self:GetSkin())
		self.backgib:SetPos(self:GetPos())
		self.backgib:SetAngles(self:GetAngles())
		self.backgib:Spawn()
		self.backgib:Activate()
		constraint.NoCollide(self, self.backgib, 0, 0)
		self:AddOnRemove(self.backgib)
	end
end