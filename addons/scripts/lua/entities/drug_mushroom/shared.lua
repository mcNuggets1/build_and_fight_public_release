ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Magic Mushroom"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.TRANSITION_TIME = 6
ENT.LASTINGEFFECT = 45
ENT.DEATHPENALTY = 180
ENT.EFFECT_TEXT = "Schwebesprung (-75% Gravitation)"

if CLIENT then
	killicon.Add("drug_mushroom", "killicons/drug_mushroom_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME

	local shroom_tab = {}
	shroom_tab["$pp_colour_addr"] = 0
	shroom_tab["$pp_colour_addg"] = 0
	shroom_tab["$pp_colour_addb"] = 0
	shroom_tab["$pp_colour_mulr"] = 0
	shroom_tab["$pp_colour_mulg"] = 0
	shroom_tab["$pp_colour_mulb"] = 0

	local function RenderMushroomEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_mushroom_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_mushroom_high_start")
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				local c = curtime
				local pf = (c - s) / (e - s)
				shroom_tab["$pp_colour_colour"] = 1 - pf * 0.37
				shroom_tab["$pp_colour_brightness"] = -pf * 0.15
				shroom_tab["$pp_colour_contrast"] = 1 + pf * 1.57
				DrawColorModify(shroom_tab) 
				DrawSharpen(8.32, 1.03 * pf)
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				local c = curtime
				local pf = 1 - (c - s) / (e - s)
				shroom_tab["$pp_colour_colour"] = 1 - pf * 0.37
				shroom_tab["$pp_colour_brightness"] = -pf * 0.15
				shroom_tab["$pp_colour_contrast"] = 1 + pf * 1.57
				DrawColorModify(shroom_tab) 
				DrawSharpen(8.32, 1.03 * pf)
			else
				shroom_tab["$pp_colour_colour"] = 0.63
				shroom_tab["$pp_colour_brightness"] = -0.15
				shroom_tab["$pp_colour_contrast"] = 2.57
				DrawColorModify(shroom_tab) 
				DrawSharpen(8.32, 1.03)
			end
		else
			hook.Remove("RenderScreenspaceEffects", "drug_mushroom_high")
		end
	end

	hook.Add("drug_varcall", "drug_mushroom_vars", function(name, var)
		if name == "drug_mushroom_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_mushroom_high")
			else
				hook.Add("RenderScreenspaceEffects", "drug_mushroom_high", RenderMushroomEffects)
			end
		end
	end)
end