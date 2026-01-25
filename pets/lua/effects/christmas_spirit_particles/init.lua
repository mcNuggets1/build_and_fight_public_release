function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local mat
local delay = 0.1
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		local pos = self.Entity:GetPos()
		if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
			if self.Entity:IsDormant() or self.Entity:GetNoDraw() then return true end
			local ang = self.Entity:GetAngles()
			local particle
			if !self.NextEffect or (self.NextEffect < CurTime()) then
				mat = mat or Material("particles/snowflake.png", "noclamp smooth")
				self.Emitter:SetPos(pos)
				particle = self.Emitter:Add(mat, pos + Vector(math.Rand(-2.5, 2.5), math.Rand(-2.5, 2.5), math.Rand(-2, 2)))
				self.NextEffect = CurTime() + delay
			end
			if particle then
				particle:SetVelocity(Vector(math.Rand(-2, 2), math.Rand(-2, 2), -20))
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(0)
				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(1.5, 2))
				particle:SetStartSize(1)
				particle:SetRoll(math.Rand(-20, 20))
				particle:SetEndSize(math.Rand(1.5, 1.75))
				particle:SetAngles(Angle(0, 0, 0))
				particle:SetAngleVelocity(Angle(0, 0, 0))
				particle:SetAirResistance(0)
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