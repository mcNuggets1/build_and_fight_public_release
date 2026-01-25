local xyz = {"x", "y", "z"}
function SZ:AddNewZone(map, tab)
	if (string.lower(map) != game.GetMap()) then return end
	tab.SizeForwards.x = math.abs(tab.SizeForwards.x)
	tab.SizeForwards.y = math.abs(tab.SizeForwards.y)
	tab.SizeForwards.z = math.abs(tab.SizeForwards.z)
	for _,v in ipairs(xyz) do
		tab.SizeForwards[v] = math.abs(tab.SizeForwards[v])
		if (tab.SizeBackwards[v] > 0) then
			tab.SizeBackwards[v] = tab.SizeBackwards[v] * -1
		end
	end
	table.insert(self.Data, tab)
end

local meta = FindMetaTable("Player")
function meta:SZ_InsideSafeZone()
	local pos = self:GetPos()
	for _,v in ipairs(SZ.Data) do
		if pos:WithinAABox(v.Center + v.SizeBackwards, v.Center + v.SizeForwards) then
			return true
		end
	end
	return false
end