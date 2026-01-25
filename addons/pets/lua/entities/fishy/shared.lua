ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/props/cs_militia/fishriver01.mdl"
	self.ModelScale = 1.6
	self.Particles = "fish_drip"
	self.BaseClass.Initialize(self)
end

function ENT:UpdatePet(speed, weight)
	self:SetAngles(self:GetAngles() + Angle(math.sin(CurTime() * Pets.WobbleSpeed) * -4, 0, 0))
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end