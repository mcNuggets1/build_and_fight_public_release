function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

local delay = 0.1
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("hud/win_panel_mvpstar", pos + Vector(math.Rand(-7.5, 7.5), math.Rand(-7.5, 7.5), math.Rand(-7.5, 7.5)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetAngles(Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180)))
					particle:SetAngleVelocity(Angle(math.Rand(-5, -5), math.Rand(-5, 5), math.Rand(-5, 5)))
					particle:SetCollide(true)
					particle:SetDieTime(math.Rand(0.8, 1))
					particle:SetEndAlpha(255)
					particle:SetStartAlpha(255)
					particle:SetStartSize(2.5)
					particle:SetEndSize(0)
					particle:SetVelocity(Vector(math.Rand(-15, 15), math.Rand(-15, 15), math.Rand(-15, 0)))
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