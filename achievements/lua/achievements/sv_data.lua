local function LoadDataProviders()
	local provider = achievements.DataProvider
	if !provider or istable(provider) then return end
	local path = achievements.Path.."/data/"..provider..".lua"
	if !file.Exists(path, "LUA") then
		error(string.format("[ACHV] %q is an unknown data provider.", provider))
	end
	PROVIDER = {}
	PROVIDER.__index = {}
	include(path)
	achievements.DataProvider = PROVIDER
	achievements.DataProvider:Initialize()
	PROVIDER = nil
end

hook.Add(GetConVarNumber("mg_mysql") == 1 and "DatabaseInitialized" or "Initialize", "achievements_Initialize", function()
	LoadDataProviders()
	for _, v in ipairs(player.GetAll()) do
		achievements.LoadPlayerData(v)
	end
	achievements.UpdateAchievements()
end)