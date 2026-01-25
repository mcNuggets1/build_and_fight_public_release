function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local delay = 0.005
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				local particle2
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("particle/particle_smokegrenade1", pos + Vector(math.Rand(-3, 3), math.Rand(-3, 3), -10))
					particle2 = self.Emitter:Add("effects/spark", pos + Vector(math.Rand(-3, 3), math.Rand(-3, 3), -10))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(math.Rand(-25, 25), math.Rand(-25, 25), math.Rand(-35, 0)))
					particle:SetLifeTime(0)
					particle:SetDieTime(math.Rand(0.4, 0.6))
					particle:SetStartAlpha(50)
					particle:SetEndAlpha(0)
					particle:SetStartSize(1)
					particle:SetEndSize(10)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(1, 1, 1))
					particle:SetRoll(math.Rand(0, 360))
					particle:SetColor(255, 185, 255, 255)
					particle:SetGravity(Vector(0, 0, 25))
					particle:SetAirResistance(0)
					particle:SetCollide(false)
					particle:SetBounce(0)
				end
				if particle2 then
					particle2:SetVelocity(Vector(math.Rand(-25, 25), math.Rand(-25, 25), math.Rand(-35, 0)))
					particle2:SetLifeTime(0)
					particle2:SetDieTime(math.Rand(0.2, 0.6))
					particle2:SetStartAlpha(255)
					particle2:SetEndAlpha(0)
					particle2:SetStartSize(1)
					particle2:SetEndSize(math.Rand(0.2, 0.4))
					particle2:SetAngles(Angle(0, 0, 0))
					particle2:SetAngleVelocity(Angle(1, 1, 1))
					particle2:SetRoll(math.Rand(0, 360))
					particle2:SetColor(255, 185, 255, 255)
					particle2:SetGravity(Vector(0, 0, 25))
					particle2:SetAirResistance(0)
					particle2:SetCollide(false)
					particle2:SetBounce(0)
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