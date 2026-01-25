function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local delay = 0.35
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		local pos = self.Entity:GetPos()
		if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
			if self.Entity:IsDormant() or self.Entity:GetNoDraw() then return true end
			local ang = self.Entity:GetAngles()
			local particle
			if !self.NextEffect or (self.NextEffect < CurTime()) then
				self.Emitter:SetPos(pos)
				particle = self.Emitter:Add("effects/energysplash", pos + ang:Forward() * math.Rand(-8, 5))
				self.NextEffect = CurTime() + delay
			end
			if particle then
				particle:SetVelocity(Vector(math.Rand(-1, 1), math.Rand(-1, 1), -70))
				particle:SetStartAlpha(100)
				particle:SetEndAlpha(0)
				particle:SetLifeTime(0)
				particle:SetDieTime(0.5)
				particle:SetStartSize(1)
				particle:SetRoll(10)
				particle:SetEndSize(2)
				particle:SetAngles(Angle(0, 0, 0))
				particle:SetAngleVelocity(Angle(0, 0, 0))
				local val = math.random(190, 210)
				particle:SetColor(val, 204, 255, 255)
				particle:SetAirResistance(-100)
				particle:SetCollide(false)
				particle:SetBounce(0)
			end
		end
		return true
	end
	self.Emitter:Finish()
	return false
end

function EFFECT:Render()
end