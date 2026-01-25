TOOL.Category = "Build & Fight"
TOOL.Name = "#tool.hoverboard.name"

AddCSLuaFile("vgui/hoverboard_gui.lua")

TOOL.Information = {
	{name = "left"},
	{name = "right"}
}

cleanup.Register("hoverboards")

for _, hbt in pairs(HoverboardTypes) do
	list.Set("HoverboardModels", hbt["model"], {})
	util.PrecacheModel(hbt["model"])
end

TOOL.ClientConVar["model"] = "models/UT3/hoverboard.mdl"
TOOL.ClientConVar["lights"] = 0
TOOL.ClientConVar["mousecontrol"] = 1
TOOL.ClientConVar["boostshake"] = 1
TOOL.ClientConVar["height"] = 72
TOOL.ClientConVar["viewdist"] = 128
TOOL.ClientConVar["trail_size"] = 5
TOOL.ClientConVar["trail_r"] = 128
TOOL.ClientConVar["trail_g"] = 128
TOOL.ClientConVar["trail_b"] = 255
TOOL.ClientConVar["boost_r"] = 128
TOOL.ClientConVar["boost_g"] = 255
TOOL.ClientConVar["boost_b"] = 128
TOOL.ClientConVar["recharge_r"] = 255
TOOL.ClientConVar["recharge_g"] = 128
TOOL.ClientConVar["recharge_b"] = 128
TOOL.ClientConVar["speed"] = 10
TOOL.ClientConVar["jump"] = 10
TOOL.ClientConVar["turn"] = 10
TOOL.ClientConVar["flip"] = 10
TOOL.ClientConVar["twist"] = 5

function TOOL:LeftClick(trace)
	local result, hoverboard = self:CreateBoard(trace)
	return result
end

function TOOL:RightClick(trace)
	local result, hoverboard = self:CreateBoard(trace)
	if CLIENT then return result end
	if IsValid(hoverboard) then
		local pl = self:GetOwner()
		local dist = (hoverboard:GetPos() - pl:GetPos()):LengthSqr()
		if (dist <= 262144) then
			timer.Simple(0.25, function()
				if (IsValid(hoverboard) and IsValid(pl)) then hoverboard:SetDriver(pl) end
			end)
		end
	end
	return result
end

function TOOL:CreateBoard(trace)
	if CLIENT then return true end
	local ply = self:GetOwner()
	if (GetConVar("sv_hoverboard_adminonly"):GetBool() and !(ply:IsAdmin() or ply:IsSuperAdmin())) then return false end
	local model = self:GetClientInfo("model")
	local mcontrol = self:GetClientNumber("mousecontrol")
	local shake = self:GetClientNumber("boostshake")
	local trailsize = math.Clamp(self:GetClientNumber("trail_size"), 0, 10)
	local height = math.Clamp(self:GetClientNumber("height"), 36, 100)
	local viewdist = math.Clamp(self:GetClientNumber("viewdist"), 64, 256)
	local trail = Vector(self:GetClientNumber("trail_r"), self:GetClientNumber("trail_g"), self:GetClientNumber("trail_b"))
	local boost = Vector(self:GetClientNumber("boost_r"), self:GetClientNumber("boost_g"), self:GetClientNumber("boost_b"))
	local recharge = Vector(self:GetClientNumber("recharge_r"), self:GetClientNumber("recharge_g"), self:GetClientNumber("recharge_b"))
	local attributes = {
		speed = math.Clamp(self:GetClientNumber("speed"), 4, 16),
		jump = math.Clamp(self:GetClientNumber("jump"), 4, 16),
		turn = math.Clamp(self:GetClientNumber("turn"), 4, 16),
		flip = math.Clamp(self:GetClientNumber("flip"), 4, 16),
		twist = math.Clamp(self:GetClientNumber("twist"), 4, 16)
	}
	local ang = ply:GetAngles()
	ang.p = 0
	ang.y = ang.y + 180
	local pos = trace.HitPos + trace.HitNormal * 32
	local hoverboard = MakeHoverboard(ply, model, ang, pos, mcontrol, shake, height, viewdist, trailsize, trail, boost, recharge, attributes)
	if !IsValid(hoverboard) then return false end
	undo.Create("Hoverboard")
		undo.AddEntity(hoverboard)
		undo.SetPlayer(ply)
	undo.Finish()
	return true, hoverboard
end

function TOOL:Reload(trace)
end

function TOOL:Think()
end

if SERVER then
	function MakeHoverboard(ply, model, ang, pos, mcontrol, shake, height, viewdist, trailsize, trail, boost, recharge, attributes)
		if (IsValid(ply) and !ply:CheckLimit("hoverboards")) then return false end
		local hoverboard = ents.Create("hoverboard")
		if !IsValid(hoverboard) then return false end
		local boardinfo
		for _, board in pairs(HoverboardTypes) do
			if (board["model"]:lower() == model:lower()) then
				boardinfo = board
				break
			end
		end
		if !boardinfo then return false end
		util.PrecacheModel(model)
		hoverboard:SetModel(model)
		hoverboard:DrawShadow(false)
		hoverboard:SetAngles(ang)
		hoverboard:SetPos(pos)
		hoverboard:SetBoardRotation(0)
		if boardinfo["rotation"] then
			local rot = tonumber(boardinfo["rotation"])
			hoverboard:SetBoardRotation(tonumber(boardinfo["rotation"]))
			ang.y = ang.y - rot
			hoverboard:SetAngles(ang)
		end
		hoverboard:Spawn()
		hoverboard:Activate()
		hoverboard:SetAvatarPosition(Vector(0, 0, 0))
		if boardinfo["driver"] then
			hoverboard:SetAvatarPosition(boardinfo["driver"])
		end
		for k, v in pairs(boardinfo) do
			if (k:sub(1, 7):lower() == "effect_" and type(boardinfo[k] == "table")) then
				local effect = boardinfo[k]
				local normal
				if (effect["normal"]) then normal = effect["normal"] end
				hoverboard:AddEffect(effect["effect"] or "trail", effect["position"], normal, effect["scale"] or 1)
			end
		end
		hoverboard:SetControls(math.Clamp(tonumber(mcontrol), 0, 1))
		hoverboard:SetBoostShake(math.Clamp(tonumber(shake), 0, 1))
		hoverboard:SetHoverHeight(math.Clamp(tonumber(height), 36, 100))
		hoverboard:SetViewDistance(math.Clamp(tonumber(viewdist), 64, 256))
		hoverboard:SetSpring(0.21 * ((72 / height) * (72 / height)))
		trailsize = math.Clamp(trailsize, 0, 10) * 0.3
		hoverboard:SetTrailScale(trailsize)
		hoverboard:SetTrailColor(trail)
		hoverboard:SetTrailBoostColor(boost)
		hoverboard:SetTrailRechargeColor(recharge)
		for k, v in pairs(attributes) do
			v = math.Clamp(v, 0, 16)
		end
		local speed = (attributes["speed"] * 0.1) * 20
		hoverboard:SetSpeed(speed)
		local jump = (attributes["jump"] * 0.1) * 250
		hoverboard:SetJumpPower(jump)
		local turn = (attributes["turn"] * 0.1) * 25
		hoverboard:SetTurnSpeed(turn)
		local flip = (attributes["flip"] * 0.1) * 25
		hoverboard:SetPitchSpeed(flip)
		local twist = (attributes["twist"] * 0.1) * 25
		hoverboard:SetYawSpeed(twist)
		local roll = ((flip + twist * 0.5) / 50) * 22
		hoverboard:SetRollSpeed(roll)
		DoPropSpawnedEffect(hoverboard)
		if IsValid(ply) then
			ply:AddCount("hoverboards", hoverboard)
			ply:AddCleanup("hoverboards", hoverboard)
			hoverboard.Creator = ply:EntIndex()
		end
		return hoverboard
	end
	return
end

if CLIENT then
	language.Add("tool.hoverboard.name", "Hoverboards")
	language.Add("tool.hoverboard.desc", "Erstelle eigene Hoverboards.")
	language.Add("tool.hoverboard.left", "Hoverboard erstellen")
	language.Add("tool.hoverboard.right", "Hoverboard mit dir als Fahrer erstellen")
	language.Add("tool.hoverboard.lights", "Spurlichter")
	language.Add("max_hoverboards", "Maximale Hoverboards")
	language.Add("Undone_hoverboard", "Undone Hoverboard")
	language.Add("SBoxLimit_hoverboards", "You've reached the Hoverboard limit!")
	language.Add("Cleaned_hoverboards", "Cleaned up all Hoverboards")
	language.Add("Cleanup_hoverboards", "Hoverboards")
end

local hbpanel = vgui.RegisterFile("vgui/hoverboard_gui.lua")
local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(cp)
	cp:AddControl("Header", {Text = "#tool.hoverboard.name", Description = "#tool.hoverboard.desc"})
	cp:AddControl("ComboBox", {MenuButton = 1, Folder = "hoverboard", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})
	local panel = vgui.CreateFromTable(hbpanel)
	panel:PopulateBoards(HoverboardTypes)
	panel:PerformLayout()
	cp:AddPanel(panel)
	cp:AddControl("Color", {Label = "Farbe der Spur", Red = "hoverboard_trail_r", Green = "hoverboard_trail_g", Blue = "hoverboard_trail_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1"})
	cp:AddControl("Color", {Label = "Farbe beim Benutzen des Boosts", Red = "hoverboard_boost_r", Green = "hoverboard_boost_g", Blue = "hoverboard_boost_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1"})
	cp:AddControl("Color", {Label = "Farbe beim Aufladen des Boosts", Red = "hoverboard_recharge_r", Green = "hoverboard_recharge_g", Blue = "hoverboard_recharge_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1"})
	cp:AddControl("Slider", {Label = "Spurgröße", Min = 0, Max = 10, Command = "hoverboard_trail_size"})
	cp:AddControl("Slider", {Label = "Schwebehöhe", Min = 36, Max = 100, Command = "hoverboard_height"})
	cp:AddControl("Slider", {Label = "Sichtweite", Min = 64, Max = 256, Command = "hoverboard_viewdist"})
	cp:AddControl("Checkbox", {Label = "Bewegung mit Maus", Command = "hoverboard_mousecontrol"})
	cp:AddControl("Checkbox", {Label = "Vibrieren bei Benutzung des Boosts", Command = "hoverboard_boostshake"})
	cp:AddControl("Checkbox", {Label = "#tool.hoverboard.lights", Command = "hoverboard_lights"})
end