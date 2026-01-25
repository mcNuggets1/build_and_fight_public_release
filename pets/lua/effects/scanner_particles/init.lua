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
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("effects/blood_core", pos + Vector(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(3, 5)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(0, 0, -20))
					particle:SetLifeTime(0)
					particle:SetDieTime(0.6)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(4)
					particle:SetStartLength(15)
					particle:SetEndLength(0)
					particle:SetRoll(10)
					particle:SetEndSize(2)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(0, 0, 0))
					local val = math.random(20, 50)
					particle:SetColor(val, val, 0, 255)
					particle:SetAirResistance(-1)
					particle:SetGravity(Vector(0, 0, -100))
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