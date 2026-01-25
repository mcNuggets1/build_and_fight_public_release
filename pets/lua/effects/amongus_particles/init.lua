function EFFECT:Init(data)
	local ent = data:GetEntity()
	if !IsValid(ent) then return end
	self.Entity = ent
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

local mat = CreateMaterial("mg_amongus_effect_fix", "UnlitGeneric", {
	["$basetexture"] = "effects/redflare",
	["$additive"] = 1,
	["$translucent"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
})

local delay = 0.15
local dist = Pets.EffectRenderDistance * Pets.EffectRenderDistance
function EFFECT:Think()
	if IsValid(self.Entity) then
		if !self.Entity:IsDormant() and !self.Entity:GetNoDraw() then
			local pos = self.Entity:GetPos()
			if LocalPlayer():GetPos():DistToSqr(pos) <= dist then
				local particle
				if !self.NextEffect or (self.NextEffect < CurTime()) then
					self.Emitter:SetPos(pos)
					particle = self.Emitter:Add("!mg_amongus_effect_fix", pos + Vector(math.Rand(-5, 5), math.Rand(0, 5), math.Rand(0, 5)))
					self.NextEffect = CurTime() + delay
				end
				if particle then
					particle:SetVelocity(Vector(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(-2, 2)))
					particle:SetLifeTime(0)
					particle:SetDieTime(5)
					particle:SetStartAlpha(255)
					particle:SetEndAlpha(0)
					particle:SetStartSize(2)
					particle:SetEndSize(0)
					particle:SetAngles(Angle(0, 0, 0))
					particle:SetAngleVelocity(Angle(1, 1, 1))
					particle:SetRoll(math.Rand(0, 360))
					particle:SetColor(255, 255, 255, 255)
					particle:SetAirResistance(0) 
					particle:SetCollide(false)
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