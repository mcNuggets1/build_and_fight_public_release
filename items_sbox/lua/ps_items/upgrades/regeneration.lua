ITEM.Name = 'Langsame Regeneration'
ITEM.Price = 120000
ITEM.Model = 'models/healthvial.mdl'
ITEM.Description = "Heilt alle 10 Sekunden ein Leben.\nKann maximal 50 Leben regenerieren."
ITEM.NoPreview = true

function ITEM:OnEquip(ply, modifications)
	local timername = "PS_HealthRegeneration_"..ply:SteamID()
	timer.Create(timername, 10, 0, function()
		if IsValid(ply) and ply:Alive() and (ply.PS_Regen or 0) <= 50 then
			if ply:Health() < ply:GetMaxHealth() then
				ply.PS_Regen = ply.PS_Regen or 0
				ply.PS_Regen = ply.PS_Regen + 1
				ply:SetHealth(ply:Health() + 1)
			end
		else
			timer.Remove(timername)
		end
	end)
end

function ITEM:OnHolster(ply)
	timer.Remove("PS_HealthRegeneration_"..ply:SteamID())
end

hook.Add("PlayerDeath", "PS_HealthRegeneration", function(ply)
	ply.PS_Regen = nil
end)