include "wac/aircraft.lua"

CreateClientConVar("wac_cl_air_sensitivity", 1, true, true)
CreateClientConVar("wac_cl_air_mouse", 1, true, true)
CreateClientConVar("wac_cl_air_mouse_swap", 1, true, true)
CreateClientConVar("wac_cl_air_mouse_invert_pitch", 0, true, true)
CreateClientConVar("wac_cl_air_mouse_invert_yawroll", 0, true, true)
CreateClientConVar("wac_cl_air_smoothview", 1, true, true)
CreateClientConVar("wac_cl_air_shakeview", 1, true, true)
CreateClientConVar("wac_cl_air_smoothkeyboard", 1, true, true)
CreateClientConVar("wac_cl_air_arcade", 1, true, true)
CreateClientConVar("wac_cl_air_volume", 0.01, true, true)


if !game.SinglePlayer() then
	CreateClientConVar("wac_air_startspeed", 1, false)
	CreateClientConVar("wac_air_nodamage", 0, false)
	
	local function onchange( name, oldval, val )
		if MG_OwnerGroups[LocalPlayer():GetUserGroup()] then
			net.Start("wac_admin_setting")
				net.WriteString(name)
				net.WriteFloat(val)
			net.SendToServer()
		end
	end
	cvars.AddChangeCallback("wac_air_startspeed",onchange)
	cvars.AddChangeCallback("wac_air_nodamage",onchange)
end

surface.CreateFont("wac_heli_big", {
	font = "monospace",
	size = 32
})

surface.CreateFont("wac_heli_small", {
	font = "monospace",
	size = 22
})

wac.hook("ShouldDrawLocalPlayer", "wac_air_showplayerthirdperson", function()
	local veh = LocalPlayer():GetVehicle()
	if veh:IsValid() and veh:GetNWEntity("wac_aircraft"):IsValid() then
		return veh:GetThirdPersonMode()
	end
end)

wac.hook("CalcView", "wac_air_calcview", function(ply, pos, ang, fov)
	local tb = ply:GetTable()

	tb.wac = tb.wac or {}
	tb.wac.air = tb.wac.air or {}

	local aircraft = tb.wac.air.vehicle --ply:GetVehicle():GetNWEntity("wac_aircraft")
	if !IsValid(aircraft) then
		local veh = ply:GetVehicle()
		if veh:IsValid() and veh:GetNWEntity("wac_aircraft"):IsValid() and tb.wac.air.lastView then
			aircraft = ply:GetVehicle():GetNWEntity("wac_aircraft")
			aircraft.viewPos = {
				origin = tb.wac.air.lastView.origin - pos,
				angles = tb.wac.air.lastView.angles - ang,
				fov = fov
			}
			if aircraft.onEnter then
				aircraft:onEnter(ply)
			end
		else
			tb.wac.air.vehicle = nil
			tb.wac.air.lastView = {origin=pos, angles=ang, fov=fov}
			return
		end
	end
	
	local i = ply:GetNWInt("wac_passenger_id")
	if tb.wac.air.vehicle and GetViewEntity() == ply and aircraft.Seats then
		return aircraft:viewCalc((i == 0 and 1 or i), ply, pos, ang, 75)
	end
end)

local ply
wac.hook("RenderScreenspaceEffects", "wac_air_weaponcam",function()
	ply = ply or LocalPlayer()
	local veh = ply:GetVehicle()
	if !veh:IsValid() then return end
	local ent = veh:GetNWEntity("wac_aircraft")
	if ent:IsValid() then
		ent:DrawScreenSpaceEffects(ply:GetNWInt("wac_passenger_id"), ply)
	end
end)

wac.hook("HUDPaint", "wac_air_weaponhud", function()
	ply = ply or LocalPlayer()
	local veh = ply:GetVehicle()
	if !veh:IsValid() then return end
	local ent = veh:GetNWEntity("wac_aircraft")
	if ent:IsValid()  then
		ent:DrawHUD(ply:GetNWInt("wac_passenger_id"), ply)
	end
end)

wac.hook("CreateMove", "wac_cl_air_mouseinput", function(md)
	ply = ply or LocalPlayer()
	local veh = ply:GetVehicle()
	if !veh:IsValid() then return end
	local ent = veh:GetNWEntity("wac_aircraft")
	if ent:IsValid() and ent.MovePlayerView then
		ent:MovePlayerView(ply:GetNWInt("wac_passenger_id"), ply, md)
	end
end)

-- menu
wac.addMenuPanel(wac.menu.tab, wac.menu.category, wac.menu.aircraft, function(panel, info)

	panel:AddControl("Label", {Text = "Spieler-Einstellungen"})
	
	local presetParams = {
		Label = "Presets",
		MenuButton = 1,
		Folder = "wac_aircraft",
		Options = {
			mouse = {
				wac_cl_air_mouse = "1",
				wac_cl_air_mouse_swap ="1",
				wac_cl_air_mouse_invert_pitch = "0",
				wac_cl_air_mouse_invert_yawroll = "0",
				wac_cl_air_key_Exit = KEY_E,
				wac_cl_air_key_Start = KEY_R,
				wac_cl_air_key_Throttle_Inc = KEY_W,
				wac_cl_air_key_Throttle_Dec = KEY_S,
				wac_cl_air_key_Yaw_Inc = KEY_A,
				wac_cl_air_key_Yaw_Dec = KEY_D,
				wac_cl_air_key_Pitch_Inc = KEY_NONE,
				wac_cl_air_key_Pitch_Dec = KEY_NONE,
				wac_cl_air_key_Roll_Inc = KEY_NONE,
				wac_cl_air_key_Roll_Dec = KEY_NONE,
				wac_cl_air_key_FreeView = KEY_SPACE,
				wac_cl_air_key_Fire = MOUSE_LEFT,
				wac_cl_air_key_NextWeapon = MOUSE_RIGHT,
				wac_cl_air_key_Hover = MOUSE_4,
			},
			keyboard = {
				wac_cl_air_mouse = "0",
				wac_cl_air_mouse_swap = "0",
				wac_cl_air_mouse_invert_pitch = "0",
				wac_cl_air_mouse_invert_yawroll = "0",
				wac_cl_air_key_Exit = KEY_E,
				wac_cl_air_key_Start = KEY_R,
				wac_cl_air_key_Throttle_Inc = KEY_SPACE,
				wac_cl_air_key_Throttle_Dec = KEY_LSHIFT,
				wac_cl_air_key_Yaw_Inc = MOUSE_LEFT,
				wac_cl_air_key_Yaw_Dec = MOUSE_RIGHT,
				wac_cl_air_key_Pitch_Inc = KEY_W,
				wac_cl_air_key_Pitch_Dec = KEY_S,
				wac_cl_air_key_Roll_Inc = KEY_D,
				wac_cl_air_key_Roll_Dec = KEY_A,
				wac_cl_air_key_FreeView = KEY_X,
				wac_cl_air_key_Fire = KEY_F,
				wac_cl_air_key_NextWeapon = KEY_G,
				wac_cl_air_key_Hover = MOUSE_4,
			},
		},
		CVars = {
			"wac_cl_air_easy",
			"wac_cl_air_sensitivity",
			"wac_cl_air_usejoystick",
			"wac_cl_air_mouse",
			"wac_cl_air_mouse_swap",
			"wac_cl_air_mouse_invert_pitch",
			"wac_cl_air_mouse_invert_yawroll",
		}
	}	
	for category, controls in pairs(wac.aircraft.controls) do
		for i, t in pairs(controls) do
			if !t[3] then
				table.insert(presetParams.CVars, "wac_cl_air_key_" .. i)
			else
				table.insert(presetParams.CVars, "wac_cl_air_key_" .. i .. "_Inc")
				table.insert(presetParams.CVars, "wac_cl_air_key_" .. i .. "_Dec")
			end
		end
	end
	panel:AddControl("ComboBox", presetParams)

	for i, controls in pairs(wac.aircraft.controls) do
		panel:AddControl("Label", {Text = controls.name})
		for name, t in pairs(controls.list) do
			if !t[3] then
				local k = vgui.Create("wackeyboard::key", panel)
				k:setLabel(name)
				k:setKey(t[2])
				k.runCommand="wac_cl_air_key_"..name
				panel:AddPanel(k)
			else
				local f = vgui.Create("wackeyboard::key", panel)
				f:setLabel(name .. " +")
				f:setKey(t[2])
				f.runCommand = "wac_cl_air_key_"..name.."_Inc"
				panel:AddPanel(f)
				local k = vgui.Create("wackeyboard::key", panel)
				k:setLabel(name .. " -")
				k:setKey(t[3])
				k.runCommand = "wac_cl_air_key_"..name.."_Dec"
				panel:AddPanel(k)
			end
		end
	end

	panel:AddControl("Slider", {
		Label="Motorlautstärke",
		Type="float",
		Min=0.1,
		Max=1,
		Command="wac_cl_air_volume",
	})

	panel:CheckBox("Arcade-Modus","wac_cl_air_arcade")
	
	panel:CheckBox("Dynamischer Sichtwinkel","wac_cl_air_smoothview")
	
	panel:CheckBox("Dynamische Sichtposition","wac_cl_air_shakeview")

	panel:CheckBox("Maus benutzen","wac_cl_air_mouse")
	if info["wac_cl_air_mouse"]=="1" then
		panel:CheckBox(" - Neigung invertieren","wac_cl_air_mouse_invert_pitch")
		panel:CheckBox(" - Gierung/Drehen invertieren","wac_cl_air_mouse_invert_yawroll")
		panel:CheckBox(" - Gierung/Drehen vertauschen","wac_cl_air_mouse_swap")
		panel:AddControl("Label", {Text = ""})
		panel:AddControl("Slider", {
			Label = "Sensitivität",
			Type = "float",
			Min = 0.5,
			Max = 1.9,
			Command = "wac_cl_air_sensitivity",
		})
	end
	
	panel:AddControl("Label", {Text = ""})
	panel:AddControl("Label", {Text = "Admin-Einstellungen"})

	--panel:CheckBox("Double Force","wac_air_doubletick")

	panel:CheckBox("Kein Schaden","wac_air_nodamage")

	panel:AddControl("Slider", {
		Label="Startgeschwindigkeit",
		Type="float",
		Min=0.1,
		Max=2,
		Command="wac_air_startspeed",
	})
	
	if game.SinglePlayer() then
		panel:CheckBox("Dev Helper","wac_cl_air_showdevhelp")
		if info["wac_cl_air_showdevhelp"]=="1" then
			panel:AddControl("Button", {
				Label = "Erstellen",
				Command = "wac_cl_air_clientsidemodel_create",
			})
			panel:AddControl("Button", {
				Label = "Entfernen",
				Command = "wac_cl_air_clientsidemodel_remove",
			})
			panel:AddControl("TextBox", {
				Label="Modell",
				MaxLength=512,
				Text="",
				Command="wac_cl_air_clmodel_model",
			})
			panel:AddControl("Slider", {
				Label="X",
				Type="float",
				Min=-600,
				Max=600,
				Command="wac_cl_air_clmodel_line_x",
			})
			panel:AddControl("Slider", {
				Label="Y",
				Type="float",
				Min=-200,
				Max=200,
				Command="wac_cl_air_clmodel_line_y",
			})
			panel:AddControl("Slider", {
				Label="Z",
				Type="float",
				Min=-200,
				Max=200,
				Command="wac_cl_air_clmodel_line_z",
			})
			panel:AddControl("Button", {
				Label = "Kopieren",
				Command = "wac_cl_air_clmodel_printvars",
			})
			panel:AddControl("Button", {
				Label = "Zurücksetzen",
				Command = "wac_cl_air_clmodel_line_x 0;wac_cl_air_clmodel_line_y 0;wac_cl_air_clmodel_line_z 0;",
			})
		end
	end
end,
	"wac_cl_air_mouse",
	"wac_cl_air_showdevhelp"
)