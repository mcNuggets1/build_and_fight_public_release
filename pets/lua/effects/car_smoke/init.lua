function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

local delay = 0.1
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("particle/particle_smokegrenade1", pos + self.Entity:GetForward() * -13)
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(self.Entity:GetForward() * -15)
					particle:SetLifeTime(0)
					particle:SetDieTime(1.5)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(1)
					particle:SetRoll(0)
					particle:SetEndSize(5)
					particle:SetAngles(Angle(math.Rand(0, 10), math.Rand(0, 10), math.Rand(0, 10)) )
					particle:SetAngleVelocity(Angle(math.Rand(0, 10), math.Rand(0, 10), math.Rand(0, 10)))
					particle:SetColor(200, 200, 255, 255)
					particle:SetGravity(Vector(0, 0, -5))
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