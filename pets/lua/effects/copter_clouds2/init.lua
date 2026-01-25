function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

local delay = 0.001
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("particle/particle_smokegrenade1", pos + Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(-6.5, 2.5)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(math.Rand(-4, 4), math.Rand(-4, 4), math.Rand(0, 1)))
					particle:SetLifeTime(0)
					particle:SetDieTime(1.5)
					particle:SetStartAlpha(0)
					particle:SetEndAlpha(255)
					particle:SetStartSize(3)
					particle:SetEndSize(0)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(1, 1, 1))
					particle:SetRoll(math.Rand(0, 360))
					particle:SetColor(255, 255, 255, 255)
					particle:SetGravity(Vector(0, 0, -10))
					particle:SetAirResistance(0) 
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