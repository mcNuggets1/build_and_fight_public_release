ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/props_trainstation/train001.mdl"
	self.ModelScale = 0.05
	self.OffsetAngle = Angle(0, -90, 0)
	self.Particles = "train_smoke"
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("ambient/alarms/razortrain_horn1.wav", 80, 100, 0.2)
	end
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end