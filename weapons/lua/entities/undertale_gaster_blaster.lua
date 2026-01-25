if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("gaster_blaster_shooting")
end

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Editable = true
ENT.PrintName = "Gaster Blaster"
ENT.Spawnable = false
ENT.AdminSpawnable = false

local gaster_blasters = {}
if CLIENT then
	killicon.Add("undertale_gaster_blaster", "undertale/killicon_gaster_blaster", color_white)
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/evangelos/undertale/gasterblaster.mdl")
		self:SetTrigger(true)
		self:PhysicsInit(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetVar("CurTime", math.Rand(0, 60))
		self:ManipulateBoneAngles(0, Angle(0, 0, -30))
	end
	self:SetNW2Float("open", CurTime() + 0.75)
	self:SetNoDraw(true)
	if CLIENT then
		gaster_blasters[self] = self
		self:SetVar("ShootEffect", 0)
	end
end

function ENT:Think()
	if SERVER then
		self:SetNoDraw(false)
		local pos = self:GetVar("position", NULL)
		local self_pos = self:GetPos()
		local dist = pos:Distance(self_pos)
		if self:GetVar("distance", NULL) == NULL then
			self:SetVar("distance", dist)
			self:SetVar("scale", self:GetModelScale())
		end
		local scale = math.max(self:GetVar("scale", 0.01), 0.01)
		local saveDist = self:GetVar("distance")
		local cur_time = CurTime()
		local curtime = cur_time - self:GetVar("CurTime", NULL)
		local vec = Vector(math.cos(curtime), math.sin(curtime), math.sin(curtime) / 2)
		local numb = (cur_time - self:GetNW2Float("open", NULL)) * 6
		if (numb < 3) then
			self:SetPos(self_pos + (pos - self_pos) / 10 + vec * math.max(0.5, dist / 30))
		else
			if (numb > 10) then
				self:Remove()
			end
			self:SetPos(self_pos - self:GetForward() * (dist / 10 + 0.1))
		end
		if (dist < 15) then
			local value = math.sin(math.max(0, math.min(2, numb))) * 1.1
			if (numb > 0) then
				if (self:GetVar("shoot", NULL) == NULL) then
					self:SetVar("shoot", true)
					self:EmitSound("undertale/gaster_blaster/gaster_blaster_end.mp3", 100, 100, 1, CHAN_AUTO)
					local tr_line = util.TraceLine({
						start = self_pos,
						endpos = self_pos + self:GetForward() * 10000,
						filter = function(ent)
							if ent == self.Owner then return end
							if IsValid(ent) and !ent:IsPlayer() and !ent:IsNPC() then
								return true
							end
						end
					})
					local tr_hull = util.TraceHull({
						start = self_pos,
						endpos = tr_line.HitPos,
						filter = function(ent)
							if ent == self.Owner or ent == self then return end
							if IsValid(ent) then
								ent:TakeDamage(45 * math.Rand(0.75, 1.25), self.Owner, self)
								if ent:IsPlayer() or ent:IsNPC() then
									sound.Play("undertale/damage.wav", ent:GetPos())
								end
								return true
							end
						end,
						mins = Vector(-30, -30, -30),
						maxs = Vector(10, 10, 10)
					})
					net.Start("gaster_blaster_shooting")
						net.WriteEntity(self)
					net.Broadcast()
				end
				self:SetModelScale(scale)
			end
		else
			self:SetModelScale(scale * math.max(0, math.min(1, (saveDist - dist) / saveDist), 0))
		end
		self:NextThink(CurTime())
		return true
	end
end

if CLIENT then
	net.Receive("gaster_blaster_shooting", function()
		local read = net.ReadEntity()
		if !IsValid(read) then return end
		read:SetVar("ShootEffect", CurTime())
	end)

	local white = Material("lights/white")
	local function BlasterShooting(depth, sky)
		if sky then return end
		for _, ent in pairs(gaster_blasters) do
			if IsValid(ent) then
				local numb = (CurTime() - ent:GetNW2Float("open")) * 6
				if numb > 0 then
					local value = math.sin(math.max(0, math.min(2, numb))) * 1.1
					ent:ManipulateBoneScale(2, Vector(0, 0, 0))
					ent:ManipulateBoneAngles(1, Angle(180, 0, 0))
					ent:ManipulateBonePosition(1, Vector(9, 8, -6))
					ent:ManipulateBoneAngles(0, Angle(0, 0, -30) * value + Angle(0, 0, -30))
					ent:ManipulateBoneAngles(3, Angle(0, 0, -50) * value)
					ent:ManipulateBoneAngles(4, Angle(0, 0, -40) * value)
					ent:ManipulateBoneAngles(5, Angle(0, 0, -40) * value)
					ent:ManipulateBonePosition(4, Vector(-10, 0, -20) * value)
					ent:ManipulateBonePosition(5, Vector(10, 0, -20) * value)
				end
				if (ent:GetVar("ShootEffect", NULL) > 0) then
					numb = CurTime() - ent:GetVar("ShootEffect", NULL) 
					if (numb > 1) then
						ent:SetVar("ShootEffect", 0)
					end
					local pos = ent:GetPos()
					local tr_line = util.TraceLine({
						start = pos,
						endpos = pos + ent:GetForward() * 10000,
						filter = function(ent)
							if ent == self then return end
							if IsValid(ent) and !ent:IsPlayer() and !ent:IsNPC() then
								return true
							end
						end
					})
					render.SetMaterial(white)
					local size = math.max(0, math.min(1, math.sin(numb * 5) * 1.4))
					local pos = pos - ent:GetUp() * 20 - ent:GetForward() * 10
					local dir = tr_line.HitPos - pos
					dir:Normalize()
					local length = 25
					for i = 1, 5 do
						local forw = (17 + i * (length / 5))
						render.DrawBeam(pos + dir * (forw - (length / 5)), pos + dir * forw, (15 + 3 * i) * size, 1, 1, Color(255, 255, 255, 255)) 
					end
					render.DrawBeam(pos + dir * (16 + length), tr_line.HitPos, 30 * size, 1, 1, Color(255, 255, 255, 255))
				end
			else
				gaster_blasters[ent] = nil
			end
		end
	end
	hook.Add("PostDrawTranslucentRenderables", "gaster_blaster_shooting", BlasterShooting)
end