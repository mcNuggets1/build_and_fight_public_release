local protected = false
local spawnpoint = false
local starttime = 0
local length = 0
net.Receive("SpawnProtection_SendState", function()
	protected = net.ReadBool()
	starttime = net.ReadFloat(32)
	length = net.ReadFloat(16)
end)

local cm = {}
cm["$pp_colour_brightness"] = 0
cm["$pp_colour_contrast"] = 1
cm["$pp_colour_addr"] = 0
cm["$pp_colour_addg"] = 0
cm["$pp_colour_addb"] = 0
cm["$pp_colour_mulr"] = 0
cm["$pp_colour_mulg"] = 0
cm["$pp_colour_mulb"] = 0
cm["$pp_colour_colour"] = 0
cm["$pp_colour_brightness"] = 0
hook.Add("RenderScreenspaceEffects", "SpawnProtection_ColorModify", function()
	local ply = LocalPlayer()
	if !ply:Alive() or !protected then return end
	DrawColorModify(cm)
end)

surface.CreateFont("SpawnProtection_BigFont", {font = "Roboto Cn", size = 31, width = 1000, antialias = true})
surface.CreateFont("SpawnProtection_SmallFont", {font = "Roboto Cn", size = 18, width = 1000, antialias = true})

local drawinfo = CreateClientConVar("cl_drawspawninfo", 1, FCVAR_ARCHIVE)
local function DrawInfo()
	local ply = LocalPlayer()
	if !ply:Alive() or !drawinfo:GetBool() then return end
	if protected then
		surface.SetFont("SpawnProtection_BigFont")
		local leng = math.Round(starttime - CurTime() + length)
		local txt = "Dein Spawnschutz läuft in "..(leng == 1 and "1 Sekunde" or leng.." Sekunden").." ab."
		local size = surface.GetTextSize(txt)
		local scrw, scrh = ScrW(), ScrH()
		draw.SimpleTextOutlined(txt, "SpawnProtection_BigFont", scrw / 2 - size / 2, scrh / 1.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
		surface.SetFont("SpawnProtection_SmallFont")
		local txt2 = "Du nimmst keinen Schaden, kannst aber welchen austeilen."
		size = surface.GetTextSize(txt2)
		draw.SimpleTextOutlined(txt2, "SpawnProtection_SmallFont", scrw / 2 - size / 2, (scrh / 1.25) + 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
	elseif starttime + length > CurTime() then
		surface.SetFont("SpawnProtection_BigFont")
		local txt = "Dein Spawnschutz ist abgelaufen."
		local size = surface.GetTextSize(txt)
		draw.SimpleTextOutlined(txt, "SpawnProtection_BigFont", ScrW() / 2 - size / 2, ScrH() / 1.25, Color(255, 255, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
	end
end
hook.Add("HUDPaint", "SpawnProtection_DrawInfo", DrawInfo)