if SERVER then
	util.AddNetworkString("Hitmarker_Draw")
	util.AddNetworkString("Hitmarker_OpenMixer")

	hook.Add("EntityTakeDamage", "Hitmarker_DetectHitmarker", function(ply, dmginfo)
		local att = dmginfo:GetAttacker()
		local dmg = dmginfo:GetDamage()
		if (IsValid(att) and att:IsPlayer() and att:Alive() and att != ply) then
			local is_player = ply:IsPlayer()
			if (is_player and ply:Alive() or ply:IsNPC()) then
				if is_player and ply.IsGhost and ply:IsGhost() then return end
				net.Start("Hitmarker_Draw")
				net.Send(att)
			end
		end
	end)

	hook.Add("PlayerSay", "Hitmarker_OpenColorMixer", function(ply, text, public)
		if (string.lower(text) == "!hitmarkercolor") then
			net.Start("Hitmarker_OpenMixer")
			net.Send(ply)
			return ""
		end
	end)
end

if CLIENT then
	local hitmarker_toggle = CreateClientConVar("cl_hitmarker_enable", 1, true, true)	
	local hitmarker_type = CreateClientConVar("cl_hitmarker_hitmarkertype", "lines", true, true)
	local hitmarker_color = CreateClientConVar("cl_hitmarker_color", "255, 255, 255", true, true)
	local hitmarker_sound = CreateClientConVar("cl_hitmarker_hitsound", 0, true, true)	

	local Hitmarker_Draw = false
	local Hitmarker_PlaySound = true
	local Hitmarker_Alpha = 0

	local function GrabColor()
		local coltable = string.Explode(",", hitmarker_color:GetString())
		local newcol = {}
		for k,v in pairs(coltable) do
			v = tonumber(v)
			if v == nil then
				coltable[k] = 0
			end
		end
		newcol[1], newcol[2], newcol[3] = coltable[1] or 0, coltable[2] or 0, coltable[3] or 0
		return Color(newcol[1], newcol[2], newcol[3])
	end

	local Frame
	local function Hitmarker_OpenMixer()
		if IsValid(Frame) then Frame:Close() end
		Frame = vgui.Create("DFrame")
		Frame:SetTitle("Hitmarker: Farbenauswahl")
		Frame:SetSize(300,400)
		Frame:Center()			
		Frame:MakePopup()
		local colMix = vgui.Create("DColorMixer", Frame)
		colMix:Dock(TOP)
		colMix:SetPalette(true) 
		colMix:SetAlphaBar(false)	
		colMix:SetWangs(false)
		colMix:SetColor(GrabColor())
		local Butt = vgui.Create("DButton", Frame)
		Butt:SetText("Farbe benutzen")
		Butt:SetSize(150,70)
		Butt:SetPos(70, 290)
		Butt.DoClick = function(Butt)
			surface.PlaySound("ui/buttonclick.wav")
			local col = colMix:GetColor()
			local colstring = tostring(col.r .. ", " .. col.g .. ", "..col.b)
			RunConsoleCommand("hitmarker_color", colstring) 
		end
	end
	concommand.Add("cl_hitmarker_colorchooser", Hitmarker_OpenMixer)

	net.Receive("Hitmarker_Draw", function(len, ply)
		Hitmarker_Draw = true
		Hitmarker_PlaySound = true
		Hitmarker_Alpha = 255 
	end)

	local lasttime = 0
	local function DrawHitmarker()
		if !hitmarker_toggle:GetBool() then return end
		if Hitmarker_Alpha == 0 then
			Hitmarker_Draw = false
			Hitmarker_PlaySound = true
		end
		if Hitmarker_Draw then
			if Hitmarker_PlaySound and hitmarker_sound:GetBool() then
				surface.PlaySound("hitmarkers/hit.wav")
				Hitmarker_PlaySound = false
			end
			local x = ScrW() / 2
			local y = ScrH() / 2
			Hitmarker_Alpha = math.Approach(Hitmarker_Alpha, 0, (CurTime() - lasttime) * 500)
			local col = GrabColor()
			col.a = Hitmarker_Alpha 
			surface.SetDrawColor(col)
			local sel = string.lower(hitmarker_type:GetString())
			if sel == "lines" then 
				surface.DrawLine(x - 6, y - 5, x - 11, y - 10)
				surface.DrawLine(x + 5, y - 5, x + 10, y - 10)
				surface.DrawLine(x - 6, y + 5, x - 11, y + 10)
				surface.DrawLine(x + 5, y + 5, x + 10, y + 10)
			elseif sel == "sidesqr_lines" then
				surface.DrawLine(x - 15, y, x, y + 15)
				surface.DrawLine(x + 15, y, x, y - 15)
				surface.DrawLine(x, y + 15, x + 15, y)
				surface.DrawLine(x, y - 15, x - 15, y)
				surface.DrawLine(x - 5, y - 5, x - 10, y - 10)
				surface.DrawLine(x + 5, y - 5, x + 10, y - 10)
				surface.DrawLine(x - 5, y + 5, x - 10, y + 10)
				surface.DrawLine(x + 5, y + 5, x + 10, y + 10)
			elseif sel == "sqr_rot" then
				surface.DrawLine(x - 15, y, x, y + 15)
				surface.DrawLine(x + 15, y, x, y - 15)
				surface.DrawLine(x, y + 15, x + 15, y)
				surface.DrawLine(x, y - 15, x - 15, y)
			else
				surface.DrawLine(x - 6, y - 5, x - 11, y - 10)
				surface.DrawLine(x + 5, y - 5, x + 10, y - 10)
				surface.DrawLine(x - 6, y + 5, x - 11, y + 10)
				surface.DrawLine(x + 5, y + 5, x + 10, y + 10)
			end
		end
		lasttime = CurTime()
	end
	hook.Add("HUDPaint", "Hitmarker_DrawHitmarker", DrawHitmarker)
end