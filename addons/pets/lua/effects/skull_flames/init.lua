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
					particle = self.Emitter:Add("particles/flamelet3", pos)
					self.NextEffect = CurTime() + delay
				end
				if particle then	
					particle:SetVelocity(Vector(0, 0, 0))	
					particle:SetLifeTime(0)
					particle:SetDieTime(0.5)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(7)
					particle:SetEndSize(3)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(0, 0, 0))
					particle:SetRoll(math.Rand(0, 360))
					local val = math.random(150, 255)
					particle:SetColor(255, val, val , 150)
					particle:SetGravity(Vector(math.Rand(0, 5), math.Rand(0, 5), 100))
					particle:SetAirResistance(0)
					particle:SetCollide(false)
					particle:SetBounce(0)
				end
			end
		end
		return true
	end
	if self.Emitter then	self.Emitter:Finish()
	end
	return false
end

function EFFECT:Render()
end