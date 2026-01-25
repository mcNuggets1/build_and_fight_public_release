ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/dav0r/hoverball.mdl"
	self.ModelScale = 0.75
	self.OffsetAngle = Angle(0, -180, 0)
	self.Particles = "sensor_particles"
	self.BaseClass.Initialize(self)
end

function ENT:UpdatePet(speed, weight)
	local cur_time = CurTime()
	local ang = self:GetAngles()
	local target_ang = ang + Angle(math.sin(cur_time * Pets.WobbleSpeed) * -4, math.cos(cur_time * Pets.WobbleSpeed) * -4, 0)
	self:SetAngles(LerpAngle(weight, target_ang, ang))
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end