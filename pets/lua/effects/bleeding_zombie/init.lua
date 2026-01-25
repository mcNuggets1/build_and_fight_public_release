function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end  

local delay = 0.05
local delay2 = 0.1
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				self.Emitter:SetPos(pos)
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					particle = self.Emitter:Add("effects/blood_core", pos + self.Entity:GetForward()*-7 + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(1, 2)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(0, 0, -70))
					particle:SetLifeTime(0)
					particle:SetDieTime(0.9)
					particle:SetStartAlpha(math.random(100, 255))
					particle:SetEndAlpha(0)
					particle:SetStartSize(2)
					particle:SetRoll(10)
					particle:SetEndSize(3)
					local val = math.random(150, 200)
					particle:SetColor(val, 20, 0, 255)
					particle:SetAirResistance(-5)
					particle:SetCollide(false)
					particle:SetBounce(0)
				end
				if !self.NextEffect2 or (self.NextEffect2 < CurTime()) then
					particle = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), pos + self.Entity:GetForward() * -7 + Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(1, 2)))
					self.NextEffect2 = CurTime() + delay2
				end
				if particle then
					particle:SetVelocity(Vector(0, 0, -80))
					particle:SetLifeTime(0)
					particle:SetDieTime(0.9)
					particle:SetStartAlpha(math.random(50, 100))
					particle:SetEndAlpha(0)
					particle:SetStartSize(3)
					particle:SetRoll(10)
					particle:SetEndSize(5)
					local val = math.random(150, 200)
					particle:SetColor(val, 20, 0, 255)
					particle:SetAirResistance(-5)
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