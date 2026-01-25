hook.Remove("GravGunPunt", "FPP.Protect.GravGunPunt")
hook.Remove("GravGunPunt", "FPP_CL_GravGunPunt")

local weapon = weapons.GetStored
local function ModifyWeapons()
	weapon("gmod_camera").PrintName = "Kamera"
	weapon("gmod_camera").Tick = function(self)
		if CLIENT and self.Owner != LocalPlayer() then return end
		local cmd = self.Owner:GetCurrentCommand()
		if !cmd:KeyDown(IN_ATTACK2) then return end
		self:SetZoom(math.Clamp(self:GetZoom() + cmd:GetMouseY() * FrameTime() * 6.6, 1, 140))
		self:SetRoll(self:GetRoll() + cmd:GetMouseX() * FrameTime() * 1.65)
	end

	if weapon("vc_wrench") then
		weapon("vc_wrench").PrintName = "Schraubenschlüssel"
		weapon("vc_wrench").Instructions = "Repariert Autos mit Linksklick.\nRechtsklick zum Schnell-Reparieren als Admin."
		weapon("vc_wrench").Slot = 3
		weapon("vc_wrench").UseHands = true
	end
end
hook.Add("OnGamemodeLoaded", "MG_ModifyWeapons", ModifyWeapons)
hook.Add("OnReloaded", "MG_ModifyWeapons", ModifyWeapons)

hook.Add("CanTool", "MG_PreventGridAbuse", function(ply, tr, tool)
	local ent = tr.Entity
	if tool == "material" and IsValid(ent) then
		local model = ent:GetModel()
		if (model == "models/props_building_details/storefront_template001a_bars.mdl" or model == "models/props_combine/combine_window001.mdl") then
			if SERVER then
				ply:ChatPrint("Du kannst kein Material auf dieses Prop anwenden!")
			end
			return false
		end
	end
end)

properties.Add("MG_CopyClipboard", {
	MenuLabel = "Modellpfad kopieren",
	Order = -100,
	MenuIcon = "icon16/cut.png",
	Filter = function(self, ent, ply)
		if (!IsValid(ent) or ent:IsPlayer()) then return false end
		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, player)
		local ent = net.ReadEntity()
		local model = ent:GetModel()
		player:ConCommand("mg_copymodel "..tostring(model))
	end
})

if CLIENT then
	concommand.Add("mg_copymodel", function(ply, cmd, args)
		if !args or !args[1] then return end
		SetClipboardText(args[1])
		ply:ChatPrint("Modell \""..args[1].."\" kopiert.")
	end)
end

if SERVER then
	local function LogQuit(msg)
		MsgN(msg)
		ServerLog(msg.."\n")
	end

	local function CheckForPlayers()
		LogQuit("quit_nice: Checking for players...")
		if player.GetCount() > 0 then
			LogQuit("quit_nice: More than 0 players online... Aborting...")
		else
			LogQuit("quit_nice: Less than 0 players online... Quitting server in 5 seconds...")
			timer.Simple(5, function()
				RunConsoleCommand("_restart")
			end)
		end
	end

	concommand.Add("quit_nice", function(ply, cmd, args)
		if IsValid(ply) then return end
		LogQuit("quit_nice: Running quit_nice...")
		CheckForPlayers()
		timer.Create("quit_nice", 60, 0, function()
			CheckForPlayers()
		end)
	end)

	concommand.Add("quit_stop", function(ply, cmd, args)
		if IsValid(ply) then return end
		timer.Remove("quit_nice")
	end)
end