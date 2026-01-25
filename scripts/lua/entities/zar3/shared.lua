ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "AR3 Geschütz"
ENT.Category = "Half-Life 2"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

local FindAR3At

function ENT:CanTool(ply, tr, mode)
	return mode == "remover" or mode == "colour" or mode == "material" or mode == "nocollide"
end

ENT.PhysgunDisabled = true

hook.Add("CanProperty", "ZAR3_CanProperty", function(ply, act, ent)
	if !IsValid(ent) or (ent:GetClass() ~= "zar3" and ent:GetModel() ~= "models/props_combine/combine_barricade_short01a.mdl") or (act ~= "bonemanipulate" and act ~= "drive" and act ~= "persist" and act ~= "nocollide_on" and act ~= "collision") then return end
	if ent:GetClass() == "zar3" then return false end
	if FindAR3At(ent) then return false end
end)

local function AR3Position(clamp)
	return clamp:GetPos() + clamp:GetUp()*10 - clamp:GetForward()*4
end

function FindAR3At(clamp)
	local pos = AR3Position(clamp)
	for _, v in ipairs(ents.FindInBox(pos - Vector(1, 1, 1), pos + Vector(1, 1, 1))) do
		if v:GetClass() == "zar3" then
			return v
		end
	end
	return false
end

ZAR3_FindAR3At, ZAR3_AR3Position = FindAR3At, AR3Position
properties.Add("zar3_collision_off", 
{
	MenuLabel = "Weltkollision deaktivieren",
	Order = -100,
	MenuIcon = "icon16/collision_off.png",
	Filter = 
		function(self, ent, ply)
			if !IsValid(ent) or (ent:GetClass() ~= "zar3" and !FindAR3At(ent)) then 
				return false 
			end
			local clamp = ent:GetClass() == "zar3" and ent:GetParent() or ent
			if !IsValid(clamp) then
				return false
			end
			if clamp:GetCollisionGroup() ~= COLLISION_GROUP_NONE then
				return false
			end
			if !gamemode.Call("CanProperty", ply, "zar3_nocollide", FindAR3At(clamp)) then 
				return false 
			end
			return true 
		end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive	= function(self, length, player)
		local ent = net.ReadEntity()
		if !self:Filter(ent, player) then return end
		local clamp = ent:GetClass() == "zar3" and ent:GetParent() or ent
		local phys = clamp:GetPhysicsObject()
		if !IsValid(phys) then return end
		phys:EnableCollisions(false)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:EnableMotion(false)
		clamp:SetCollisionGroup(COLLISION_GROUP_WORLD)
		clamp.ZAR3NoCollided = true
	end
})

properties.Add("zar3_collision_on", {
	MenuLabel = "Weltkollision aktivieren",
	Order = -99,
	MenuIcon = "icon16/collision_on.png",
	Filter = 
		function(self, ent, ply) 
			if !IsValid(ent) or (ent:GetClass() != "zar3" and !FindAR3At(ent)) then
				return false
			end
			local clamp = ent:GetClass() == "zar3" and ent:GetParent() or ent
			if !IsValid(clamp) then
				return false
			end
			if clamp:GetCollisionGroup() != COLLISION_GROUP_WORLD then
				return false
			end
			if !gamemode.Call("CanProperty", ply, "zar3_nocollide", FindAR3At(clamp)) then
				return false
			end
			return true
		end,	
	Action =
		function(self, ent)
			self:MsgStart()
				net.WriteEntity(ent)
			self:MsgEnd()
		end,
	Receive = 
		function(self, length, player)
			local ent = net.ReadEntity()
			if !self:Filter(ent, player) then return end
			local clamp = ent:GetClass() == "zar3" and ent:GetParent() or ent
			local phys = clamp:GetPhysicsObject()
			if !IsValid(phys) then return end
			phys:EnableCollisions(true)
			phys:EnableDrag(true)
			phys:EnableGravity(true)
			phys:EnableMotion(true)
			clamp:SetCollisionGroup(COLLISION_GROUP_NONE)
			clamp.ZAR3NoCollided = nil
		end
})