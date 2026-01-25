if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Jump Pad"
ENT.Spawnable = false
 
function ENT:Initialize()
	if CLIENT then 
		local ply
		hook.Add("PostDrawTranslucentRenderables", self, function(self, depth, sky)
			if sky then return end
			ply = ply or LocalPlayer()
			if self:GetDrawPath() and ply == self:GetPlayer() then
				start = self:GetPos()
				local targetpos = self:GetPos()
				local ent
				if self:GetTargetType() == "string" and IsValid(ents.FindByName(self:GetTargetName())[1]) then
					targetpos = ents.FindByName(self:GetTargetName())[1]:GetPos()
				elseif self:GetTargetType() == "Entity" and IsValid(self:GetTargetEnt()) then
					targetpos = self:GetTargetEnt():GetPos()
					ent = self:GetTargetEnt()
				elseif self:GetTargetType() == "Vector" then
					targetpos = self:GetTargetPos()
				else
					targetpos = self:GetTargetPos()
				end
				local c = self:GetEffectColor() * 255
				local color = Color(c.r, c.g, c.b)
				self:DrawJumpPadTarget(start, self:GetHeightAdd(), color, targetpos, Vector(0, 0, 1), ent)
			end
		end)
	end
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(ONOFF_USE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetTrigger(true)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
		if self:HasSpawnFlags(1) then
			self:SetMoveType(MOVETYPE_NONE)
		end
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "HeightAdd")
	self:NetworkVar("Vector", 0, "EffectColor")
	self:NetworkVar("Bool",	1, "NoFallDamage")
	self:NetworkVar("Bool",	2, "DrawPath")
	self:NetworkVar("String", 0, "EffectName")
	self:NetworkVar("Entity", 0, "TargetEnt")
	self:NetworkVar("String", 1, "TargetName")
	self:NetworkVar("Vector", 1, "TargetPos")
	self:NetworkVar("String", 2, "TargetType")
	self:NetworkVar("String", 3, "SoundName", { KeyName = "soundname"} )
	self:NetworkVar("Int", 0, "Key")
	self:NetworkVar("Entity", 1, "Player")
	self:NetworkVarNotify("TargetEnt", self.OnTargetChanged)
	self:NetworkVarNotify("TargetName",	self.OnTargetChanged)
	self:NetworkVarNotify("TargetPos", self.OnTargetChanged)
	self:NetworkVarNotify("Player",	self.OnPlayerChanged)
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	local ent = ents.Create(ClassName)
	if !IsValid(ent) then return end
	ent:SetModel("models/highvoltage/ut2k4/pickups/jump_pad.mdl")
	ent:SetPos(SpawnPos)
	ent:SetAngles(SpawnAng)
	ent:SetPlayer(ply)
	ent:SetKey(0)
	ent:Spawn()
	ent:Activate()
	ent:SetTargetPos(ent:GetPos())
	ent:SetNoFallDamage(false)
	ent:SetHeightAdd(1)
	ent:SetEffectColor(Vector(255, 170, 0)/255)
	ent:SetSoundName("HV_Jump_pad_launch.wav")
	ent:SetEffectName("hv_jumppadfx")
	ply:AddCleanup("jumppads", ent)
	return ent
end

function ENT:OnTargetChanged(var,old,new)
	local _type = type(new)
	if _type == "Player" or _type == "Vehicle" or _type == "Weapon" or _type == "NPC" then _type = "Entity" end
	self:SetTargetType(_type)
end

function ENT:Think()
	if !SERVER then return end
	if self.LastLaunch and CurTime() > self.LastLaunch + 0.2 then
		self.LastLaunch = nil
		numpad.Deactivate(self:GetPlayer(), self:GetKey(), true)
	end
	self.LastEffect = self.LastEffect or 0
	if CurTime() > self.LastEffect then
		self.LastEffect = CurTime() + 0.1
		local targetpos = self:GetPos()
		if self:GetTargetType() == "string" and IsValid(ents.FindByName(self:GetTargetName())[1]) then
			targetpos = ents.FindByName(self:GetTargetName())[1]:GetPos()
		elseif self:GetTargetType() == "Entity" and IsValid(self:GetTargetEnt()) then
			targetpos = self:GetTargetEnt():GetPos()
		elseif self:GetTargetType() == "Vector" then
			targetpos = self:GetTargetPos()
		else
			targetpos = self:GetTargetPos()
		end
		local col = self:GetEffectColor()
		debugoverlay.Cross(targetpos, 8, 0.22, Color(0,255,0), true)
		local ang = self:GetVelo(targetpos, self:GetPos(), self:GetHeightAdd()):Angle()
		local edata = EffectData()
		edata:SetOrigin(self:GetPos())
		edata:SetStart(self:GetVelo(targetpos, self:GetPos(), self:GetHeightAdd()))
		edata:SetEntity(self)
		util.Effect(self:GetEffectName(), edata)
	end
end

function ENT:GetVelo(pos, pos2, time)
	local diff = pos - pos2
	local velx = diff.x/time
	local vely = diff.y/time
	local velz = (diff.z - 0.5 * (-GetConVar("sv_gravity"):GetInt()) * (time ^ 2)) / time
	return Vector(velx, vely, velz)
end	
	
function ENT:LaunchArc(pos, pos2, time, t)
	local v = self:GetVelo(pos, pos2, time).z
	local a = (-GetConVar("sv_gravity"):GetInt())
	local z = v * t + 0.5 * a * t ^ 2
	local diff = pos - pos2
	local x = diff.x * (t / time)
    local y = diff.y * (t / time)
	return pos2 + Vector(x, y, z)
end

function ENT:StartTouch(ent)
	if IsValid(ent) then
		local targetpos = Vector(0, 0, 0)
		if self:GetTargetType() == "string" and IsValid(ents.FindByName(self:GetTargetName())[1]) then
			targetpos = ents.FindByName(self:GetTargetName())[1]:GetPos()
		elseif self:GetTargetType() == "Entity" and IsValid(self:GetTargetEnt()) then
			targetpos = self:GetTargetEnt():GetPos()
		elseif self:GetTargetType() == "Vector" then
			targetpos = self:GetTargetPos()
		else
			targetpos = self:GetTargetPos()
		end
		local entphys = ent:GetPhysicsObject()
		if !ent:IsPlayer() and !ent:IsNPC() and IsValid(entphys) then
			entphys:SetVelocity(self:GetVelo(targetpos, ent:GetPos(), self:GetHeightAdd()))
		else
			if ent:IsPlayer() and self:GetNoFallDamage() then
				timer.Simple(0, function()
					if !IsValid(ent) then return end
					ent.NoFallDamage = true
				end)
			end
			ent:SetLocalVelocity(self:GetVelo(targetpos, ent:GetPos(), self:GetHeightAdd()))
		end
		self:EmitSound(self:GetSoundName())
		self:TriggerOutput("OnLaunch", self)
		numpad.Activate(self:GetPlayer(), self:GetKey(), true)
		self.LastLaunch = CurTime()
	end
end

hook.Add("OnPlayerHitGround", "JumpPad_GetFallDamage", function(ply, speed)
	if ply.NoFallDamage then
		timer.Simple(0, function()
			if !IsValid(ply) then return end
			ply.NoFallDamage = nil
		end)
	end
end)

hook.Add("GetFallDamage", "JumpPad_GetFallDamage", function(ply, speed)
	if ply.NoFallDamage then
		ply.NoFallDamage = nil
		return 0
	end
end)

function ENT:KeyValue(key, value)
	if (string.Left(key, 2) == "On") then
		self:StoreOutput(key, value)
	end
	if (key == "angles") then
		local Sep = string.Explode(" ", value)
		local ang = (Angle(Sep[1], Sep[2], Sep[3]))
		self.angle = ang
	end
	if (key == "target") then
		self:SetTargetName(value)
	end
	if (key == "z_modifier") then
		self:SetHeightAdd(value)	
	end
	if (key == "effect_col") then
		local Sep = string.Explode(" ", value)
		local Col = (Vector(Sep[1], Sep[2], Sep[3]))
		self:SetEffectColor(Col)
	end
	if (key == "model") then
		self:SetModel(value)	
	end
	if (key == "target_name") then
		self:SetTargetName(value)	
	end	
end

function ENT:AcceptInput(inputName, activator, called, data)
	if (inputName == "ChangeTarget") then
		self:SetTargetName(data)
	end
	if (inputName == "ChangeZMod") then
		self:SetHeightAdd(tonumber(data))
	end
end

if !CLIENT then return end

local mat = Material("vgui/circle")
local mat2 = Material("sprites/ut2k4/flashflare1")

local function colchange(num,col)
	return num == 1 and Color(240, 240, 240) or col
end

function ENT:DrawJumpPadTarget(start, height, color, target, normal, ent)
	local size = (math.sin(CurTime() * 3) * 8) + 32
	local segs = math.Clamp(math.Round(target:DistToSqr(start) / (40 * 40)), 8, 80)
	local count = 0
	local scroll = (CurTime() * -4)
	render.SetMaterial(mat2)
	render.StartBeam(segs + 2)
	render.AddBeam(start, 3, scroll, colchange(count%2,color))
	local lastpos = start
	local dist1 = lastpos:Distance(pos)
	local dist2 = pos:Distance(target)
	for i = 0, segs, 1 do
		count = count + 1
		local frac = i/segs
		local pos = self:LaunchArc(target, start, height, height*frac)
		scroll = scroll + dist1 / 12
		lastpos = pos
		render.AddBeam(pos, 9, scroll, colchange(count%2, color))
		if i == segs - 1 then
			local v = target - pos
			local v2 = v:GetNormal()
			local a = v2:Angle()
			local tr = util.QuickTrace(pos, v2 * (dist2 + 2), LocalPlayer())
			normal = tr.Hit and tr.HitNormal or v:GetNormal() * -1
		end
	end
	count = count + 1
	scroll = scroll + (lastpos:Distance(target)) / 12
	render.AddBeam(target, 1, scroll, colchange(count % 2,color))
	render.EndBeam()
	if ent then
		local s = (math.sin(CurTime() * 3) * 3) + 4
		halo.Add({ent}, color, s, s, 2)
	else
		render.SetMaterial(mat)
		render.DrawQuadEasy(target + normal, normal, size, size, Color(240, 240, 240), (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 1.35, size / 1.35, color, (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 2, size / 2, Color(240, 240, 240), (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 3.5, size / 3.5, color, (CurTime() * 50) % 360)
		render.DrawQuadEasy(target + normal, normal, size / 8, size / 8, Color(240, 240, 240), (CurTime() * 50) % 360)
	end
end