local COH = {}

COH.DontBlockLOS = false
COH.TeamColors = true
COH.ShowLocalPlayerChat = false

COH.FadeTime = 5
COH.Gravity = 7.5
COH.Range = 750
COH.Alpha = 200
COH.DragForce = 4
COH.Font = "TargetIDSmall"
COH.Border = 100

COH.LineColor = Color(255, 255, 255, 50)
COH.TextColor = Color(255, 255, 255, 250)
COH.NameColor = Color(230, 230, 230, 250)

local Player = FindMetaTable("Player")
function Player:COH_AddText(name, text, ncolor)
	if self:GetNoDraw() then return end
	COH.TextTable = COH.TextTable or {}
	local t = {}
	t.ply = self
	t.name = name or self:Name()
	t.text = text or "???"
	t.pos = self:COH_ChatPos()
	t.offset = Vector(0, 0, 20)
	t.gravity = Vector(math.Rand(-COH.Gravity, COH.Gravity), math.Rand(-COH.Gravity, COH.Gravity), COH.Gravity * 0.8)
	t.ncolor = ncolor or COH.NameColor
	t.fade = CurTime() + (fade or COH.FadeTime)
	table.insert(COH.TextTable, t)
end

function Player:COH_ChatPos()
	local id = self:LookupAttachment("mouth")
	if !id or (id == 0) then
		return self:GetPos() + Vector(0, 0, 65)
	else
		return self:GetAttachment(id).Pos
	end
end

hook.Add("OnPlayerChat", "COH_OnPlayerChat", function(ply, text)
	if ply:IsPlayer() and ((LocalPlayer() != ply or COH.ShowLocalPlayerChat) and ply:Alive()) then
		local color = COH.NameColor
		if COH.TeamColors then
			color = team.GetColor(ply:Team())
		end
		ply:COH_AddText(ply:Name(), text, color)
	end
end)

local renderchat = CreateClientConVar("cl_renderchat", 1, FCVAR_ARCHIVE)
local range = COH.Range * COH.Range
local function RenderCOH()
	if !renderchat:GetBool() or !COH.TextTable then return end
	local skip_players = {}
	for k, t in pairs(COH.TextTable) do
		local time = t.fade - CurTime()
		local fade_perc = math.Clamp(time, 0, 1)
		if (time <= 0) then
			COH.TextTable[k] = nil
		elseif (IsValid(t.ply) and (LocalPlayer():GetPos():DistToSqr(t.ply:GetPos()) <= range)) then
			t.offset = t.offset + t.gravity * FrameTime()
			t.pos = LerpVector(COH.DragForce * FrameTime(), t.pos, t.ply:COH_ChatPos() + t.offset)
			if (!skip_players[t.ply] and !COH.DontBlockLOS) then
				local trace = {}
				trace.start = LocalPlayer():GetShootPos()
				trace.endpos = t.ply:COH_ChatPos()
				trace.filter = {player.GetAll()}
				trace.mask = MASK_VISIBLE
				local tr = util.TraceLine(trace)
				if tr.Hit then
					skip_players[t.ply] = t.ply
				end
			end
			if !skip_players[t.ply] or COH.DontBlockLOS then
				local tpos = t.pos:ToScreen() 
				local ppos = t.ply:COH_ChatPos():ToScreen()
				local txtclr = Color(COH.TextColor.r, COH.TextColor.g, COH.TextColor.b, COH.Alpha * fade_perc)
				local nmclr = Color(t.ncolor.r, t.ncolor.g, t.ncolor.b, COH.Alpha * fade_perc)
				local ymax = 16
				local ymin = 16
				surface.SetFont(COH.Font)
				local w, h = surface.GetTextSize(t.text)
				local drawl = true
				if ((tpos.x - w / 2) < COH.Border) then
					tpos.x = w / 2 + COH.Border
					drawl = false
				elseif ((tpos.x + w / 2) > ScrW() - COH.Border) then
					tpos.x = ScrW() - w / 2 - COH.Border
					drawl = false
				end
				if ((tpos.y - ymax) < COH.Border) then
					tpos.y = 0 + ymax + COH.Border
					drawl = false
				elseif ((tpos.y - ymin) > ScrH() - COH.Border) then
					tpos.y = ScrH() - ymin - COH.Border
					drawl = false
				end
				local lineclr = Color(COH.LineColor.r, COH.LineColor.g, COH.LineColor.b, COH.LineColor.a * fade_perc)
				local liney = tpos.y + h
				local namey = tpos.y - h
				w = w - 6
				surface.SetDrawColor(lineclr)
				surface.DrawLine(tpos.x - (w / 2) + 3, liney + 2, tpos.x + (w * 0.5) + 3, liney + 2)
				if drawl then
					surface.DrawLine(ppos.x, ppos.y, tpos.x, liney + 3)
				end
				draw.SimpleText(t.name..":", COH.Font, tpos.x, namey, nmclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(t.text, COH.Font, tpos.x, liney, txtclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
	end
end
hook.Add("HUDPaint", "COH_Render", RenderCOH)