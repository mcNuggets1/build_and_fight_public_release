function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local delay = 0.07
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("effects/spark", pos + Vector(math.Rand(-3, 3), math.Rand(-3, 3), math.Rand(4, 6))) 
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(math.Rand(-50, 50), math.Rand(-50, 50), math.Rand(-20, -10)))
					particle:SetLifeTime(0)
					particle:SetDieTime(0.5)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(3)
					particle:SetRoll(0)
					particle:SetEndSize(1)
					particle:SetAngles(Angle(math.Rand(0, 10), math.Rand(0, 10), math.Rand(0, 10)) )
					particle:SetAngleVelocity(Angle(math.Rand(0, 10), math.Rand(0, 10), math.Rand(0, 10)))
					local val = math.random(150, 200)
					particle:SetColor(200, 200, 255, 255)
					particle:SetGravity(Vector(0, 0, 120))
					particle:SetAirResistance(20)
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