if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Knochen"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if CLIENT then
	killicon.Add("undertale_bone_ground", "undertale/killicon_spear_bone", color_white)
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/undertale/undertale_bone.mdl")
		self:SetTrigger(true)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetVar("value", -50)
		self:SetVar("position", self:GetPos())
		self:SetVar("seed", math.Rand(0, 1))
		self:SetVar("reverse", false)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
	end
end

local sound1 = false
local bone_end = Sound("undertale/bone_end.wav")
function ENT:PhysicsUpdate()
	if SERVER and !self.DisableUpdate then
		local value = math.min(self:GetVar("value"), 35)
		local counter = self:GetVar("value")
		local seed = self:GetVar("seed", NULL)
		if self:GetVar("reverse", NULL) then
			self:SetVar("value", counter - 2)
			if value < -20 then
				self.DisableUpdate = true
				timer.Simple(0, function()
					SafeRemoveEntity(self)
				end)
			end
		else
			self:SetVar("value", counter + 2)
		end
		if value > 10 then
			if (value < 15) and !self:GetVar("reverse", NULL) and !sound1 then
				local pos = self:GetVar("pos", NULL)
				local normal = self:GetVar("normal", NULL)
				sound.Play(bone_end, pos + normal * 50)
				sound1 = true
				util.TraceHull({
					start = pos,
					endpos = pos + normal * 50,
					filter = function(ent)
						if IsValid(ent) then
							if ent == self.Owner then return end
							ent:TakeDamage(80 * math.Rand(0.75, 1.25), self.Owner, self)
							if ent:IsPlayer() or ent:IsNPC() then
								sound.Play("undertale/damage.wav", ent:GetPos())
							end
							return false
						end
					end,
					ignoreworld = true,
					mins = -Vector(30, 30, 30),
					maxs = Vector(30, 30, 30),
					mask = MASK_SHOT_HULL
				})
			end
		end
		if counter > 100 then
			self:SetVar("reverse", true)
			sound1 = false
		end
		local phys = self:GetPhysicsObject()
		local position = self:GetVar("position", NULL)
		local val1 = math.sin((math.max(0, value) + 50) / 10) * 30
		local val2 = (seed - 0.5) * 13
		self:SetPos(position + self:GetUp() * (val1 - val2 - 5))
	end
end