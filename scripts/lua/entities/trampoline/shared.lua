if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Trampolin"
ENT.Category = "Fun + Games"
ENT.Spawnable = true

function ENT:Boing()
	local seq = self:LookupSequence("bounce")
	if (seq == -1) then return end
	self:ResetSequence(seq)
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/gmod_tower/trampoline.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data, phys)
		local ent = data.HitEntity
		if !IsValid(ent) or ent:IsPlayer() then return end -- We handle Players from the SetupMove hook at the end of this file.
		local norm = data.HitNormal * -1
		local dot = self:GetUp():Dot(data.HitNormal)
		if math.abs(dot) < 0.5 then return end
		local scale = math.Rand(1, 1.25)
		local dist = 250 * scale
		local pitch = 100 * scale
		local mulNorm = norm * dist
		if (mulNorm.z < 0) then mulNorm.z = -mulNorm.z end
		if ent:IsNPC() then
			physent = ent
		else
			physent = ent:GetPhysicsObject()
		end
		if IsValid(physent) then
			physent:SetVelocity(mulNorm)
		end
		self:OnBounce(ent)
	end

	function ENT:OnBounce(ent)
		ent:EmitSound("gmt/misc/boing.wav", 85, pitch)
		self:Boing()
		local stars = EffectData()
		stars:SetOrigin(ent:GetPos())
		--stars:SetNormal()
		util.Effect("trampoline_stars", stars)
		umsg.Start("TrampolineJump")
			umsg.Entity(self)
		umsg.End()
	end
else
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
end

local ent_class = "trampoline"
hook.Add("SetupMove", "Trampoline", function(ply, mv)
	local ent = ply:GetGroundEntity()
	if IsValid(ent) and ent:GetClass() == ent_class then
		local normal = ent:GetAngles():Up()
		normal:Negate()
		local norm = normal * -1
		local dot = ent:GetUp():Dot(normal)
		if math.abs(dot) < 0.5 then return end
		local scale = util.SharedRandom("Trampoline", 1, 1.25)
		local dist = 250 * scale
		local pitch = 100 * scale
		local mulNorm = norm * dist
		if (mulNorm.z < 0) then mulNorm.z = -mulNorm.z end
		mv:SetVelocity(mv:GetVelocity() + mulNorm)

		if SERVER then
			ent:OnBounce(ply)
		else
			if !IsFirstTimePredicted() then return end
			ent:Boing()
		end
	end
end)