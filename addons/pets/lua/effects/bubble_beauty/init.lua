function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos()) 	 
end  

local delay = 0.05
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				if self.Entity:IsDormant() or self.Entity:GetNoDraw() then return true end
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("particle/particle_ring_sharp", pos + Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(0, 5)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(math.Rand(-4, 4), math.Rand(-4, 4), 10))
					particle:SetLifeTime(0)
					particle:SetDieTime(1)
					particle:SetStartAlpha(200)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.Rand(0, 1) + 1)
					particle:SetEndSize(math.Rand(0, 1) + 2)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(1, 1, 1))
					particle:SetRoll(math.Rand(0, 360))
					local val = math.random(100, 255)
					particle:SetColor(val, 255, 255, 255)
					particle:SetGravity(Vector(math.Rand(-5, 5), math.Rand(-5, 5), 120))
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