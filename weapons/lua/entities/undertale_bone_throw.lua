if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Editable = true
ENT.PrintName = "Knochen"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if CLIENT then
	killicon.Add("undertale_bone_throw", "undertale/killicon_bone", color_white)
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/undertale/undertale_bone.mdl")
		self:SetTrigger(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetModelScale(self:GetModelScale() / 2, 0)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(false)
		end
		local edata = EffectData()
		edata:SetOrigin(self:GetPos())
		util.Effect("undertale_bone_effect", edata, true, true)
	end
end

if SERVER then
	function ENT:PhysicsUpdate()
		if !self.Hit then
			if self:GetVelocity():LengthSqr() < 1000000 then
				self.Hit = true
				self:Fire("Kill", "", 0)
				local phys = self:GetPhysicsObject()
				if IsValid(phys) then
					phys:EnableGravity(true)
				end
			end
		end
	end

	function ENT:PhysicsCollide(data, phys)
		if !self.Hit then
			if data.Speed > 100 then
				local hit_ent = data.HitEntity
				if (hit_ent:GetClass() != "undertale_bone_throw" and hit_ent != self.Owner) then
					local hitpos = data.HitPos
					self.Hit = true
					self:SetPos(hitpos)
					timer.Simple(0, function()
						if !IsValid(self) then return end
						self:SetMoveType(MOVETYPE_NONE)
						self:SetSolid(SOLID_NONE)
						if IsValid(hit_ent) then
							hit_ent:TakeDamage(25 * math.Rand(0.75, 1.25), self.Owner, self)
							if hit_ent:IsPlayer() or hit_ent:IsNPC() then
								sound.Play("undertale/damage.wav", hit_ent:GetPos())
								local edata = EffectData()
								edata:SetOrigin(data.HitPos)
								util.Effect("BloodImpact", edata)
							else
								local edata = EffectData()
								edata:SetOrigin(self:GetPos())
								util.Effect("undertale_bone_effect", edata, true, true)
							end
							if !hit_ent:IsPlayer() and !hit_ent:IsNPC() then
								self:SetParent(hit_ent, -1)
							else
								self:Remove()
							end
						else
							local edata = EffectData()
							edata:SetOrigin(self:GetPos())
							util.Effect("undertale_bone_effect", edata, true, true)
						end
						self:Fire("Kill", "", 5)
					end)
				end
			end
		end
	end
end