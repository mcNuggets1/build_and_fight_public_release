timer.Simple(0, function()
	if PVP then
		local RecoilMultiplicator = 0.75
		local SpreadMultiplicator = 0.75
		local DamageMultiplicator = 1
		local DisableContextMenu = 0

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

		print("MG: Sandbox-Settings adjusted!")
	end
end)