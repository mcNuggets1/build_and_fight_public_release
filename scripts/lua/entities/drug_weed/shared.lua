ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Marihuana"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.TRANSITION_TIME = 5
ENT.LASTINGEFFECT = 35
ENT.EFFECT_TEXT = "Heilung (+10-15%)"
ENT.IsDeadly = false

if CLIENT then
	killicon.Add("drug_weed", "killicons/drug_weed_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME
	local HIGH_INTENSITY = 0.77

	local tab = {}
	tab["$pp_colour_addr"] = 0
	tab["$pp_colour_addg"] = 0
	tab["$pp_colour_addb"] = 0
	tab["$pp_colour_mulr"] = 0
	tab["$pp_colour_mulg"] = 0
	tab["$pp_colour_mulb"] = 0

	local function RenderWeedEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_weed_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_weed_high_start")
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				local pf = (curtime - s) / (e - s)
				ply:SetDSP(6)
				tab["$pp_colour_colour"] = 1 - pf * 0.3
				tab["$pp_colour_brightness"] = -pf * 0.11
				tab["$pp_colour_contrast"] = 1 + pf * 1.62
				DrawMotionBlur(0.03, pf*HIGH_INTENSITY, 0)
				DrawColorModify(tab) 
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				local pf = 1 - (curtime - s) / (e - s)
				ply:SetDSP(1)
				tab["$pp_colour_colour"] = 1 - pf * 0.3
				tab["$pp_colour_brightness"] = -pf * 0.11
				tab["$pp_colour_contrast"] = 1 + pf * 1.62
				DrawMotionBlur(0.03, pf * HIGH_INTENSITY, 0)
				DrawColorModify(tab) 
			else
				tab["$pp_colour_colour"] = 0.77
				tab["$pp_colour_brightness"] = -0.11
				tab["$pp_colour_contrast"] = 2.62
				DrawMotionBlur(0.03, HIGH_INTENSITY, 0)
				DrawColorModify(tab) 
				ply:SetDSP(6)
			end
		else
			hook.Remove("RenderScreenspaceEffects", "drug_weed_high")
		end
	end

	hook.Add("drug_varcall", "drug_weed_vars", function(name, var)
		if name == "drug_weed_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_weed_high")
			else
				hook.Add("RenderScreenspaceEffects", "drug_weed_high", RenderWeedEffects)
			end
		end
	end)
end