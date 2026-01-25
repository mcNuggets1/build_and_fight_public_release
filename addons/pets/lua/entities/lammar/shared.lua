ENT.Type = "anim"
ENT.Base = "base_pet"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	self.ModelString = "models/headcrabclassic.mdl"
	self.ModelScale = 0.7
	self.Particles = "lammar_blood"
	self.BaseClass.Initialize(self)
	if SERVER then
		self:AddRandomPetSound("npc/headcrab/idle1.wav")
		self:AddRandomPetSound("npc/headcrab/idle2.wav")
		self:AddRandomPetSound("npc/headcrab/idle3.wav")
	end
end

function ENT:UpdatePet(speed, weight)
	local sequence = self:LookupSequence("Idle01")
	if (weight >= 1) then
		sequence = self:LookupSequence("Run1")
	end
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