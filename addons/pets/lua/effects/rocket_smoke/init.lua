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
				local ang = self.Entity:GetAngles()
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("particle/particle_smokegrenade1", pos + ang:Forward() * -7 + Vector(0, 0, 2.5))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					local vec = ang:Forward()
					particle:SetVelocity(Vector(vec.x * math.Rand(-20, 0), vec.y * math.Rand(-20, 20), math.Rand(-1, 1)))
					particle:SetLifeTime(0)
					particle:SetDieTime(0.8)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.Rand(0.5, 2))
					particle:SetEndSize(math.Rand(6, 10) * 0.5)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(1, 1, 1))
					particle:SetRoll(math.Rand(0, 360))
					local val = math.random(50, 100)
					particle:SetColor(val, val, val, 255)
					particle:SetGravity(Vector(0, 0, 0))
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