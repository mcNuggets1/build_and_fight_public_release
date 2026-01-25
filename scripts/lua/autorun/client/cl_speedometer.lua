local use_font = system.IsWindows() and "Tahoma" or "Verdana"
surface.CreateFont("SpeedoMeter", {font = use_font, size = 18, weight = 0, blursize = 0, scanlines = 0, antialias = true})

local surface = surface
local draw = draw

local speed_units = "km/h"
local min_size = 230
local size_factor = 1 / 4
local padding_x = 100
local padding_y = 15
local speed_max_default = 200
local speed_interval_default = 10
local color_bg = Color(0, 0, 0, 240)
local color_numbers = Color(20, 150, 255, 255)
local color_needle = Color(175, 75, 0, 255)
local color_needle_base = Color(0, 0, 0, 255)
local color_interval = Color(175, 175, 175, 255)
local color_text = Color(200, 200, 200, 255)
local vel_factor = 0.75 * ((string.lower(speed_units) == "km/h") and 3600 * 0.0000254 or 3600 / 63360)

local pi = math.pi
local function DrawCircle(x, y, rad, quality, col)
	surface.SetDrawColor(col)
	local step = (2 * pi) / quality
	local verts = {}
	local ang
	for i=1, quality do
		ang = i * step
		table.insert(verts, {x = x + math.cos(ang) * rad, y = y + math.sin(ang) * rad})
	end
	surface.DrawPoly(verts)
end

local speedometer = CreateClientConVar("cl_speedometer", 1, FCVAR_ARCHIVE)
local local_ply, veh
local function DrawSpeedoMeter()
	if !speedometer:GetBool() then return end
	local_ply = local_ply or LocalPlayer()
	veh = local_ply:GetVehicle()
	if !IsValid(veh) then return end
	local class = veh:GetClass()
	if class != "prop_vehicle_jeep" and class != "prop_vehicle_jeep_old" and class != "prop_vehicle_airboat" then return end
	local maxspeed = speed_max_default
	local interval = speed_interval_default
	surface.SetTexture(0)
	local scrw = ScrW()
	local scrh = ScrH()
	local size = math.max(min_size, math.min(math.min(scrw, scrh) * size_factor))
	local xl, yt = scrw - padding_x - size, scrh - padding_y - size
	local rad = size / 2
	DrawCircle(xl + rad, yt + rad, rad - 2, 48, color_bg)
	local numcnt = math.ceil(maxspeed / interval)
	local step = (3 * (pi / 2)) / numcnt
	local offset = 3 * (pi / 4)
	local ang, x, y, ismajor
	for i=0, numcnt do
		ang = (i * step) + offset
		x = xl + rad + (math.cos(ang) * (rad - 30))
		y = yt + rad + (math.sin(ang) * (rad - 30))
		draw.SimpleText(tostring(i * interval), "SpeedoMeter", x, y, color_numbers, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	local barcnt = numcnt * 10
	step = (3 * (pi / 2)) / barcnt
	surface.SetDrawColor(color_interval)
	for i=0, barcnt do
		ismajor = (i % 5) == 0
		ang = (i * step) + offset
		x = xl + rad + (math.cos(ang) * (rad - 5))
		y = yt + rad + (math.sin(ang) * (rad - 5))
		surface.DrawTexturedRectRotated(x, y, ismajor and 14 or 8, ismajor and 2 or 1, math.deg(-ang))
	end
	local vel = veh:GetVelocity():Length()
	local speed = math.min(vel * vel_factor, maxspeed)
	DrawCircle(xl + rad, yt + rad, rad / 10, 32, color_needle_base)
	local ang = offset + (speed / maxspeed) * (6 * (pi / 4))
	surface.SetDrawColor(color_needle)
	surface.DrawPoly({{x = xl + rad + (math.cos(ang) * (rad / 1.5)), y = yt + rad + (math.sin(ang) * (rad / 1.5))}, {x = xl + rad + (math.cos(ang + pi - pi / 30) * (rad / 3)), y = yt + rad + (math.sin(ang + pi - pi / 30) * (rad / 3))}, {x = xl + rad + (math.cos(ang + pi) * ((rad / 3) - 3)), y = yt + rad + (math.sin(ang + pi) * ((rad / 3) - 3))}, {x = xl + rad + (math.cos(ang + pi + pi / 30) * (rad / 3)), y = yt + rad + (math.sin(ang + pi + pi / 30) * (rad / 3))}})
	draw.SimpleText(speed_units, "Trebuchet24", xl + rad, yt + rad * 1.5, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
hook.Add("HUDPaint", "SpeedoMeter_Draw", DrawSpeedoMeter)