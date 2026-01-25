AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local MAX_DISTANCE = 6000
local SPREAD = Vector(0.025, 0.025, 0)
local SHOT_INTERVAL = 0.02

local FindAR3At, AR3Position = ZAR3_FindAR3At, ZAR3_AR3Position
ZAR3_FindAR3At, ZAR3_AR3Position = nil, nil

function ENT:SpawnFunction(ply, tr)
	if !tr.Hit then return end
	local clamped = false
	if !IsValid(tr.Entity) or tr.Entity:GetModel() ~= "models/props_combine/combine_barricade_short01a.mdl" then
		local ent = ents.Create("prop_physics")
		if !IsValid(ent) then self:Remove() return end
		ent:SetModel("models/props_combine/combine_barricade_short01a.mdl")
		ent:SetPos(tr.HitPos + Vector(0, 0, 48))
		ent:SetAngles(Angle(0, math.NormalizeAngle(ply:EyeAngles().yaw-180), 0))
		ent:Spawn()
		ent:DropToFloor()
		local edata = EffectData()
		edata:SetOrigin(tr.Entity:GetPos())
		edata:SetNormal(tr.Entity:GetPos())
		edata:SetMagnitude(12)
		edata:SetScale(2)
		edata:SetRadius(6)
		util.Effect("Sparks", edata)
		if IsValid(ent:GetPhysicsObject()) then
			ent:GetPhysicsObject():EnableMotion(false)
		end
		tr.Entity = ent
		clamped = true
	end
	local clamp = tr.Entity
	if FindAR3At(clamp) then
		ply:PrintMessage(bit.bor(HUD_PRINTCONSOLE, HUD_PRINTTALK), "AR3-Geschütz konnte nicht erstellt werden (Bereits vor Ort).")
		tr.Entity:Remove()
		return
	end
	local ent = ents.Create("zar3")
	if !IsValid(ent) then self:Remove() return end
	ent:SetPos(AR3Position(clamp))
	ent:SetAngles(clamp:GetAngles())
	ent:SetParent(clamp)
	ent:Spawn()
	ent:Activate()
	clamp:DeleteOnRemove(ent)
	return clamped and clamp or ent
end

function ENT:Initialize()
	self:SetModel("models/props_combine/bunker_gun01.mdl")
	self:SetMoveType(MOVETYPE_NONE)	
	self:SetSolid(SOLID_VPHYSICS)	
	self:PhysicsInitShadow(false, false)
	self.NextShot = 0
	self:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	self.LocAng = Angle(0, 0, 0)
	self.LocAngVel = Angle(0, 0, 0)
	self:SetPoseParameter("aim_yaw", 0)
	self:SetPoseParameter("aim_pitch", 0)
	self:ResetSequence("idle_inactive")
	self:StartMotionController()
end

function ENT:Think()
	if IsValid(self.Controller) then
		self:GetPhysicsObject():Wake()
		if !self.Controller:Alive() or (self.Controller:GetPos() - self:GetPos()):LengthSqr() > MAX_DISTANCE then
			self:Abandon()
		elseif CurTime() > self.NextShot and self.Shooting then
			local muzzleTach = self:LookupAttachment("muzzle")
			local attach = self:GetAttachment(muzzleTach)
			local bullet = {}
			bullet.Num = 1
			bullet.Src = attach.Pos
			bullet.Dir = attach.Ang:Forward()
			bullet.Spread = SPREAD
			bullet.Tracer = 1
			bullet.TracerName = "AR2Tracer"
			bullet.Force = 15
			bullet.Damage = 10 * math.Rand(0.75,1.25)
			bullet.Attacker = self.Controller
			self:FireBullets(bullet)
			local effd = EffectData()
			effd:SetEntity(self)
			effd:SetAngles(attach.Ang)
			effd:SetOrigin(attach.Pos + attach.Ang:Forward()*5)
			effd:SetScale(1)
			effd:SetAttachment(muzzleTach)
			effd:SetFlags(5)
			util.Effect("MuzzleFlash", effd)
			self:EmitSound("Weapon_FuncTank.Single")		
			self.NextShot = CurTime() + SHOT_INTERVAL
			self:ResetSequence("fire")
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:TakeOver(ply)
	if IsValid(self.Controller) or IsValid(ply.ZAR3) then return end
	self:EmitSound("Func_Tank.BeginUse")
	ply:Flashlight(false)
	local seq, dur = self:LookupSequence("activate")
	self:ResetSequence(seq)
	timer.Simple(dur, function()
		if IsValid(ply) and ply.ZAR3 == self then
			self.Controller = ply
		end
	end)
	self.NextShot = CurTime() + dur
	umsg.Start("ZAR3_S", ply)
		umsg.Entity(self)
	umsg.End()
	timer.Simple(dur, function()
		if IsValid(self) and IsValid(self:GetPhysicsObject()) then
			self:GetPhysicsObject():Wake()
		end
	end)
	ply.ZAR3 = self
end

function ENT:Use(activator, caller)
	if (activator:GetPos() - self:GetPos()):LengthSqr() > MAX_DISTANCE then return end
	if IsValid(self.Controller) then
		if self.Controller == activator then
			self:Abandon()
		end
		return
	end
	self:TakeOver(activator)
end

function ENT:Abandon()
	self:ResetSequence("retract")
	umsg.Start("ZAR3_S", self.Controller)
		umsg.Entity(NULL)
	umsg.End()
	self.Controller.ZAR3 = nil
	self.Controller = nil
	self.Shooting = false
	self:SetPoseParameter("aim_yaw", "0")
	self:SetPoseParameter("aim_pitch", "0")
	self.LocAng = Angle(0, 0, 0)
	self:GetPhysicsObject():Sleep()
end

function ENT:EnableFlashlight()
	if !IsValid(self.Flashlight) then
		self:CreateFlashlight()
	end
	if !IsValid(self.FlashlightFocus) then
		local lightAttach = self:LookupAttachment("light")
		local attach = self:GetAttachment(lightAttach)
		local flashlight = ents.Create("env_projectedtexture")
		if !IsValid(flashlight) then return end
		flashlight:SetPos(attach.Pos)
		flashlight:SetAngles(attach.Ang)
		flashlight:SetKeyValue("enableshadows", "1")
		flashlight:SetKeyValue("farz", "2048")
		flashlight:SetKeyValue("nearz", "8")
		flashlight:SetKeyValue("lightfov", "23")
		flashlight:SetKeyValue("lightcolor", "147 226 240")
		flashlight:Spawn()
		flashlight:Fire("SpotlightTexture", "effects/flashlight001")
		flashlight:SetParent(self)
		flashlight:Fire("SetParentAttachment", "light")
		self.FlashlightFocus = flashlight
	end
	self.Flashlight:Fire("LightOn")
	self.FlashlightOn = true
end

local function FindCone(ent, retry)
	if !IsValid(ent) or !IsValid(ent.Flashlight) then
		if retry < 10 then
			timer.Simple(1, function() FindCone(ent, retry + 1) end)
		end
		return
	end
	for _,v in ipairs(ents.FindByClass("spotlight_end")) do
		if v:GetOwner() == ent.Flashlight then
			ent.FlashlightCone = v
			return
		end
	end
	if retry < 10 then
		timer.Simple(1, function() FindCone(ent, retry + 1) end)
	end
end

function ENT:CreateFlashlight()
	if !IsValid(self.Flashlight) then
		local lightAttach = self:LookupAttachment("light")
		local attach = self:GetAttachment(lightAttach)
		local flashlight = ents.Create("point_spotlight")
		if !IsValid(flashlight) then return end
		flashlight:SetPos(attach.Pos)
		flashlight:SetAngles(attach.Ang)
		flashlight:SetKeyValue("maxdxlevel", "0")
		flashlight:SetKeyValue("mindxlevel", "0")
		flashlight:SetKeyValue("rendermode", "0")
		flashlight:SetKeyValue("disablereceivershadows", "0")
		flashlight:SetKeyValue("renderfx", "0")
		flashlight:SetKeyValue("HDRColorScale", "1.0")
		flashlight:SetKeyValue("spotlightwidth", "70")
		flashlight:SetKeyValue("renderamt", "255")
		flashlight:SetKeyValue("spotlightlength", "2048")
		flashlight:SetKeyValue("rendercolor", "147 226 240")
		flashlight:SetKeyValue("spawnflags", "0")
		flashlight:Spawn()
		flashlight:SetParent(self)
		flashlight:Fire("SetParentAttachment", "light")
		timer.Simple(0, function()
			if !IsValid(self) then return end
			FindCone(self, 0)
		end)
		self.Flashlight = flashlight
		self.FlashlightOn = false
	end
end

function ENT:DisableFlashlight()
	if IsValid(self.Flashlight) then
		self.Flashlight:Fire("LightOff")
		self.FlashlightOn = false
	end
	if IsValid(self.FlashlightFocus) then
		self.FlashlightFocus:Remove()
	end
end

function ENT:TrackTarget()
	local angles = self:AimBarrelAtPlayerCrosshair()
	local currentAngles = self.LocAng
	local yawDiff = math.Clamp(math.AngleDifference(angles.yaw, currentAngles.yaw), -5, 5)
	local pitchDiff = math.Clamp(math.AngleDifference(angles.pitch, currentAngles.pitch), -5, 5)
	self.LocAng.yaw = math.NormalizeAngle(currentAngles.yaw + yawDiff)
	self.LocAng.pitch = math.NormalizeAngle(currentAngles.pitch + pitchDiff)
end

function ENT:CalcPlayerCrosshairTarget()
	local player = self.Controller
	local vecStart, vecDir
	vecStart = player:EyePos()
	vecDir = player:GetAimVector()
	local tr = util.TraceLine({ start = vecStart + vecDir * 24, endpos = vecStart + vecDir * 8192, mask = MASK_OPAQUE_AND_NPCS, filter = { self, player, self:GetParent() }})
	return tr.HitPos
end

function ENT:AimBarrelAtPlayerCrosshair()
	local vecTarget = self:CalcPlayerCrosshairTarget()
	return self:AimBarrelAt(self:WorldToLocal(vecTarget))
end

function ENT:AimBarrelAt(parentTarget)
	local m_barrelPos = Vector(20.8, 0, 18.15)
	local target = parentTarget - self:WorldToLocal(self:GetAttachment(self:LookupAttachment("aimrotation")).Pos)
	local quadTarget = target:LengthSqr()
	local quadTargetXY = target.x*target.x + target.y*target.y
	local targetToCenterYaw = math.atan2(target.y, target.x)
	local centerToGunYaw = math.atan2(m_barrelPos.y, math.sqrt(quadTarget - (m_barrelPos.y*m_barrelPos.y)))
	local targetToCenterPitch = math.atan2(target.z, math.sqrt(quadTargetXY))
	local centerToGunPitch = math.atan2(-m_barrelPos.z, math.sqrt(quadTarget - (m_barrelPos.z*m_barrelPos.z)))
	return Angle(math.NormalizeAngle(-math.Rad2Deg(targetToCenterPitch + centerToGunPitch)), math.NormalizeAngle(math.Rad2Deg(targetToCenterYaw + centerToGunYaw)), 0)
end

local m_yawCenter, m_pitchCenter = 0, 7.5
local m_yawRange, m_yawTolerance = 60, 15
local m_pitchRange, m_pitchTolerance = 60, 15
local m_yawRate, m_pitchRate = 200, 120
function ENT:RotateTankToAngles(angles)
	local bClamped = false
	local offsetY = math.AngleDifference(angles.yaw, m_yawCenter)
	local offsetX = math.AngleDifference(angles.pitch, m_pitchCenter)
	local flActualYaw = m_yawCenter + offsetY
	local flActualPitch = m_pitchCenter + offsetX
	if (math.abs(offsetY) > m_yawRange + m_yawTolerance) or (math.abs(offsetX) > m_pitchRange + m_pitchTolerance) then
		flActualYaw = math.Clamp(flActualYaw, m_yawCenter - m_yawRange, m_yawCenter + m_yawRange)
		flActualPitch = math.Clamp(flActualPitch, m_pitchCenter - m_pitchRange, m_pitchCenter + m_pitchRange)
		bClamped = true
	end
	local vecAngVel = self.LocAngVel
	local distY = math.AngleDifference(flActualYaw, self:GetPoseParameter("aim_yaw"))
	vecAngVel.yaw = distY * 10
	vecAngVel.yaw = math.Clamp(vecAngVel.yaw, -m_yawRate, m_yawRate)
	local distX = math.AngleDifference(flActualPitch, self:GetPoseParameter("aim_pitch"))
	vecAngVel.pitch = distX * 10
	vecAngVel.pitch = math.Clamp(vecAngVel.pitch, -m_pitchRate, m_pitchRate)
	self.LocAngVel = vecAngVel
	return bClamped
end

function ENT:PhysicsSimulate()
	if !IsValid(self) or !IsValid(self.Controller) then return SIM_NOTHING end
	local newAngles = self.Controller:EyeAngles()
	newAngles.pitch = math.NormalizeAngle(newAngles.pitch - self:GetAngles().pitch)
	newAngles.yaw = math.NormalizeAngle(newAngles.yaw - self:GetAngles().yaw)
	local angles = Angle(self:GetPoseParameter("aim_pitch"), self:GetPoseParameter("aim_yaw"), 0)
	local newPitch = math.Clamp(math.AngleDifference(newAngles.pitch + 7, angles.pitch), -1, 1)
	local newYaw = math.Clamp(math.AngleDifference(newAngles.yaw, angles.yaw), -2, 2)
	self:SetPoseParameter("aim_yaw", math.Clamp(math.NormalizeAngle(angles.yaw + newYaw), -60, 60))
	self:SetPoseParameter("aim_pitch", math.Clamp(math.NormalizeAngle(angles.pitch + newPitch), -35, 50))
	return SIM_NOTHING
end

function ENT:OnRemove()
	FindCone(self, 10)
	self:DisableFlashlight()
	if IsValid(self.Controller) then
		self:Abandon()
	end
	if IsValid(self.FlashlightCone) then
		self.FlashlightCone:Remove()
	end
end

concommand.Add("zar3_attack", function(ply, cmd, args)
	if !IsValid(ply.ZAR3) or !args or !args[1] then return end
	ply.ZAR3.Shooting = args[1] == "1"
end)

hook.Add("PlayerSwitchFlashlight", "ZAR3_PlayerSwitchFlashlight", function(ply, on)
	if IsValid(ply.ZAR3) then
		ply.ZAR3[(ply.ZAR3.FlashlightOn and "Disable" or "Enable").. "Flashlight"](ply.ZAR3)
		return false
	end
end)

hook.Add("PhysgunDrop", "ZAR3_PhysgunDrop", function(ply, ent)
	if IsValid(ent) and ent.ZAR3NoCollided then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end)