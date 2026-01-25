include("shared.lua")

local emitter = ParticleEmitter(Vector(0, 0, 0))
local function kernel_init(popcorn, vel)
	popcorn:SetColor(255, 255, 255, 255)
	popcorn:SetVelocity(vel or VectorRand():GetNormalized() * 15)
	popcorn:SetGravity(Vector(0, 0, -200))
	popcorn:SetLifeTime(0)
	popcorn:SetDieTime(math.Rand(5, 10))
	popcorn:SetStartSize(2)
	popcorn:SetEndSize(0)
	popcorn:SetStartAlpha(255)
	popcorn:SetEndAlpha(0)
	popcorn:SetCollide(true)
	popcorn:SetBounce(0.25)
	popcorn:SetRoll(math.pi * math.Rand(0, 1))
	popcorn:SetRollDelta(math.pi * math.Rand(-10, 10))
end

function ENT:Initialize()
	emitter:SetPos(LocalPlayer():GetPos())
	if IsValid(self) then
		local kt = "kernel_timer_"..self:EntIndex()
		timer.Create(kt, 0.01, 0, function()
			if !IsValid(self) then timer.Remove(kt) return end
			if math.Rand(0, 1) < 0.33 then
				local popcorn = emitter:Add("particle/popcorn-kernel", self:GetPos() + VectorRand():GetNormalized() * 4)
				if popcorn then
					kernel_init(popcorn)
				end
			end
		end)
	end
end

net.Receive("Popcorn_Explosion", function()
	if !emitter then return end
	local pos = net.ReadVector()
	local norm = net.ReadVector()
	local bucketvel = net.ReadVector()
	local entid = net.ReadFloat()
	timer.Remove("kernel_timer_"..entid)
	for i = 1, 300 do
		local explosion = emitter:Add("particle/popcorn-kernel", pos)
		if explosion then
			local dir = VectorRand():GetNormalized()
			kernel_init(explosion, ((-norm) + dir):GetNormalized() * math.Rand(0, 200) + bucketvel * 0.5)
		end
	end
end)