AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.DamageRadius = 150
ENT.DamageLength = 25
ENT.DamageCheck = 0.25
ENT.DamageInterval = 0.5
ENT.DamageAmount = 10
ENT.ActivationTime = 0.5

function ENT:Initialize()
	self:SetModel("models/Items/AR2_Grenade.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	local hitPos = self:GetPos()

	local owner = self:GetOwner()
	local activation_time = self.ActivationTime
	local damage = self.DamageAmount
	local radius = self.DamageRadius
	local check = self.DamageCheck
	local interval = self.DamageInterval
	local length = self.DamageLength
	local tname = "M9K_GasDamage_"..self:EntIndex()
	local count = 0

	timer.Simple(activation_time, function()
		if not IsValid(self) then return end
		timer.Create(tname, check, 0, function()
			if not IsValid(self) then
				timer.Remove(tname)
				return
			end
			count = count + check
			if count >= length then
				self:Remove()
				timer.Remove(tname)
				return
			end
			for _, v in ipairs(ents.FindInSphere(hitPos, radius)) do
				if v:IsPlayer() or v:IsNPC() then
					if not v.Alive or v:Alive() then
						local tr = util.TraceLine({
							start = self:GetPos() + Vector(0, 0, 10),
							endpos = v:EyePos(),
							filter = {self, v}
						})
						if tr.Entity == v or not tr.Hit then
							local curTime = CurTime()
							local poison_dmg = v.M9KGasDamage
							v.M9KGasDamage = poison_dmg and poison_dmg >= curTime and poison_dmg + (check * 2) + 0.01 or curTime + check + 0.01
							if hook.Call("M9K_OverwriteGasEffect", nil, v, self) == true then continue end
							if v.M9KGasDamage >= curTime + interval then
								v.M9KGasDamage = nil
								local dmg = damage * math.Rand(0.75, 1.25)
								local dmginfo = DamageInfo()
								dmginfo:SetDamageType(DMG_ACID)
								dmginfo:SetAttacker(owner)
								dmginfo:SetInflictor(self)
								dmginfo:SetDamage(dmg)
								v:TakeDamageInfo(dmginfo)
							end
						end
					end
				end
			end
		end)
	end)

	local filter = RecipientFilter()
	filter:AddAllPlayers()

	local edata = EffectData()
	edata:SetOrigin(hitPos)
	edata:SetRadius(radius)
	edata:SetMagnitude(length)
	util.Effect("m9k_released_gas", edata, true, filter)
end