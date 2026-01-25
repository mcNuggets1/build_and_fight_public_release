ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Zigaretten"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.LASTINGEFFECT = 30
ENT.TRANSITION_TIME = 3
ENT.EFFECT_TEXT = "Wut (+10% Schaden)"
ENT.IsLegal = true
ENT.IsDeadly = false

if CLIENT then
	killicon.Add("drug_cigarette", "killicons/drug_cigarette_killicon", Color(255, 80, 0, 255))

	local TRANSITION_TIME = ENT.TRANSITION_TIME
	local function DrawCigaretteHUD()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_cigarette_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_cigarette_high_start")
			local pf = 1
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				local c = curtime
				pf = (c - s) / (e - s)
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				local c = curtime
				pf = 1 - (c - s) / (e - s)
			end
			local a = pf * 255
			local say = "Du hast geraucht. Nun bist du cool."
			draw.DrawText(say, "Trebuchet24", ScrW() / 2 + 1, ScrH() * 0.6 + 1, Color(255, 255, 255, a), TEXT_ALIGN_CENTER)
			draw.DrawText(say, "Trebuchet24", ScrW() / 2 - 1, ScrH() * 0.6-1, Color(255, 255, 255, a), TEXT_ALIGN_CENTER)
			draw.DrawText(say, "Trebuchet24", ScrW() / 2 - 1, ScrH() * 0.6 + 1, Color(255, 255, 255, a), TEXT_ALIGN_CENTER)
			draw.DrawText(say, "Trebuchet24", ScrW() / 2 + 1, ScrH() * 0.6 - 1, Color(255, 255, 255, a), TEXT_ALIGN_CENTER)
			draw.DrawText(say, "Trebuchet24", ScrW() / 2, ScrH() * 0.6, Color(255, 9, 9, 255), TEXT_ALIGN_CENTER)
		else
			hook.Remove("HUDPaint", "drug_cigarette_msg")
		end
	end

	local function RenderCigaretteEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_cigarette_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_cigarette_high_start")
			if (var1 + TRANSITION_TIME > curtime) then
				local s = var1
				local e = s + TRANSITION_TIME
				local pf = (curtime - s) / (e - s)
				DrawSharpen(pf, 1)
			elseif (var2 - TRANSITION_TIME < curtime) then
				local e = var2
				local s = e - TRANSITION_TIME
				local pf = 1 - (curtime - s) / (e - s)
				DrawSharpen(pf, 1)
			else
				DrawSharpen(1, 1)
			end
		else
			hook.Remove("RenderScreenspaceEffects", "drug_cigarette_high")
		end
	end

	hook.Add("drug_varcall", "drug_cigarette_vars", function(name, var)
		if name == "drug_cigarette_high_end" then
			if !var or var == 0 then
				hook.Remove("HUDPaint", "drug_cigarette_msg")
				hook.Remove("RenderScreenspaceEffects", "drug_cigarette_high")
			else
				hook.Add("HUDPaint", "drug_cigarette_msg", DrawCigaretteHUD)
				hook.Add("RenderScreenspaceEffects", "drug_cigarette_high", RenderCigaretteEffects)
			end
		end
	end)
end