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
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.NextEffect = CurTime() + delay
					self.Emitter:SetPos(pos)
					local ang = self.Entity:GetAngles()
					local waves = {}
					waves[1] = ang + Angle(0, 65, 0)
					waves[2] = ang + Angle(0, -65, 0)
					for i=1, 2 do
						local particle = self.Emitter:Add("particle/particle_smokegrenade1", pos + ang:Forward() * 12 + Vector(0, 0, -2))
						if particle then
							local vec = waves[i]:Forward()
							particle:SetVelocity(Vector(vec.x * -20, vec.y * -20, 20))
							particle:SetLifeTime(0)
							particle:SetDieTime(1)
							particle:SetStartAlpha(255)
							particle:SetEndAlpha(0)
							particle:SetStartSize(1)
							particle:SetEndSize(10)
							particle:SetAngles(Angle(0, 0, 0))
							particle:SetAngleVelocity(Angle(1, 1, 1))
							particle:SetRoll(math.Rand(0, 360))
							local val = math.random(100, 125)
							particle:SetColor(val, val + 50, 255, 255)
							particle:SetGravity(Vector(vec.x * -30, vec.y * -30, -50))
							particle:SetAirResistance(0)
							particle:SetCollide(false)
							particle:SetBounce(0)
						end
					end
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