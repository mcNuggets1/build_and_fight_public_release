ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Crystal Meth"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.TRANSITION_TIME = 5
ENT.LASTINGEFFECT = 50
ENT.DEATHPENALTY = 200
ENT.EFFECT_TEXT = "Extreme Wut (+25% Schaden)"

if CLIENT then
	killicon.Add("drug_meth", "killicons/drug_meth_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME
	local HIGH_INTENSITY = 0.8
	local STROBE_PACE = 1
	local cdw, cdw2, cdw3
	cdw2 = -1

	local tab = {}
	tab["$pp_colour_addr"] = 0
	tab["$pp_colour_addg"] = 0
	tab["$pp_colour_addb"] = 0
	tab["$pp_colour_brightness"] = 0
	tab["$pp_colour_contrast"] = 1
	tab["$pp_colour_mulr"] = 0
	tab["$pp_colour_mulg"] = 0
	tab["$pp_colour_mulb"] = 0

	local function RenderMethEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_meth_high_end")
		local curtime = CurTime()
		if var2 > curtime then
			local var1 = ply:GetDrugVar("drug_meth_high_start")
			local pf
			if var1 + TRANSITION_TIME > curtime then
				local s = var1
				local e = s + TRANSITION_TIME
				pf = (curtime - s) / (e - s)
				pf = pf * HIGH_INTENSITY
				ply:SetDSP(7)
				tab["$pp_colour_colour"] = 1 - pf / 0.3
				tab["$pp_colour_brightness"] = -pf / 0.11
				tab["$pp_colour_contrast"] = 1 + pf / 1.62
				DrawMotionBlur(0.03, pf, 0)
				DrawColorModify(tab)
			elseif var2 - TRANSITION_TIME < curtime then
				local e = var2
				local s = e - TRANSITION_TIME
				pf = 1 - (curtime - s) / (e - s)
				pf = pf * HIGH_INTENSITY
				tab["$pp_colour_colour"] = 1 - pf / 0.3
				tab["$pp_colour_brightness"] = -pf / 0.11
				tab["$pp_colour_contrast"] = 1 + pf / 1.62
				DrawMotionBlur(0.03, pf, 0)
				DrawColorModify(tab)
				ply:SetDSP(1)
			else
				pf = HIGH_INTENSITY
			end
			if !cdw or cdw < curtime then
				cdw = curtime + 1
				cdw2 = cdw2 * -1
			end
			if cdw2 == -1 then
				cdw3 = 2
			else
				cdw3 = 0
			end
			local ich = (cdw2 * ((cdw - curtime) * (2 / 1))) + cdw3 - 1
			tab["$pp_colour_colour"] = 0.385
			tab["$pp_colour_brightness"] = -0.055
			tab["$pp_colour_contrast"] = 1.31
			DrawMotionBlur(0.03, pf, 0)
			DrawColorModify(tab)
			DrawMaterialOverlay("highs/invuln_overlay_blue", pf * ich * 0.05)
			DrawMaterialOverlay("highs/shader3", pf * ich * 0.05)
			DrawSharpen(pf * ich * 5, 2)
		else
			hook.Remove("RenderScreenspaceEffects", "drug_meth_high")
		end
	end

	hook.Add("drug_varcall", "drug_meth_vars", function(name, var)
		if name == "drug_meth_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_meth_high")
			else
				hook.Add("RenderScreenspaceEffects", "drug_meth_high", RenderMethEffects)
			end
		end
	end)
end