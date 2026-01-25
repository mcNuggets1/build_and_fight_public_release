ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/combine_helicopter.mdl"
	self.ModelScale = 0.1
	self.Particles = "copter_clouds2"
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("npc/attack_helicopter/aheli_damaged_alarm1.wav", 75, 100, 0.5)
	end
end

function ENT:UpdatePet(speed, weight)
	local sequence = self:LookupSequence("Idle01")
	self:SetPlaybackRate(1)
	self:ResetSequence(sequence)
end

function ENT:OnPetDeath()
	if SERVER then
		local ed = EffectData()
		ed:SetOrigin(self:GetPos())
		util.Effect("pet_disappear", ed, true, true)
	end
end