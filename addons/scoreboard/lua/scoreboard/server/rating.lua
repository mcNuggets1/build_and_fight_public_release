sql.Query("CREATE TABLE IF NOT EXISTS ratings (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, target varchar(255), rating INTEGER);")
sql.Query("CREATE INDEX IF NOT EXISTS IDX_RATINGS_TARGET ON ratings (target DESC)")

local ValidRatings = {"rich", "smile", "love", "artistic", "gold_star", "builder", "gay", "informative", "friendly", "lol", "toxic", "driving", "flying", "stunter", "god"}
local function GetRatingID(name)
	for k,v in ipairs(ValidRatings) do
		if name == v then
			return k
		end
	end
	return false
end

local function GetRatingName(id)
	return ValidRatings[id]
end

Scoreboard.UpdatePlayerRatings = function(ply)
	if !IsValid(ply) then return false end
	local result = sql.Query("SELECT rating, count(*) as cnt FROM ratings WHERE target = '"..ply:SteamID().."' GROUP BY rating")
	if !result then return false end
	for _, row in pairs(result) do
		if row["cnt"] == 0 then continue end
		ply:SetNWInt("Rating_"..ValidRatings[tonumber(row["rating"])], row["cnt"])
	end
end

local function RateUser(ply, command, arguments)
	local rater = ply
	if !IsValid(rater) then return end
	local target = Entity(tonumber(arguments[1]))
	local rating = arguments[2]
	if !IsValid(target) or !target:IsPlayer() or rater == target then return end
	local rating_id = GetRatingID(rating)
	local rater_id = rater:SteamID()
	local target_id = target:SteamID()
	if !rating_id then return false end
	local rating_name = GetRatingName(rating_id)
	target.RatingTimers = target.RatingTimers or {}
	if (target.RatingTimers[rater_id] or 0) > CurTime() then	
		rater:ChatPrint("Bitte warte "..string.ToMinutesSeconds(target.RatingTimers[rater_id] - CurTime()).." min, bevor du "..target:Name().." erneut bewertest!\n")
		return
	end
	target.RatingTimers[rater_id] = CurTime() + 600
	target:ChatPrint(rater:Name().." hat dir ein \""..rating_name.."\"-Rating gegeben.\n")
	rater:ChatPrint("Du hast "..target:Name().." ein \""..rating_name.."\"-Rating gegeben.\n")
	sql.Query("INSERT INTO ratings (target, rating) VALUES ('"..target_id.."', "..rating_id..")")
	Scoreboard.UpdatePlayerRatings(target)
end
concommand.Add("scoreboard_rateuser", RateUser)