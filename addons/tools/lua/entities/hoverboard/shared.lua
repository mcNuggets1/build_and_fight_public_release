ENT.Type = "vehicle"
ENT.Base = "base_anim"
ENT.PrintName = "Hoverboard"
ENT.Spawnable = false

ENT.ThrusterPoints = {
	{Pos = Vector(-24, 13, 24)},
	{Pos = Vector(24, 13, 20)},
	{Pos = Vector(-24, -13, 24)},
	{Pos = Vector(24, -13, 20)},
	{Pos = Vector(-48, 0, 24), Diff = 24, Spring = 3}
}

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "BoostShake")
	self:NetworkVar("Float", 1, "BoardVelocity")
	self:NetworkVar("Float", 2, "MaxLength")
	self:NetworkVar("Float", 3, "TrailScale")
	self:NetworkVar("Float", 4, "BoardRotation")
	self:NetworkVar("String", 0, "HoverHeight")
	self:NetworkVar("String", 1, "ViewDistance")
	self:NetworkVar("String", 2, "EffectCount")
	self:NetworkVar("Bool", 0, "DarkInner")
	self:NetworkVar("Vector", 0, "TrailColor")
	self:NetworkVar("Vector", 1, "TrailBoostColor")
	self:NetworkVar("Vector", 2, "TrailRechargeColor")
	self:NetworkVar("Entity", 0, "ScriptedVehicle")
end

function ENT:GetDriver()
	return self:GetOwner()
end

hook.Add("ShouldDrawLocalPlayer", "Hoverboard_Draw", function()
	if IsValid(LocalPlayer():GetNWEntity("ScriptedVehicle")) then
		return false
	end
end)

hook.Add("CalcView", "Hoverboard_CalcView", function(ply, pos, ang, fov)
	local ent = ply:GetNWEntity("ScriptedVehicle")
	if (!IsValid(ent) or ent:GetClass() != "hoverboard") then return end
	if (ply:InVehicle() or !ply:Alive() or ply:GetViewEntity() != ply) then return end
	local dir = ang:Forward()
	local pos = ent:GetPos() + Vector(0, 0, 64) - (dir * (tonumber(ent:GetViewDistance())))
	local speed = ent:GetVelocity():Length() - 500
	if (ent:IsBoosting() and speed > 0 and ent:GetBoostShake() == 1) then
		local power = 14 * (speed / 700)
		local x = math.Rand(-power, power) * 0.1
		local y = math.Rand(-power, power) * 0.1
		local z = math.Rand(-power, power) * 0.1
		pos = pos + Vector(x, y, z)
	end
	local tr = util.TraceHull({
		start = ent:GetPos() + Vector(0, 0, 64),
		endpos = pos,
		filter = {ent, ply, ent:GetNW2Entity("Avatar", NULL)},
		mask = MASK_NPCWORLDSTATIC,
		mins = Vector(-4, -4, -4),
		maxs = Vector(4, 4, 4)
	})
	local view = {
		origin = tr.HitPos,
		angles = dir:Angle(),
		fov = fov,
	}
	return view
end)

function ENT:IsGrinding()
	return self:GetNW2Bool("Grinding")
end

function ENT:Boost()
	return self:GetNW2Int("Boost")
end

function ENT:IsBoosting()
	return self:GetNW2Bool("Boosting")
end

function ENT:GetThruster(index)
	local pos = self:LocalToWorld(self.ThrusterPoints[index].Pos)
	local dist = (self:GetPos() - pos):Length()
	local dir = (pos - self:GetPos()):GetNormalized()
	dir = dir:Angle()
	dir:RotateAroundAxis(self:GetUp(), self:GetBoardRotation())
	dir = dir:Forward()
	return self:GetPos() + dir * dist
end

local function HoverboardMove(ply, mv)
	local board = ply:GetNWEntity("ScriptedVehicle")
	if (!IsValid(board) or board:GetClass() != "hoverboard") then return end
	mv:SetOrigin(board:GetPos())
	return true
end
hook.Add("Move", "Hoverboard_Move", HoverboardMove)

local function UpdateAnimation(ply)
	local board = ply:GetNWEntity("ScriptedVehicle")
	if (!IsValid(board) or board:GetClass() != "hoverboard") then return end
	local pose_params = {"head_pitch", "head_yaw", "body_yaw", "aim_yaw", "aim_pitch"}
	for _, param in pairs(pose_params) do
		if IsValid(board.Avatar) then
			local val = ply:GetPoseParameter(param)
			board.Avatar:SetPoseParameter(param, val)
		end
	end
end
hook.Add("UpdateAnimation", "Hoverboard_UpdateAnimation", UpdateAnimation)