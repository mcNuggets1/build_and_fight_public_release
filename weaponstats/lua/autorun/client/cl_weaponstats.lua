surface.CreateFont("WeaponFontLarge", {font = "BebasNeue", size = 200, weight = 0, antialias = true})
surface.CreateFont("WeaponFontSmall", {font = "BebasNeue", size = 140, weight = 0, antialias = true})
surface.CreateFont("WeaponFontSmall2", {font = "BebasNeue", size = 80, weight = 0, antialias = true})

local show = CreateClientConVar("cl_drawweaponstats", 1, true, false)

local function FindWeapon(ply)
	local tr = ply:GetEyeTrace()
	return tr.Entity
end

local ply, ent
local function DrawOverlay(depth, sky)
	if !show:GetBool() then return end
	ply = ply or LocalPlayer()
	ent = FindWeapon(ply)
	if IsValid(ent) and ent:IsWeapon() and ply:EyePos():DistToSqr(ent:GetPos()) <= 20000 then
		local ang = ply:EyeAngles()
		local p = ent:GetPos() + Vector(0, 0, 90 + math.sin(SysTime() * 2) * 2)
		local offset
		local printname = ent:GetPrintName()
		local damage
		local clip
		local auto
		local rpm
		local spread
		local recoil
		local primary = ent.Primary
		if primary and primary.Damage then
			damage = primary.Damage > 0 and math.Round(primary.Damage * (primary.NumShots or 1)) or "N/A"
		else
			damage = "N/A"
		end
		if primary and primary.ClipSize and primary.ClipSize > 0 then
			clip = primary.ClipSize
		else
			clip = "N/A"
		end
		if primary and primary.Automatic then
			auto = "Ja"
		else
			auto = "Nein"
		end
		if primary then
			local rpm_index = primary.RPM or primary.Delay and math.Round(1 / (primary.Delay / 60))
			if rpm_index then
				rpm = rpm_index
			else
				rpm = "N/A"
			end
		else
			rpm = "N/A"
		end
		if primary then
			local recoil_index = primary.KickUp and primary.KickUp * 1.5 or primary.Recoil
			if recoil_index then
				if recoil_index > 0 and recoil_index < 1 then
					recoil = "Leicht"
				elseif recoil_index >= 1 and recoil_index < 2 then
					recoil = "Mittel"
				elseif recoil_index >= 2 and recoil_index < 4 then
					recoil = "Hoch"
				elseif recoil_index >= 4 and recoil_index < 10 then
					recoil = "Sehr Hoch"
				elseif recoil_index >= 10 then
					recoil = "Extremst"
				else
					recoil = "N/A"
				end
			else
				recoil = "N/A"
			end
		else
			recoil = "N/A"
		end
		if primary then
			local cone_index = primary.Cone or primary.IronAccuracy
			if cone_index then
				if cone_index >= 0 and cone_index < 0.01 then
					spread = "Präzise"
				elseif cone_index >= 0.01 and cone_index < 0.02 then
					spread = "Genau"
				elseif cone_index >= 0.02 and cone_index < 0.03 then
					spread = "Mittel"
				elseif cone_index >= 0.03 and cone_index < 0.1 then
					spread = "Ungenau"
				elseif cone_index >= 0.1 then
					spread = "Unspielbar"
				else
					spread = "N/A"
				end
			else
				spread = "N/A"
			end
		else
			spread = "N/A"
		end
		surface.SetFont("WeaponFontSmall")
		local wi = surface.GetTextSize(printname)
		if wi > 600 then
			offset = 100 + wi / 2 - 620 / 2
		else
			offset = 0
		end
		cam.Start3D2D(p, Angle(0, ang.y - 90, 90), 0.05)
			draw.RoundedBox(8, -550 - offset, 1060, 700 + offset * 2, 490, Color(50, 50, 50, 150))
			draw.RoundedBox(8, -364 - offset, 1180, 320 + offset * 2, 4, color_white)
			draw.DrawText(printname, "WeaponFontSmall", -200, 1060, color_white, TEXT_ALIGN_CENTER)
			draw.DrawText("Schaden: ", "WeaponFontSmall2", -480, 1188, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(damage, "WeaponFontSmall2", 80, 1188, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText("Magazin: ", "WeaponFontSmall2", -480, 1244, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(clip, "WeaponFontSmall2", 80, 1244, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText("Automatisch: ", "WeaponFontSmall2", -480, 1300, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(auto, "WeaponFontSmall2", 80, 1300, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText("RPM: ", "WeaponFontSmall2", -480, 1356, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(rpm, "WeaponFontSmall2", 80, 1356, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText("Präzision: ", "WeaponFontSmall2", -480, 1412, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(spread, "WeaponFontSmall2", 80, 1412, color_white, TEXT_ALIGN_RIGHT)
			draw.DrawText("Rückstoß: ", "WeaponFontSmall2", -480, 1466, color_white, TEXT_ALIGN_LEFT)
			draw.DrawText(recoil, "WeaponFontSmall2", 80, 1466, color_white, TEXT_ALIGN_RIGHT)
		cam.End3D2D()
	end
end
hook.Add("PostDrawTranslucentRenderables", "WeaponStats_DrawOverlay", DrawOverlay)