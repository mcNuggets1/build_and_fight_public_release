include("sh_pvp.lua")

local draw, surface = draw, surface

surface.CreateFont("PVP_TargetID", {font = PVP.FontName, size = PVP.FontSize, weight = PVP.FontWeight, blursize = 0, scanlines = 0, antialias = true})
surface.CreateFont("PVP_TargetID2", {font = PVP.FontName2, size = PVP.FontSize2, weight = PVP.FontWeight2, blursize = 0, scanlines = 0, antialias = true})

local showhud = CreateClientConVar("bf_showhud", 1, FCVAR_ARCHIVE)
local whitename = CreateClientConVar("bf_whitename", 0, FCVAR_ARCHIVE)

local scrw, scrh = ScrW(), ScrH()
local whiteNameEnabled

local vector = Vector(0, 0, 16)
local function IsOnScreen(pos)
	local pos_x = pos.x
	local pos_y = pos.y
	return pos_x > 0 and pos_x < scrw and pos_y > 0 and pos_y < scrh
end

local function DrawInfo(ply, screen, color, bgcolor)
	local offset = 0
	local bounty = ply:GetNWInt("bountysystem_amount")
	if bounty > 0 then
		if MG_GetCamPos():DistToSqr(ply:GetPos()) <= 1000000 then
			draw.SimpleTextOutlined("Kopfgeld: "..string.Comma(bounty).." Cash", "PVP_TargetID2", screen.x, screen.y, whiteNameEnabled and color_white or color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, whiteNameEnabled and color_black or bgcolor)
			offset = offset - 15
		end
	end
	draw.SimpleTextOutlined(whiteNameEnabled and ply:Name()..(ply:IsBuilder() and " (Builder)" or " (Fighter)") or ply:Name(), "PVP_TargetID", screen.x, screen.y + offset, whiteNameEnabled and color_white or color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, whiteNameEnabled and color_black or bgcolor)
end

local plys_to_render = {}

local reg = debug.getregistry()
local Alive = reg.Player.Alive
local GetNoDraw = reg.Entity.GetNoDraw
local EyePos = reg.Entity.EyePos

local GetNWEntity = reg.Entity.GetNWEntity
local IsValid_ent = reg.Entity.IsValid
local GetClass = reg.Entity.GetClass

local ToScreen = reg.Vector.ToScreen
local function PVP_DrawHUD()
	scrw = ScrW()
	scrh = ScrH()

	whiteNameEnabled = whitename:GetBool()

	for k, ply in ipairs(plys_to_render) do
		if !ply:IsValid() then  -- We don't want a when a Player Disconnects from the Server.
			plys_to_render[k] = nil
			continue 
		end

		if PVP.HoverboardHotfix then
			local veh = GetNWEntity(ply, "ScriptedVehicle")
			if IsValid_ent(veh) and GetClass(veh) == "hoverboard" then
				local avatar = veh:GetNW2Entity("Avatar")
				if !IsValid_ent(avatar) then continue end

				local screen = ToScreen(avatar:GetPos() + Vector(0, 0, 80))
				if !IsOnScreen(screen) then continue end

				DrawInfo(ply, screen, ply:IsBuilder() and PVP.BuilderHUDColor or PVP.FighterHUDColor, color_black)
				continue
			end
		end

		if Alive(ply) and !GetNoDraw(ply) then
			local screen = ToScreen(EyePos(ply) + vector)
			if !IsOnScreen(screen) then continue end

			DrawInfo(ply, screen, ply:IsBuilder() and PVP.BuilderHUDColor or PVP.FighterHUDColor, color_black)
		end
	end
end
hook.Add("HUDPaint", "PVP_DrawHUD", PVP_DrawHUD)

local function PVP_UpdatePlayers()
	if !PVP.UseHUD or !showhud:GetBool() then return end

	local ply = LocalPlayer()
	if !ply:IsValid() then return end

	plys_to_render = {}
	for _, v in ipairs(player.GetAll()) do
		if hook.Run("PVP_HighlightPlayerNames", v) == false then continue end
	
		table.insert(plys_to_render, v)
	end
end
timer.Create("PVP_UpdatePlayers", 0.1, 0, PVP_UpdatePlayers)

local key1
local key2
local shortcuts = CreateClientConVar("bf_shortcuts", 1, FCVAR_ARCHIVE)
local function SwitchTeam()
	if !PVP.UseShortcuts or !shortcuts:GetBool() then return end
	if input.IsKeyDown(KEY_F7) then
		if key1 then return end
		key1 = true
		RunConsoleCommand("builder")
	else
		key1 = false
	end
	if input.IsKeyDown(KEY_F8) then
		if key2 then return end
		key2 = true
		RunConsoleCommand("fighter")
	else
		key2 = false
	end
end
hook.Add("Think", "PVP_SwitchTeam", SwitchTeam)

local shownotify = CreateClientConVar("bf_shownotify", 1, FCVAR_ARCHIVE)
net.Receive("PVP_SendNotify", function()
	if !shownotify:GetBool() then return end
	local typ = net.ReadUInt(4)
	local len = net.ReadUInt(8)
	local msg = net.ReadString()
	notification.AddLegacy(msg, typ, len)
	print(msg)
end)

local showhelp = CreateClientConVar("bf_showhelp", 3, FCVAR_ARCHIVE)
local showchat = CreateClientConVar("bf_showchat", 1, FCVAR_ARCHIVE)
net.Receive("PVP_SendChatMessage", function()
	if !showchat:GetBool() then return end
	local tab = net.ReadTable()
	local str = net.ReadString()
	if str == PVP.HelpMessage then
		if showhelp:GetInt() > 0 then
			RunConsoleCommand("bf_showhelp", tostring(showhelp:GetInt() - 1))
		else
			return
		end
	end
	chat.AddText(tab, str)
end)

surface.CreateFont("PVP_ScreenMsg", {font = "Roboto Cn", size = 25, width = 1000, antialias = true})
surface.CreateFont("PVP_ScreenMsg2", {font = "BebasNeue", size = 22, width = 1000, antialias = true})
surface.CreateFont("PVP_ScreenMsg3", {font = "Roboto Cn", size = 22, width = 1000, antialias = true})
surface.CreateFont("PVP_ScreenMsg4", {font = "BebasNeue", size = 16, width = 1000, antialias = true})

local screen_messages = {}
local showscreenmsg = CreateClientConVar("bf_showscreenmsg", 1, FCVAR_ARCHIVE)
local supressscreenmsg = CreateClientConVar("bf_supressscreenmsg", 0, FCVAR_ARCHIVE)
local hook_added = false
local function PVP_DrawScreenMessages()
	if !showscreenmsg:GetBool() then return end
	local scrw = ScrW()
	local scrh = ScrH()
	local offset = 0
	local first = true
	local supress = supressscreenmsg:GetBool()
	for k, v in pairs(screen_messages) do
		local time_left = v[3]
		local sys_time = SysTime()
		if time_left < sys_time then
			screen_messages[k] = nil
			if table.IsEmpty(screen_messages) then
				hook_added = false
				hook.Remove("HUDPaint", "PVP_ScreenMessage")
			end
		end
		local alpha = 255 - ((time_left - sys_time) * 255)
		local font = first and "PVP_ScreenMsg" or "PVP_ScreenMsg3"
		local font2 = first and "PVP_ScreenMsg2" or "PVP_ScreenMsg4"
		if !supress then
			local txt = v[1]
			surface.SetFont(font)
			local size = surface.GetTextSize(txt)
			draw.SimpleTextOutlined(txt, font, scrw / 2 - size / 2, scrh / 5 + offset, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255 - alpha))
		end
		local txt = v[2]
		surface.SetFont(font2)
		local size = surface.GetTextSize(txt)
		draw.SimpleTextOutlined("+"..txt, supress and font or font2, scrw / 2 - size / 2, scrh / 5 + (first and 26 or 22) + offset, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255 - alpha))
		offset = offset + (supress and first and 30 or supress and 20 or first and 60 or 40)
		first = false
	end
end

local old_message = CreateClientConVar("bf_old_message", 0, FCVAR_ARCHIVE)
net.Receive("PVP_ScreenMessage", function()
	local msg = net.ReadString()
	local amt = net.ReadUInt(32)
	if old_message:GetBool() then
		notification.AddLegacy(msg.." +"..amt, NOTIFY_GENERIC, 5)
	else
		table.insert(screen_messages, 1, {msg, amt, SysTime() + 5})
		if !hook_added then
			hook_added = true
			hook.Add("HUDPaint", "PVP_ScreenMessage", PVP_DrawScreenMessages, HOOK_LOW or 1)
		end
	end
	print(msg)
	print("+"..amt)
end)