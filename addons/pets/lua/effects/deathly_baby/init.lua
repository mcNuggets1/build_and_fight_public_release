function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local delay = 0.03
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("particle/particle_smokegrenade", pos + Vector(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(7, -7))) 
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(math.Rand(-5, 5), math.Rand(-5, 5), math.Rand(5, 10)))
					particle:SetLifeTime(0)
					particle:SetDieTime(1)
					particle:SetStartAlpha(math.Rand(50, 255))
					particle:SetEndAlpha(0)
					particle:SetStartSize(5)
					particle:SetEndSize(10)
					particle:SetColor(255, 0, 255, 255)
					particle:SetGravity(Vector(0, 0, 50))
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