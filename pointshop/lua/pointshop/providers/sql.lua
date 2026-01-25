PS.DefaultItems = PS.DefaultItems or {}
for _,v in pairs(PS.Config.DefaultItems) do
	PS.DefaultItems[v] = {Modifiers = {}, Equipped = true}
end

function PROVIDER:UseMySQL()
	return MySQLite and MySQLite.isMySQL() or false
end

function PROVIDER:SQLStr(str)
	if self:UseMySQL() then
		return MySQLite.SQLStr(str)
	else
		return sql.SQLStr(str)
	end
end

function PROVIDER:Query(query, func)
	if self:UseMySQL() then
		MySQLite.query(query, function(res)
			if func then
				func(res)
			end
		end)
	else
		local res = sql.Query(query)
		if func then
			func(res)
		end
	end
end

-- We gotta update the column points to a BIGINT due to that one player hitting the integer limit
local function pointsCheck(results)
	if not results then return end

	local columns = {}
	for _, resultData in ipairs(results or {}) do
		columns[resultData.name] = resultData
	end

	if not columns.points then return end
	if string.lower(columns.points.Type) == "bigint" then return end

	print("[PointShop] Updating points column to a BIGINT")
	MySQLite.query("ALTER TABLE pointshop MODIFY points BIGINT NOT NULL DEFAULT 0;", function() end)
end

function PROVIDER:Initialize()
	self:Query("CREATE TABLE IF NOT EXISTS pointshop (steamid varchar(255) PRIMARY KEY NOT NULL, points BIGINT NOT NULL, items TEXT NOT NULL)")

	-- GMod's sqllite handles int and bigint the same iirc so for local games we do not need to update the column
	if self:UseMySQL() then
		MySQLite.query("SHOW FULL COLUMNS FROM pointshop", pointsCheck)
	end
end

function PROVIDER:GetData(ply, callback)
	local sid = ply:SteamID()
	self:Query("SELECT points, items FROM pointshop WHERE steamid = '"..sid.."'", function(data)
		if !IsValid(ply) then return end
		local points = data and data[1] and data[1]["points"]
		local items = data and data[1] and data[1]["items"]
		if (!points or points == "NULL") and (!items or items == "NULL") then
			local default_items = table.Copy(PS.DefaultItems)
			points = PS.Config.DefaultPoints
			items = util.TableToJSON(default_items)
			self:Query("INSERT INTO pointshop (steamid, points, items) VALUES ('"..sid.."', "..points..", '"..items.."')")
			items = default_items
			callback(points, items)
		else
			items = util.JSONToTable(items)
			callback(points, items)
		end
	end)
end

function PROVIDER:SetData(ply, points, items)
	items = self:SQLStr(util.TableToJSON(items))
	self:Query("UPDATE pointshop SET points = "..points..", items = "..items.." WHERE steamid = '"..ply:SteamID().."'")
end

function PROVIDER:ResetData(ply)
	ply = isstring(ply) and ply or ply:SteamID()
	self:Query("DELETE FROM pointshop WHERE steamid = '"..ply.."'")
end