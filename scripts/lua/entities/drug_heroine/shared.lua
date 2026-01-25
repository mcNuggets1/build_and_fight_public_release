ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Heroin"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.TRANSITION_TIME = 5
ENT.LASTINGEFFECT = 15
ENT.DEATHPENALTY = 75
ENT.EFFECT_TEXT = "Tödliche Resistenz (+50%)"

if CLIENT then
	killicon.Add("drug_heroine", "killicons/drug_heroine_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME
	local HIGH_INTENSITY = 0.8
	local STROBE_PACE = 1
	local cdw, cdw2, cdw3
	cdw2 = -1

	local tab = {}
	tab["$pp_colour_addg"] = 0
	tab["$pp_colour_addb"] = 0
	tab["$pp_colour_brightness"] = 0
	tab["$pp_colour_contrast"] = 1
	tab["$pp_colour_colour"] = 1
	tab["$pp_colour_mulg"] = 0
	tab["$pp_colour_mulb"] = 0
	tab["$pp_colour_mulr"] = 0
	
	local function RenderHeroineEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_heroine_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_heroine_high_start")
			local pf
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				pf = (curtime - s) / (e - s)
				pf = pf * HIGH_INTENSITY
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				STROBE_PACE = 0.5
				pf = 1 - (curtime-s) / (e-s)
				pf = pf*HIGH_INTENSITY
			else
				pf = HIGH_INTENSITY
			end
			if (!cdw or cdw < curtime) then
				cdw = curtime + STROBE_PACE
				cdw2 = cdw2 * -1
			end
			if (cdw2 == -1) then
				cdw3 = 2
			else
				cdw3 = 0
			end
			local ich = (cdw2 * ((cdw - curtime) * (2 / STROBE_PACE))) + cdw3 - 1
			tab["$pp_colour_addr"] = pf * (ich + 1)
			DrawMaterialOverlay("highs/shader3", pf*ich*0.05)
			DrawColorModify(tab)
		else
			hook.Remove("RenderScreenspaceEffects", "drug_heroine_high")
		end
	end

	local cdww, cdww2, cdww3
	cdww2 = -1
	local STROBE_PACE_2 = 1

	local function DrawHeroineNotice()
		local ply = LocalPlayer()
		local var1 = ply:GetDrugVar("drug_heroine_high_start")
		local var2 = ply:GetDrugVar("drug_heroine_high_end")
		local curtime = CurTime()
		if (var1 != 0 and var2 > curtime) then
			if (var2 - TRANSITION_TIME < curtime) then
				if !cdww or cdww < curtime then
					cdww = curtime + 1
					cdww2 = cdww2 * -1
				end
				if cdww2 == -1 then
					cdww3 = 255
				else
					cdww3 = 0
				end
				local ich = (cdww2 * ((cdww - curtime) * 255)) + cdww3
				draw.SimpleText("Du brauchst mehr Heroin!", "Trebuchet24", ScrW() / 2, ScrH() * 3 / 4, Color(255, 255, 255, ich), TEXT_ALIGN_CENTER)
			end
		else
			hook.Remove("HUDPaint", "drug_heroine_notice")
		end
	end

	hook.Add("drug_varcall", "drug_heroine_vars", function(name, var)
		if name == "drug_heroine_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_heroine_high")
				hook.Remove("HUDPaint", "drug_heroine_notice")
			else
				hook.Add("RenderScreenspaceEffects", "drug_heroine_high", RenderHeroineEffects)
				hook.Add("HUDPaint", "drug_heroine_notice", DrawHeroineNotice)
			end
		end
	end)
end