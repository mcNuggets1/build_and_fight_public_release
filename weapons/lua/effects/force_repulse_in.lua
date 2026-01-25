function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local rad = data:GetRadius()
	local emitter = ParticleEmitter(pos)
	if !emitter then return end
	local particle = emitter:Add("effects/rb655_splash_warpring1", pos)
	if particle then
		particle:SetLifeTime(0)
		particle:SetDieTime(0.5)
		particle:SetGravity(Vector(0, 0, 0))
		particle:SetVelocity(Vector(0, 0, 0))
		particle:SetStartSize(100)
		particle:SetEndSize(0)
		particle:SetStartAlpha(0)
		particle:SetEndAlpha(200)
		particle:SetColor(255, 255, 255)
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end