Crates.Bonuses = {}

util.AddNetworkString("Crates.SendMessage")
function Crates.SendMessage(...)
	net.Start("Crates.SendMessage")
		net.WriteTable({...})
	net.Broadcast()
end

table.insert(Crates.Bonuses, {
	bonus = function(ply)
		local money = Crates.PointsSinglePlayer[math.random(1, #Crates.PointsSinglePlayer)]
		if ply.MG_AddMoney then
			ply:MG_AddMoney(money)
		else
			ply:PS_GivePoints(money)
		end
		local tm_col = CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())
		Crates.SendMessage(tm_col, ply:Name(), color_white, " hat ", Color(245, 184, 0), string.Comma(money), color_white, " Cash aus einer Kiste erhalten.")
	end
})

table.insert(Crates.Bonuses, {
	bonus = function(ply)
		local item, id = table.Random(PS.Items)
		if !item then return end
		local allowed = true
		if item.AllowedUserGroups and #item.AllowedUserGroups > 0 then
			if !table.HasValue(item.AllowedUserGroups, ply:PS_GetUsergroup()) then
				allowed = false
			end
		end
		if ply:PS_HasItem(id) or item.UnboxOnly or !allowed then
			local money = math.ceil(item.Price * 0.1)
			if ply.MG_AddMoney then
				ply:MG_AddMoney(money)
			else
				ply:PS_GivePoints(money)
			end
			local tm_col = CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())
			Crates.SendMessage(tm_col, ply:Name(), color_white, " hat ", Color(245, 184, 0), string.Comma(money), color_white, " Cash aus einer zufälligen Kiste erhalten.")
		else
			ply:PS_GiveItem(id)
			local tm_col = CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())
			Crates.SendMessage(tm_col, ply:Name(), color_white, " hat ", Color(0, 156, 0), item.Name, color_white, " aus einer Kiste erhalten.")
		end
	end
})

table.insert(Crates.Bonuses, {
	bonus = function(ply)
		local money = Crates.PointsAllPlayers[math.random(1, #Crates.PointsAllPlayers)]
		for _,v in ipairs(player.GetAll()) do
			if v.MG_AddMoney then
				v:MG_AddMoney(money)
			else
				v:PS_GivePoints(money)
			end
		end
		local tm_col = CORPSE and Color(255, 255, 150) or team.GetColor(ply:Team())
		Crates.SendMessage(color_white, "Alle Spieler haben ", Color(245, 184, 0), string.Comma(money), color_white, " Cash aus der Kiste von ", tm_col, ply:Name(), color_white, " erhalten.")
	end
})

function Crates.GiveBonuses(ply)
	Crates.Bonuses[math.random(#Crates.Bonuses)].bonus(ply)
end