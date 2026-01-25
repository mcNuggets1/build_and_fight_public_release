ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:SetMaterial("models/wireframe")

	if SERVER then
		self:SetPos(self:GetPos() + Vector(0, 0, Crates.WobbleHeight * 6))
		self:SetAngles(Angle(180, (CurTime() % 360) * Crates.SpinSpeed, 180))
	else
		self.SpawnPos = self:GetPos()

		local xmin, xmax = self:GetRenderBounds()
		self:SetRenderBounds(xmin + Vector(0, 0, -(Crates.WobbleHeight * 6)), xmax)
	end

	self:SetModelScale(0.65, 0)
end

function ENT:Think()
	if SERVER then return end

	local curtime = CurTime()
	self:SetPos(self.SpawnPos + Vector(0, 0, math.sin(curtime) * Crates.WobbleHeight))
	self:SetAngles(Angle(180, (curtime % 360) * Crates.SpinSpeed, 180))
end