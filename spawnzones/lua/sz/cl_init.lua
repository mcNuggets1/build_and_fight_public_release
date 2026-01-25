surface.CreateFont("SZ_Big", {font = "Trebuchet MS", size = 27, weight = 1000, antialias = true})
surface.CreateFont("SZ_Small", {font = "Trebuchet MS", size = 20, weight = 1000, antialias = true})

local local_ply
local function RenderZone(depth, sky)
	if depth or sky then return end
	local_ply = local_ply or LocalPlayer()
	if local_ply.IsFighter and !local_ply:IsFighter() then return end
	for _,v in ipairs(SZ.Data) do
		render.DrawWireframeBox(v.Center, Angle(0, 0, 0), v.SizeBackwards, v.SizeForwards, color_white, true)
	end
end
hook.Add("PostDrawOpaqueRenderables", "SZ_RenderZone", RenderZone)

local SZ_ProtectionMode = 3
local SZ_CurTime = -math.huge
net.Receive("SZ_UpdateProtection", function()
	SZ_ProtectionMode = net.ReadInt(4)
	SZ_CurTime = net.ReadFloat()
end)

local function DrawStatus()
	local_ply = local_ply or LocalPlayer()
	if local_ply.IsFighter and !local_ply:IsFighter() or !local_ply:Alive() or SZ_ProtectionMode == 3 and SZ_CurTime + 3 <= CurTime() then return end
	local time = math.max(0, math.Round(SZ_CurTime - CurTime()))
	draw.SimpleTextOutlined("Sicherheitszone", "SZ_Big", ScrW() / 2, 60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	local str = time == 1 and " Sekunde" or " Sekunden"
	if SZ_ProtectionMode == 0 then
		draw.SimpleTextOutlined("Du bist geschützt.", "SZ_Small", ScrW() / 2, 90, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	elseif SZ_ProtectionMode == 1 then
		draw.SimpleTextOutlined("Du wirst in "..time..str.." geschützt.", "SZ_Small", ScrW() / 2, 90, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	elseif SZ_ProtectionMode == 2 then
		draw.SimpleTextOutlined("Dein Schutz läuft in "..time..str.." ab.", "SZ_Small", ScrW() / 2, 90, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	elseif SZ_ProtectionMode == 3 and SZ_CurTime + 3 > CurTime() then
		draw.SimpleTextOutlined("Du bist nicht geschützt.", "SZ_Small", ScrW() / 2, 90, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	end
end
hook.Add("HUDPaint", "SZ_DrawStatus", DrawStatus)