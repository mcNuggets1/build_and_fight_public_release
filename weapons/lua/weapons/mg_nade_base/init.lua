AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:InitServer()
end

function SWEP:DeployServer()
end

function SWEP:HolsterServer()
end

function SWEP:OffsetGrenade(grenade)
	local owner = self.Owner
	local aim = owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	grenade:SetPos(owner:GetShootPos() + side * 5 + up * -1)
	grenade:SetAngles(owner:EyeAngles())
	return false
end

function SWEP:CreateGrenade(vel, ent_name)
	local owner = self.Owner
	ent_name = ent_name or self.Primary.Round
	local grenade = ents.Create(ent_name)
	if !IsValid(grenade) then return end
	self:OffsetGrenade(grenade)
	grenade:SetOwner(owner)
	grenade.Owner = owner
	grenade:Spawn()
	grenade:Activate()
	grenade.TimeLeft = self:GetDetTime()
	local phys = grenade:GetPhysicsObject()
	if IsValid(phys) then
		phys:ApplyForceCenter(owner:EyeAngles():Forward() * (vel or 4000))
		phys:AddAngleVelocity(Vector(math.Rand(-500, 500), math.Rand(-500, 500), math.Rand(-500, 500)))
	end
end

function SWEP:BlowInFace(ent_name)
	local owner = self.Owner
	ent_name = ent_name or self.Primary.Round
	local grenade = ents.Create(ent_name)
	if IsValid(grenade) then
		self:OffsetGrenade(grenade)
		grenade:SetOwner(owner)
		grenade.Owner = owner
		grenade:Spawn()
		grenade:Activate()
		grenade.TimeLeft = 0
	end
end