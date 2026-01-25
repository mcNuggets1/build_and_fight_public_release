ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "PCP"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.TRANSITION_TIME = 3
ENT.LASTINGEFFECT = 40
ENT.DEATHPENALTY = 200
ENT.EFFECT_TEXT = "Erhöhung der Gesundheit (+5-10%)"
ENT.EpilepsyWarn = true

if CLIENT then
	killicon.Add("drug_pcp", "killicons/drug_pcp_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME

	local tab = {}
	tab["$pp_colour_addr"] = 0
	tab["$pp_colour_addg"] = 0
	tab["$pp_colour_addb"] = 0
	tab["$pp_colour_brightness"] = 0.1
	tab["$pp_colour_contrast"] = 1
	tab["$pp_colour_colour"] = 1
	tab["$pp_colour_mulr"] = 0
	tab["$pp_colour_mulg"] = 0
	tab["$pp_colour_mulb"] = 0

	local function RenderPCPEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_pcp_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_pcp_high_start")
			local pf = 1
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				pf = (curtime - s) / (e - s)
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				pf = 1 - (curtime - s) / (e - s)
			end
			tab["$pp_colour_addr"] = pf * math.Rand(0, 1)
			tab["$pp_colour_addg"] = pf * math.Rand(0, 1)
			tab["$pp_colour_addb"] = pf * math.Rand(0, 1)
			DrawColorModify(tab)
		else
			hook.Remove("RenderScreenspaceEffects", "drug_pcp_high")
		end
	end

	hook.Add("drug_varcall", "drug_pcp_vars", function(name, var)
		if name == "drug_pcp_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_pcp_high")
			else
				hook.Add("RenderScreenspaceEffects", "drug_pcp_high", RenderPCPEffects)
			end
		end
	end)
end