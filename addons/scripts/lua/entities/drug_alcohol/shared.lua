ENT.Type = "anim"
ENT.Base = "drug_base"
ENT.PrintName = "Alkohol"
ENT.Category = "Drogen"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.LASTINGEFFECT = 40
ENT.DEATHPENALTY = 400
ENT.EFFECT_TEXT = "Kontrollverlust"
ENT.IsLegal = true

if CLIENT then
	killicon.Add("drug_alcohol", "killicons/drug_alcohol_killicon", Color(255, 80, 0, 255))

	local DEATHPENALTY = ENT.DEATHPENALTY
	local function RenderAlcoholEffects()
		local ply = LocalPlayer()
		local var2 = ply:GetDrugVar("drug_alcohol_high_end")
		local curtime = CurTime()
		if (var2 > curtime) then
			local var1 = ply:GetDrugVar("drug_alcohol_high_start")
			local intensity = (var2 - curtime) / DEATHPENALTY
			DrawMotionBlur(Lerp(intensity, 0.1, 0.01), Lerp(intensity, 0.5, 2), Lerp(intensity, 0, 0.01))
		else
			hook.Remove("RenderScreenspaceEffects", "drug_alcohol_high")
		end
	end

	hook.Add("drug_varcall", "drug_alcohol_vars", function(name, var)
		if name == "drug_alcohol_high_end" then
			if !var or var == 0 then
				hook.Remove("RenderScreenspaceEffects", "drug_alcohol_high")
			else
				hook.Add("RenderScreenspaceEffects", "drug_alcohol_high", RenderAlcoholEffects)
			end
		end
	end)
end