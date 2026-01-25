timer.Simple(0, function()
	if DarkRP then
		local NoDropIfEmpty = {
			["m9k_ex41"] = true,
			["m9k_m202"] = true,
			["m9k_m79gl"] = true,
			["m9k_matador"] = true,
			["m9k_milkormgl"] = true,
			["m9k_rpg7"] = true
		}

		local NoDrop = {
			["m9k_orbital_strike"] = true,
		}

		local RecoilMultiplicator = 1
		local SpreadMultiplicator = 0.75
		local DamageMultiplicator = 1
		local DisableContextMenu = 0

		hook.Add("canDropWeapon", "MG_RestrictDrop", function(ply, wep)
			if !IsValid(wep) then return end
			if (wep:GetClass() == "m9k_suicide_bomb" or wep:GetClass() == "m9k_proxy_mine") and wep.Planted then
				return false
			end
			if (wep:GetClass() == "m9k_ied_detonator" and wep.BoxDropped) then
				return false
			end
			if (wep.IsGrenade and wep:Clip1() == 0 and ply:GetAmmoCount(wep:GetPrimaryAmmoType()) == 0) then
				return false
			end
			if (NoDropIfEmpty[wep:GetClass()] == true and wep:Clip1() == 0 and ply:GetAmmoCount(wep:GetPrimaryAmmoType()) == 0) then
				return false
			end
			if (NoDrop[wep:GetClass()] == true) then
				return false
			end
		end)

		if GetConVar("mg_m9k_damagemultiplicator"):GetFloat() != DamageMultiplicator then
			RunConsoleCommand("mg_m9k_damagemultiplicator", DamageMultiplicator)
		end
		if GetConVar("mg_m9k_spreadmultiplicator"):GetFloat() != SpreadMultiplicator then
			RunConsoleCommand("mg_m9k_spreadmultiplicator", SpreadMultiplicator)
		end
		if GetConVar("mg_m9k_recoilmultiplicator"):GetFloat() != RecoilMultiplicator then
			RunConsoleCommand("mg_m9k_recoilmultiplicator", RecoilMultiplicator)
		end
		if GetConVar("mg_m9k_disablecontextmenu"):GetInt() != DisableContextMenu then
			RunConsoleCommand("mg_m9k_disablecontextmenu", DisableContextMenu)
		end

		print("[MG Weapons] DarkRP settings adjusted!")
	end
end)