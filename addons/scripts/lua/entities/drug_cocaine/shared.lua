ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Kokain"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.LASTINGEFFECT = 40
ENT.TRANSITION_TIME = 6
ENT.DEATHPENALTY = 200
ENT.EFFECT_TEXT = "Geschwindigkeitsanstieg (+50%)"

local function AdjustCocainePlayerSpeed(ply, mv)
	if ply:GetDrugVar("drug_cocaine_high_end") > CurTime() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 1.5)
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 1.5)
	end
end

if CLIENT then
	killicon.Add("drug_cocaine", "killicons/drug_cocaine_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME
	local HIGH_INTENSITY = 0.8
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

	local function RenderCocaineEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_cocaine_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_cocaine_high_start")
			local pf
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				pf = (curtime - s) / (e - s)
				pf = pf * HIGH_INTENSITY
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				pf = 1 - (curtime - s) / (e - s)
				pf = pf * HIGH_INTENSITY
				ply:SetDSP(1)
			else
				pf = HIGH_INTENSITY
			end
			if (!cdw or cdw < curtime) then
				cdw = curtime + 1
				cdw2 = cdw2 * -1
			end
			if (cdw2 == -1) then
				cdw3 = 2
			else
				cdw3 = 0
			end
			local ich = (cdw2 * ((cdw - curtime) * (2 / 1))) + cdw3 - 1
			DrawMaterialOverlay("highs/shader3", pf * ich * 0.05)
			DrawSharpen(pf * ich * 5, 2) 
		else
			hook.Remove("RenderScreenspaceEffects", "drug_cocaine_high")
		end
	end

	hook.Add("drug_varcall", "drug_cocaine_vars", function(name, var)
		if name == "drug_cocaine_high_end" then
			if !var or var == 0 then
				hook.Remove("Move", "drug_cocaine_speed")
				hook.Remove("RenderScreenspaceEffects", "drug_cocaine_high")
			else
				hook.Add("Move", "drug_cocaine_speed", AdjustCocainePlayerSpeed)
				hook.Add("RenderScreenspaceEffects", "drug_cocaine_high", RenderCocaineEffects)
			end
		end
	end)
end