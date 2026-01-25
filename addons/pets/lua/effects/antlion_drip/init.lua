function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local delay = 0.035
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("effects/energysplash", pos + Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(-5, 0)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(0, 0, -80))
					particle:SetLifeTime(0)
					particle:SetDieTime(0.5)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(2)
					particle:SetRoll(0)
					particle:SetEndSize(0.5)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(0, 0, 0))
					particle:SetColor(110, 150, 0, 255)
					particle:SetAirResistance(-1)
					particle:SetCollide(false)
					particle:SetBounce(0)
				end
			end
		end
		return true
	end
	self.Emitter:Finish()
	return false
end

function EFFECT:Render()
end