if !PROVIDER then return end

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

function PROVIDER:Initialize()
	if self:UseMySQL() then
		self:Query("CREATE TABLE IF NOT EXISTS achv (steamid varchar(100) NOT NULL, achievement varchar(100) NOT NULL, value INTEGER DEFAULT 0, completed NUMERIC DEFAULT FALSE, completedOn INTEGER NULL, PRIMARY KEY(steamid, achievement), KEY `IDX_ACHV_STEAMID` (`steamid`))")
	else
		self:Query("CREATE TABLE IF NOT EXISTS achv (steamid varchar(100) NOT NULL, achievement varchar(100) NOT NULL, value INTEGER DEFAULT 0, completed NUMERIC DEFAULT FALSE, completedOn INTEGER NULL, PRIMARY KEY (steamid, achievement))")
		self:Query("CREATE INDEX IF NOT EXISTS IDX_ACHV_STEAMID ON achv (steamid)")
	end
end

function PROVIDER:GetPlayerAchievements(ply, callback)
	self:Query("SELECT * FROM achv WHERE steamid = '"..ply:SteamID().."'", function(data)
		if !IsValid(ply) then return end
		local return_data = {}
		for _, v in pairs(data or {}) do
			local data = {}
			data["Value"] = v.value
			data["Completed"] = tostring(v.completed) == "1"
			data["CompletedOn"] = tonumber(v.completedOn)
			return_data[v.achievement] = data
		end
		callback(return_data)
	end)
end

function PROVIDER:SetPlayerAchievement(ply, achv, senddata)
	self:Query(string.format("REPLACE INTO achv VALUES('%s', %s, %s, %s, %s)", ply:SteamID(), self:SQLStr(achv), senddata["Value"], senddata["Completed"] and "1" or "0", senddata["CompletedOn"] or "NULL"))
end

function PROVIDER:ResetPlayerAchievements(ply)
	ply = isstring(ply) and ply or ply:SteamID()
	self:Query(string.format("DELETE FROM achv WHERE steamid = '%s'", ply))
end