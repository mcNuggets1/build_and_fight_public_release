PS.Config = {}

PS.Config.DataProvider = "sql"
PS.Config.ShopKey = KEY_F4
PS.Config.ShopKeyName = "F4"
PS.Config.ShopCommand = "shop"
PS.Config.ShopChatCommand = "!shop"
PS.Config.PointsOverTime = true
PS.Config.DefaultPoints = 10000
PS.Config.DefaultItems = {"tec9", "usp"}
PS.Config.PointsOverTimeDelay = 10
PS.Config.PointsOverTimeAmount = 1500
PS.Config.AdminCanAccessAdminTab = false
PS.Config.SuperAdminCanAccessAdminTab = true
PS.Config.CanPlayersGivePoints = true
PS.Config.CanPlayersGivePointsUTime = 360 * 60 -- 6 Stunden
PS.Config.DisplayPreviewInMenu = true
PS.Config.PointsName = "Cash"
PS.Config.SortItemsBy = "Name"
PS.Config.SortItemsByOwned = true
PS.Config.ItemFolder = "items_sbox"

PS.Config.CalculateBuyPrice = function(ply, item)
	return item.Price
end

PS.Config.CalculateSellPrice = function(ply, item)
	return math.ceil(item.Price * 0.25)
end