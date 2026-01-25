if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Meow Cat"

local meow_cat = Material("meowmere/effects/meow_cat.png")
local meow_cat_rev = Material("meowmere/effects/meow_cat_rev.png")

function ENT:Draw()
	local vel = self:GetVelocity()
	if (vel:LengthSqr() < 0.25) then vel = self:GetAngles():Forward() end
	vel:Normalize()
	local vz = vel:Angle().p
	vel:Rotate(Angle(0, 90, 0))
	vel.z = 0
	surface.SetDrawColor(color_white)
	render.SetMaterial(meow_cat)
	local getpos = self:GetPos()
	render.DrawQuadEasy(getpos, vel, 16, 16, color_white, -90 + vz)
	render.SetMaterial(meow_cat_rev)
	render.DrawQuadEasy(getpos, -vel, 16, 16, color_white, 90 - vz)
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_bugbait.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(self:GetForward() * 1500)
		end
		util.SpriteTrail(self, 0, color_white, true, 10, 0, 0.6, 10, "meowmere/effects/meow_trace.vmt")
		SafeRemoveEntityDelayed(self, 3)
	end

	local dmg = 35
	function ENT:PhysicsCollide(data, physobj)
		local vel = physobj:GetVelocity()
		vel.x = vel.x * math.Rand(1.25, 1.5)
		vel.y = vel.y * math.Rand(1.25, 1.5)
		vel.z = vel.z * math.Rand(1.5, 2)
		physobj:SetVelocity(vel)
		if data.Speed > 100 and data.DeltaTime > 0.2 then
			local ent = data.HitEntity
			if IsValid(ent) and (ent.MeowCatResistance or 0) then
				ent.MeowCatResistance = CurTime() + 0.4
				ent:TakeDamage(dmg * math.Rand(0.9, 1.1), self.Owner, self)
			end
			local edata = EffectData()
			edata:SetOrigin(data.HitPos - data.HitNormal * 3)
			edata:SetNormal(data.HitNormal)
			util.Effect("meowmere_impact", edata, true, true)
			sound.Play("weapons/meowmere/meow.wav", data.HitPos)
		end
	end
end