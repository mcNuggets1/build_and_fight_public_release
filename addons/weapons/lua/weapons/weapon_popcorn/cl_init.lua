include("shared.lua")

SWEP.DrawCrosshair = false

function SWEP:GetViewModelPosition(pos , ang)
	pos,ang = LocalToWorld(Vector(20,-10,-15),Angle(0,0,0),pos,ang)
	return pos, ang
end

local function kernel_init(particle, vel)
	particle:SetColor(255,255,255,255)
	particle:SetVelocity(vel or VectorRand():GetNormalized() * 15)
	particle:SetGravity(Vector(0,0,-200))
	particle:SetLifeTime(0)
	particle:SetDieTime(math.Rand(5,10))
	particle:SetStartSize(1)
	particle:SetEndSize(0)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetCollide(true)
	particle:SetBounce(0.25)
	particle:SetRoll(math.pi * math.Rand(0, 1))
	particle:SetRollDelta(math.pi * math.Rand(-4, 4))
end

local emitter = ParticleEmitter(Vector(0,0,0))
local function kernel_effect(ply, chance)
	local attachid = ply:LookupAttachment("eyes")
	emitter:SetPos(LocalPlayer():GetPos())
	local angpos = ply:GetAttachment(attachid)
	if !angpos then return end
	local fwd
	local pos
	if (ply != LocalPlayer()) then
		fwd = (angpos.Ang:Forward() - angpos.Ang:Up()):GetNormalized()
		pos = angpos.Pos + fwd * 3
	else
		fwd = ply:GetAimVector():GetNormalized()
		pos = ply:GetShootPos() + gui.ScreenToVector(ScrW() / 2, ScrH() / 4 * 3) * 10
	end
	for i=1, chance do
		local particle = emitter:Add("particle/popcorn-kernel", pos)
		if particle then
			local dir = VectorRand():GetNormalized()
			kernel_init(particle, ((fwd)+dir):GetNormalized() * math.Rand(0, 35))
		end
	end
end

net.Receive("Popcorn_Eat",function () 
	local ply = net.ReadEntity()
	if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass() != "weapon_popcorn" then return end
	kernel_effect(ply, math.random(8, 10))
	local entindex = ply:EntIndex()
	timer.Create("Popcorn_Eat"..entindex, 0.7, 5, function()
		if !IsValid(ply) or !ply:Alive() then timer.Remove("Popcorn_Eat"..entindex) return end
		kernel_effect(ply, math.random(1, 2))
	end)
end)

function GAMEMODE:MouthMoveAnimation(ply)
	local flex_num = ply:GetFlexNum() - 1
	if (flex_num <= 0) then return end
	local chewing = false
	local weight
	local chew_scale = ply.ChewScale or 0
	if (chew_scale > 0) then
		local x = CurTime() - ply.ChewStart
		weight = 0.5 * math.sin(x * (2 * math.pi / 0.625) - 0.5 * math.pi) + 0.5
		chewing = true
	end
	for i=0, flex_num - 1 do
		local Name = ply:GetFlexName(i)
		if (Name == "jaw_drop" or Name == "right_part" or Name == "left_part" or Name == "right_mouth_drop" or Name == "left_mouth_drop") then
			if ply:IsSpeaking() then
				ply:SetFlexWeight(i, math.Clamp(ply:VoiceVolume() * 2, 0, 2))
			elseif (chew_scale > 0) then
				ply.ChewScale = math.Clamp((ply.ChewStart + ply.ChewDur - CurTime()) / ply.ChewDur, 0, 1)
				if (Name == "jaw_drop") then
					ply:SetFlexWeight(i, weight * (chew_scale * 2))
				else
					ply:SetFlexWeight(i, weight * ((chew_scale * 2) - 1.25))
				end
			else
				ply:SetFlexWeight(i, 0)
			end
		end
	end
end