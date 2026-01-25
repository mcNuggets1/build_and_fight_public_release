AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MaxIntensityDistance = 384
ENT.FlashDistance = 1024
ENT.FlashDuration = 3

function ENT:Initialize()
	self:SetModel("models/weapons/w_eq_flashbang_thrown.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetBuoyancyRatio(0)
	end
	self.TimeLeft = CurTime() + 3
	self.NextImpact = 0
end

function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	if self.TimeLeft < CurTime() then
		self:Explode()
		return
	end
end

function ENT:PhysicsCollide(data, physobj)
	local vel = physobj:GetVelocity()
	local len = vel:Length()
	if len > 500 then
		physobj:SetVelocity(vel * 0.6)
	end
	if len > 100 then
		local cur_time = CurTime()
		if cur_time > self.NextImpact then
			self:EmitSound("weapons/smokegrenade/grenade_hit1.wav", 75, 100)
			self.NextImpact = cur_time + 0.1
		end
	end
end

local tr = {}
tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, CONTENTS_WATER)
function ENT:Explode()
	if self.Exploded then return end
	self.Exploded = true
	local hit_pos = self:GetPos()
	self:EmitSound("weapons/flashbang/flashbang_explode2.wav", 85, 100)
	util.Decal("SmallScorch", hit_pos, hit_pos - Vector(0, 0, 10), self)
	for key, obj in ipairs(player.GetAll()) do
		if obj:Alive() then
			local bone = obj:LookupBone("ValveBiped.Bip01_Head1")
			if bone then
				tr.filter = obj
				local head_pos, head_ang = obj:GetBonePosition(bone)
				local obj_aimvec = self.Owner:GetAimVector()
				local direction = (hit_pos - head_pos):GetNormal()
				local dot = obj_aimvec:DotProduct(direction)
				tr.start = head_pos
				tr.endpos = tr.start + direction * self.FlashDistance
				local trace = util.TraceLine(tr)
				local ent = trace.Entity
				if IsValid(ent) and ent == self then
					local hit_dist = self.FlashDistance * trace.Fraction
					local max_intens = (hit_dist - self.MaxIntensityDistance) < 0
					local decay = self.FlashDistance - self.MaxIntensityDistance
					local intensity = 0
					if max_intens then
						intensity = 1
					else
						local decay_dist = hit_dist - self.MaxIntensityDistance
						intensity = 1 - decay_dist / decay
					end
					intensity = math.min((intensity + 0.25) * dot, 1)
					local duration = intensity * self.FlashDuration
					umsg.Start("M9K_FLASHED", obj)
						umsg.Float(intensity)
						umsg.Float(duration)
					umsg.End()
				end
			end
		end
	end
	self:Remove()
end

function ENT:Fuse(t)
	t = t or 2.5
	timer.Simple(t, function()
		if self:IsValid() then
			self:Explode()
		end
	end)
end