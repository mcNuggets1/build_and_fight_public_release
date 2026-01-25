ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "LSD"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.TRANSITION_TIME = 4
ENT.LASTINGEFFECT = 45
ENT.DEATHPENALTY = 180
ENT.EFFECT_TEXT = "Resistenz (+20%)"

if CLIENT then
	killicon.Add("drug_lsd", "killicons/drug_lsd_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME
	local HIGH_INTENSITY = 0.77

	local tab = {}
	tab["$pp_colour_addr"] = 0
	tab["$pp_colour_addg"] = 0
	tab["$pp_colour_addb"] = 0
	tab["$pp_colour_mulr"] = 0
	tab["$pp_colour_mulg"] = 0
	tab["$pp_colour_mulb"] = 0

	local function RenderLSDEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_lsd_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_lsd_high_start")
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				local pf = (curtime - s) / (e - s)
				tab["$pp_colour_colour"] = 1 + pf * 3
				tab["$pp_colour_brightness"] = -pf * 0.19
				tab["$pp_colour_contrast"] = 1 + pf * 5.31
				DrawBloom(0.65, (pf ^ 2) * 0.1, 9, 9, 4, 7.7, 255, 255, 255)
				DrawColorModify(tab) 
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				local pf = 1 - (curtime - s) / (e - s)
				tab["$pp_colour_colour"] = 1 + pf * 3
				tab["$pp_colour_brightness"] = -pf * 0.19
				tab["$pp_colour_contrast"] = 1 + pf * 5.31
				DrawBloom(0.65, (pf ^ 2) * 0.1, 9, 9, 4, 7.7, 255, 255, 255)
				DrawColorModify(tab) 
			else
				tab["$pp_colour_colour"] = 4
				tab["$pp_colour_brightness"] = -0.19
				tab["$pp_colour_contrast"] = 1 + 5.31
				DrawBloom(0.65, 0.1, 9, 9, 4, 7.7, 255, 255, 255)
				DrawColorModify(tab) 
			end
		else
			hook.Remove("RenderScreenspaceEffects", "drug_lsd_high")
		end
	end

	hook.Add("drug_varcall", "drug_lsd_vars", function(name, var)
		if name == "drug_lsd_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_lsd_high")
			else
				hook.Add("RenderScreenspaceEffects", "drug_lsd_high", RenderLSDEffects)
			end
		end
	end)
end