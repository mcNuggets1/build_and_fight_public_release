include('shared.lua')

usermessage.Hook("TrampolineJump", function(um)
	local ent = um:ReadEntity()
	if !IsValid(ent) or !ent.Boing then return end
	ent:Boing()
end)

local EFFECT = {}
function EFFECT:Init(data)
	local Offset = data:GetOrigin()
	local Normal = data:GetNormal()
	local emitter = ParticleEmitter(Offset)
	for i=0, 8 do
		local star = emitter:Add("sprites/star", Offset)
		if star then
			local angle = Normal:Angle()
			star:SetVelocity(angle:Forward() * math.Rand(0, 200) + angle:Right() * math.Rand(-200, 200) + angle:Up() * math.Rand(-200, 200))
			star:SetLifeTime(0)
			star:SetDieTime(1)
			star:SetStartAlpha(255)
			star:SetEndAlpha(0)
			star:SetStartSize(8)
			star:SetEndSize(2)
			local col = Color(255, 0, 0)
			if i > 2 then
				col = Color(255, 255, 0)
				col.g = col.g - math.random(0, 50)
			end
			star:SetColor(col.r, col.g, math.Rand(0, 50))
			star:SetRoll(math.Rand(0, 360))
			star:SetRollDelta(math.Rand(-2, 2))
			star:SetAirResistance(100)
			star:SetGravity(Normal * 15)
		end
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

effects.Register(EFFECT, "trampoline_stars")