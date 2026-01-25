hook.Add("PreventScreenClicks", "MG_PreventScreenClicks", function()
	local pnl = vgui.GetHoveredPanel()
	if IsValid(pnl) then
		if pnl:IsWorldClicker() then return true end
		while IsValid(pnl:GetParent()) do
			pnl = pnl:GetParent()
			if pnl:IsWorldClicker() then return true end
		end
	else
		return true
	end
end)

hook.Add("OnContextMenuOpen", "MG_PreventScreenClicks", function()
	RunConsoleCommand("-attack")
	RunConsoleCommand("-attack2")
end)