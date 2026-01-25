ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self.IsPet = true
	self.ModelString = self.ModelString or "models/error.mdl"
	self.ModelScale = self.ModelScale or 1
	self.Particles = self.Particles
	self.PetColor = self.PetColor or Color(255, 255, 255, 255)
	self.OffsetAngle = self.OffsetAngle or Angle(0, 0, 0)
	self.RollAngles = self.RollAngles or Angle(0, 0, 0)
	if SERVER then
		self:SetModel(self.ModelString)
		self:PhysicsInitStatic(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NOCLIP)
	else
		if self.Particles then
			self:AttachPetParticles(self.Particles)
		end
	end
	self:DrawShadow(false)
	self:SetModelScale(self.ModelScale, 0)
	self:SetColor(self.PetColor)
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
end

function ENT:Think()
	if SERVER then
		self:MovePet()
		local speed, weight = self:SetPetAngles(self.OffsetAngle)
		if self.UpdatePet then
			self:UpdatePet(speed, weight)
		end
	end
	if Pets.SmoothAnimations then
		self:NextThink(CurTime())
		return true
	end
end

function ENT:OnRemove(fullupdate)
	if fullupdate then return end

	if self.OnPetDeath then
		self:OnPetDeath()
	end
end