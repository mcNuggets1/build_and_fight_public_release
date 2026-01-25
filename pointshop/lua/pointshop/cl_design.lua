PS.Style_Config = {}

PS.Style_Config.Size = {1, 1}
PS.Style_Config.WindowSize = {0.75, 0.75}
PS.Style_Config.ShowIntroOnly1Time = true

PS.Style_Config.UseDefaultColor = "orange"
PS.Style_Config.UseDefaultBGColor = "black"
PS.Style_Config.UseDefaultWindowed = false

function PS.LoadColorTable(color)
	if !PS.Style_Config.ColorStyles[color] then
		color = PS.Style_Config.UseDefaultColor
	end
	PS.Style_Config.ColorSelected = color
	PS.Style_Config.Col = PS.Style_Config.ColorStyles[color].Col or {}
end

function PS.LoadBGColorTable(color)
	if !PS.Style_Config.BGColorStyles[color] then
		color = PS.Style_Config.UseDefaultBGColor
	end
	PS.Style_Config.BGColorSelected = color
	PS.Style_Config.BGCol = PS.Style_Config.BGColorStyles[color].Col or {}
end

CreateClientConVar("shop_style", PS.Style_Config.UseDefaultColor, true, false)
CreateClientConVar("shop_bgstyle", PS.Style_Config.UseDefaultBGColor, true, false)
CreateClientConVar("shop_windowed", PS.Style_Config.UseDefaultWindowed and 1 or 0, true, false)

PS.Style_Config.Windowed = GetConVar("shop_windowed"):GetBool() and true or false

function PS.SetupColorStyle(color, name)
	PS.Style_Config.ColorStyles = PS.Style_Config.ColorStyles or {}
	PS.Style_Config.ColorStyles[color] = PS.Style_Config.ColorStyles[color] or {}
	PS.Style_Config.ColorStyles[color].Name = name
	PS.Style_Config.ColorStyles[color].Col = table.Copy(PS.Style_Config.Col)
end

function PS.SetupBGColorStyle(color, name)
	PS.Style_Config.BGColorStyles = PS.Style_Config.BGColorStyles or {}
	PS.Style_Config.BGColorStyles[color] = PS.Style_Config.BGColorStyles[color] or {}
	PS.Style_Config.BGColorStyles[color].Name = name
	PS.Style_Config.BGColorStyles[color].Col = table.Copy(PS.Style_Config.BGCol)
end

PS.Style_Config.Col = {}
PS.Style_Config.BGCol = {}

PS.Style_Config.Col.PV = {}
PS.Style_Config.Col.PV.FootRing = Color(0, 255, 255, 255)
PS.Style_Config.Col.PV.BurstRing = Color(0, 200, 255, 255)
PS.Style_Config.Col.PV.Zoom = Color(0, 150, 255, 255)
PS.Style_Config.Col.PV.ZoomBar = Color(0, 255, 255, 255)
PS.Style_Config.Col.PV.Height = Color(0, 150, 255, 255)
PS.Style_Config.Col.PV.HeightBar = Color(0, 255, 255, 255)
PS.Style_Config.Col.IC = {}
PS.Style_Config.Col.IC.BackGround = Color(0, 50, 255, 5)
PS.Style_Config.Col.MN = {}
PS.Style_Config.Col.MN.PointShopText = Color(0, 200, 255, 255)
PS.Style_Config.Col.MN.BottomLine = Color(0, 150, 255, 255)
PS.Style_Config.Col.MN.DSWBoarderCol = Color(0, 150, 255, 255)
PS.Style_Config.Col.MN.DSWTextCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.DSWClickFX = Color(0, 150, 255, 255)
PS.Style_Config.Col.MN.SCBarOutLine = Color(0, 150, 255, 255)
PS.Style_Config.Col.SP = {}
PS.Style_Config.Col.SP.ShopTitle = Color(0, 255, 255, 255)
PS.Style_Config.Col.SP.MyPoints = Color(100, 200, 255, 255)
PS.Style_Config.Col.SP.FilterTitleText = Color(100, 200, 255, 255)
PS.Style_Config.Col.SP.ListItemName = Color(0, 200, 255, 255)
PS.Style_Config.Col.SP.ListItemPrice = Color(150, 150, 255, 255)
PS.Style_Config.Col.SP.ListItemPrice_No = Color(150, 150, 255, 100)
PS.Style_Config.Col.SP.ListBottomLine = Color(0, 200, 255, 20)
PS.Style_Config.Col.SP.ListItemHoverCol = Color(0, 50, 120, 255)
PS.Style_Config.Col.Inv = {}
PS.Style_Config.Col.Inv.InvTitle = Color(0, 255, 255, 255)
PS.Style_Config.Col.Inv.FilterTitleText = Color(100, 200, 255, 255)
PS.Style_Config.Col.Inv.ListItemName = Color(0, 200, 255, 255)
PS.Style_Config.Col.Inv.ListItemRefund = Color(150, 150, 255, 255)
PS.Style_Config.Col.Inv.ListEquippedText = Color(0, 255, 255, 255)
PS.Style_Config.Col.Inv.ListBottomLine = Color(0, 200, 255, 20)
PS.Style_Config.Col.Inv.ListItemHoverCol = Color(0, 50, 120, 255)
PS.Style_Config.Col.AP = {}
PS.Style_Config.Col.AP.TitleText = Color(0, 255, 255, 255)
PS.Style_Config.Col.AP.List_No = Color(0, 255, 255, 255)
PS.Style_Config.Col.AP.List_PlayerNick = Color(0, 200, 255, 255)
PS.Style_Config.Col.AP.List_PlayerPoints = Color(0, 255, 255, 255)
PS.Style_Config.Col.AP.List_PlayerItems = Color(0, 255, 255, 255)
PS.Style_Config.Col.AP.ListBottomLine = Color(0, 150, 255, 50)
PS.Style_Config.Col.PG = {}
PS.Style_Config.Col.PG.Main_Outline = Color(0, 150, 255, 255)
PS.Style_Config.Col.PG.Main_TitleText = Color(0, 220, 255, 255)
PS.Style_Config.Col.CC = {}
PS.Style_Config.Col.CC.Main_Outline = Color(0, 150, 255, 255)
PS.Style_Config.Col.PI = {}
PS.Style_Config.Col.PI.Main_TitleText = Color(0, 150, 255, 255)
PS.Style_Config.Col.PI.Main_Text = Color(0, 255, 255, 255)

PS.SetupColorStyle("blue", "Blau")

PS.Style_Config.Col.PV = {}
PS.Style_Config.Col.PV.FootRing = Color(255, 50, 0, 255)
PS.Style_Config.Col.PV.BurstRing = Color(255, 120, 0, 255)
PS.Style_Config.Col.PV.Zoom = Color(255, 50, 0, 255)
PS.Style_Config.Col.PV.ZoomBar = Color(255, 125, 0, 255)
PS.Style_Config.Col.PV.Height = Color(255, 50, 0, 255)
PS.Style_Config.Col.PV.HeightBar = Color(255, 125, 0, 255)
PS.Style_Config.Col.IC = {}
PS.Style_Config.Col.IC.BackGround = Color(255, 50, 0, 5)
PS.Style_Config.Col.MN = {}
PS.Style_Config.Col.MN.PointShopText = Color(255, 200, 0, 255)
PS.Style_Config.Col.MN.BottomLine = Color(255, 255, 0, 255)
PS.Style_Config.Col.MN.DSWBoarderCol = Color(255, 150, 0, 255)
PS.Style_Config.Col.MN.DSWTextCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.DSWClickFX = Color(255, 150, 0, 255)
PS.Style_Config.Col.MN.SCBarOutLine = Color(255, 150, 0, 255)
PS.Style_Config.Col.SP = {}
PS.Style_Config.Col.SP.ShopTitle = Color(255, 255, 0, 255)
PS.Style_Config.Col.SP.MyPoints = Color(255, 120, 0, 255)
PS.Style_Config.Col.SP.FilterTitleText = Color(255, 200, 0, 255)
PS.Style_Config.Col.SP.ListItemName = Color(255, 200, 0, 255)
PS.Style_Config.Col.SP.ListItemPrice = Color(255, 125, 0, 255)
PS.Style_Config.Col.SP.ListItemPrice_No = Color(255, 125, 0, 100)
PS.Style_Config.Col.SP.ListBottomLine = Color(255, 200, 0, 20)
PS.Style_Config.Col.SP.ListItemHoverCol = Color(150, 20, 0, 255)
PS.Style_Config.Col.Inv = {}
PS.Style_Config.Col.Inv.InvTitle = Color(255, 255, 0, 255)
PS.Style_Config.Col.Inv.FilterTitleText = Color(255, 200, 0, 255)
PS.Style_Config.Col.Inv.ListItemName = Color(255, 200, 0, 255)
PS.Style_Config.Col.Inv.ListItemRefund = Color(255, 125, 0, 255)
PS.Style_Config.Col.Inv.ListEquippedText = Color(255, 255, 0, 255)
PS.Style_Config.Col.Inv.ListBottomLine = Color(255, 200, 0, 20)
PS.Style_Config.Col.Inv.ListItemHoverCol = Color(150, 20, 0, 255)
PS.Style_Config.Col.AP = {}
PS.Style_Config.Col.AP.TitleText = Color(255, 255, 0, 255)
PS.Style_Config.Col.AP.List_No = Color(255, 255, 0, 255)
PS.Style_Config.Col.AP.List_PlayerNick = Color(255, 200, 0, 255)
PS.Style_Config.Col.AP.List_PlayerPoints = Color(255, 255, 0, 255)
PS.Style_Config.Col.AP.List_PlayerItems = Color(255, 255, 0, 255)
PS.Style_Config.Col.AP.ListBottomLine = Color(255, 150, 0, 50)
PS.Style_Config.Col.PG = {}
PS.Style_Config.Col.PG.Main_Outline = Color(255, 150, 0, 255)
PS.Style_Config.Col.PG.Main_TitleText = Color(255, 220, 0, 255)
PS.Style_Config.Col.CC = {}
PS.Style_Config.Col.CC.Main_Outline = Color(255, 150, 0, 255)
PS.Style_Config.Col.PI = {}
PS.Style_Config.Col.PI.Main_TitleText = Color(255, 150, 0, 255)
PS.Style_Config.Col.PI.Main_Text = Color(255, 255, 0, 255)

PS.SetupColorStyle("orange", "Orange")

PS.Style_Config.Col.PV = {}
PS.Style_Config.Col.PV.FootRing = Color(0, 255, 0, 255)
PS.Style_Config.Col.PV.BurstRing = Color(150, 255, 0, 255)
PS.Style_Config.Col.PV.Zoom = Color(50, 255, 0, 255)
PS.Style_Config.Col.PV.ZoomBar = Color(125, 255, 0, 255)
PS.Style_Config.Col.PV.Height = Color(50, 255, 0, 255)
PS.Style_Config.Col.PV.HeightBar = Color(125, 255, 0, 255)
PS.Style_Config.Col.IC = {}
PS.Style_Config.Col.IC.BackGround = Color(50, 255, 0, 5)
PS.Style_Config.Col.MN = {}
PS.Style_Config.Col.MN.PointShopText = Color(0, 255, 0, 255)
PS.Style_Config.Col.MN.BottomLine = Color(0, 255, 0, 255)
PS.Style_Config.Col.MN.DSWBoarderCol = Color(0, 255, 0, 255)
PS.Style_Config.Col.MN.DSWTextCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.DSWClickFX = Color(0, 255, 0, 255)
PS.Style_Config.Col.MN.SCBarOutLine = Color(0, 255, 0, 255)
PS.Style_Config.Col.SP = {}
PS.Style_Config.Col.SP.ShopTitle = Color(0, 255, 0, 255)
PS.Style_Config.Col.SP.MyPoints = Color(120, 255, 0, 255)
PS.Style_Config.Col.SP.FilterTitleText = Color(0, 200, 0, 255)
PS.Style_Config.Col.SP.ListItemName = Color(0, 255, 0, 255)
PS.Style_Config.Col.SP.ListItemPrice = Color(170, 200, 0, 255)
PS.Style_Config.Col.SP.ListItemPrice_No = Color(170, 200, 0, 100)
PS.Style_Config.Col.SP.ListBottomLine = Color(0, 255, 0, 20)
PS.Style_Config.Col.SP.ListItemHoverCol = Color(30, 150, 0, 255)
PS.Style_Config.Col.Inv = {}
PS.Style_Config.Col.Inv.InvTitle = Color(0, 255, 0, 255)
PS.Style_Config.Col.Inv.FilterTitleText = Color(0, 200, 0, 255)
PS.Style_Config.Col.Inv.ListItemName = Color(0, 255, 0, 255)
PS.Style_Config.Col.Inv.ListItemRefund = Color(170, 200, 0, 255)
PS.Style_Config.Col.Inv.ListEquippedText = Color(0, 255, 150, 255)
PS.Style_Config.Col.Inv.ListBottomLine = Color(0, 255, 0, 20)
PS.Style_Config.Col.Inv.ListItemHoverCol = Color(30, 150, 0, 255)
PS.Style_Config.Col.AP = {}
PS.Style_Config.Col.AP.TitleText = Color(0, 255, 0, 255)
PS.Style_Config.Col.AP.List_No = Color(0, 255, 0, 255)
PS.Style_Config.Col.AP.List_PlayerNick = Color(0, 200, 0, 255)
PS.Style_Config.Col.AP.List_PlayerPoints = Color(0, 255, 0, 255)
PS.Style_Config.Col.AP.List_PlayerItems = Color(0, 255, 0, 255)
PS.Style_Config.Col.AP.ListBottomLine = Color(150, 255, 0, 50)
PS.Style_Config.Col.PG = {}
PS.Style_Config.Col.PG.Main_Outline = Color(0, 255, 0, 255)
PS.Style_Config.Col.PG.Main_TitleText = Color(220, 255, 0, 255)
PS.Style_Config.Col.CC = {}
PS.Style_Config.Col.CC.Main_Outline = Color(120, 255, 0, 255)
PS.Style_Config.Col.PI = {}
PS.Style_Config.Col.PI.Main_TitleText = Color(120, 255, 0, 255)
PS.Style_Config.Col.PI.Main_Text = Color(0, 255, 0, 255)

PS.SetupColorStyle("green", "Grün")

PS.Style_Config.Col.PV = {}
PS.Style_Config.Col.PV.FootRing = Color(255, 255, 255, 255)
PS.Style_Config.Col.PV.BurstRing = Color(206, 206, 242, 255)
PS.Style_Config.Col.PV.Zoom = Color(255, 255, 255, 255)
PS.Style_Config.Col.PV.ZoomBar = Color(255, 255, 255, 255)
PS.Style_Config.Col.PV.Height = Color(255, 255, 255, 255)
PS.Style_Config.Col.PV.HeightBar = Color(255, 255, 255, 255)
PS.Style_Config.Col.IC = {}
PS.Style_Config.Col.IC.BackGround = Color(255, 50, 0, 5)
PS.Style_Config.Col.MN = {}
PS.Style_Config.Col.MN.PointShopText = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.BottomLine = Color(235, 235, 230, 255)
PS.Style_Config.Col.MN.DSWBoarderCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.DSWTextCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.DSWClickFX = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.SCBarOutLine = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP = {}
PS.Style_Config.Col.SP.ShopTitle = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.MyPoints = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.FilterTitleText = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.ListItemName = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.ListItemPrice = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.ListItemPrice_No = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.ListBottomLine = Color(255, 255, 255, 255)
PS.Style_Config.Col.SP.ListItemHoverCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv = {}
PS.Style_Config.Col.Inv.InvTitle = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv.FilterTitleText = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv.ListItemName = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv.ListItemRefund = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv.ListEquippedText = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv.ListBottomLine = Color(255, 255, 255, 255)
PS.Style_Config.Col.Inv.ListItemHoverCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.AP = {}
PS.Style_Config.Col.AP.TitleText = Color(255, 255, 255, 255)
PS.Style_Config.Col.AP.List_No = Color(255, 255, 255, 255)
PS.Style_Config.Col.AP.List_PlayerNick = Color(255, 255, 255, 255)
PS.Style_Config.Col.AP.List_PlayerPoints = Color(255, 255, 255, 255)
PS.Style_Config.Col.AP.List_PlayerItems = Color(255, 255, 255, 255)
PS.Style_Config.Col.AP.ListBottomLine = Color(255, 255, 255, 255)
PS.Style_Config.Col.PG = {}
PS.Style_Config.Col.PG.Main_Outline = Color(255, 255, 255, 255)
PS.Style_Config.Col.PG.Main_TitleText = Color(255, 255, 255, 255)
PS.Style_Config.Col.CC = {}
PS.Style_Config.Col.CC.Main_Outline = Color(255, 255, 255, 255)
PS.Style_Config.Col.PI = {}
PS.Style_Config.Col.PI.Main_TitleText = Color(255, 255, 255, 255)
PS.Style_Config.Col.PI.Main_Text = Color(255, 255, 255, 255)

PS.SetupColorStyle("white", "Weiß")

PS.Style_Config.Col.PV = {}
PS.Style_Config.Col.PV.FootRing = Color(210, 80, 80, 255)
PS.Style_Config.Col.PV.BurstRing = Color(255, 150, 150, 255)
PS.Style_Config.Col.PV.Zoom = Color(230, 115, 115, 255)
PS.Style_Config.Col.PV.ZoomBar = Color(230, 115, 115, 255)
PS.Style_Config.Col.PV.Height = Color(230, 115, 115, 255)
PS.Style_Config.Col.PV.HeightBar = Color(230, 115, 115, 255)
PS.Style_Config.Col.IC = {}
PS.Style_Config.Col.IC.BackGround = Color(255, 50, 0, 5)
PS.Style_Config.Col.MN = {}
PS.Style_Config.Col.MN.PointShopText = Color(230, 90, 90, 255)
PS.Style_Config.Col.MN.BottomLine = Color(250, 95, 95, 255)
PS.Style_Config.Col.MN.DSWBoarderCol = Color(250, 95, 95, 255)
PS.Style_Config.Col.MN.DSWTextCol = Color(255, 255, 255, 255)
PS.Style_Config.Col.MN.DSWClickFX = Color(250, 95, 95, 255)
PS.Style_Config.Col.MN.SCBarOutLine = Color(250, 95, 95, 255)
PS.Style_Config.Col.SP = {}
PS.Style_Config.Col.SP.ShopTitle = Color(230, 90, 90, 255)
PS.Style_Config.Col.SP.MyPoints = Color(230, 90, 90, 255)
PS.Style_Config.Col.SP.FilterTitleText = Color(230, 90, 90, 255)
PS.Style_Config.Col.SP.ListItemName = Color(250, 110, 110, 255)
PS.Style_Config.Col.SP.ListItemPrice = Color(250, 110, 110, 255)
PS.Style_Config.Col.SP.ListItemPrice_No = Color(250, 110, 110, 255)
PS.Style_Config.Col.SP.ListBottomLine = Color(250, 95, 95, 255)
PS.Style_Config.Col.SP.ListItemHoverCol = Color(200, 75, 75, 255)
PS.Style_Config.Col.Inv = {}
PS.Style_Config.Col.Inv.InvTitle = Color(230, 90, 90, 255)
PS.Style_Config.Col.Inv.FilterTitleText = Color(230, 90, 90, 255)
PS.Style_Config.Col.Inv.ListItemName = Color(250, 110, 110, 255)
PS.Style_Config.Col.Inv.ListItemRefund = Color(250, 110, 110, 255)
PS.Style_Config.Col.Inv.ListEquippedText = Color(250, 110, 110, 255)
PS.Style_Config.Col.Inv.ListBottomLine = Color(250, 95, 95, 255)
PS.Style_Config.Col.Inv.ListItemHoverCol = Color(200, 75, 75, 255)
PS.Style_Config.Col.AP = {}
PS.Style_Config.Col.AP.TitleText = Color(230, 90, 90, 255)
PS.Style_Config.Col.AP.List_No = Color(250, 110, 110, 255)
PS.Style_Config.Col.AP.List_PlayerNick = Color(250, 110, 110, 255)
PS.Style_Config.Col.AP.List_PlayerPoints = Color(250, 110, 110, 255)
PS.Style_Config.Col.AP.List_PlayerItems = Color(250, 110, 110, 255)
PS.Style_Config.Col.AP.ListBottomLine = Color(250, 95, 95, 255)
PS.Style_Config.Col.PG = {}
PS.Style_Config.Col.PG.Main_Outline = Color(250, 95, 95, 255)
PS.Style_Config.Col.PG.Main_TitleText = Color(230, 90, 90, 255)
PS.Style_Config.Col.CC = {}
PS.Style_Config.Col.CC.Main_Outline = Color(250, 95, 95, 255)
PS.Style_Config.Col.PI = {}
PS.Style_Config.Col.PI.Main_TitleText = Color(245, 80, 80, 255)
PS.Style_Config.Col.PI.Main_Text = Color(245, 80, 80, 255)

PS.SetupColorStyle("rose", "Rosa")

PS.Style_Config.BGCol.MainTitle = Color(40, 40, 40, 255)
PS.Style_Config.BGCol.Preview = Color(10, 10, 10, 255)
PS.Style_Config.BGCol.DSWButton = Color(0, 0, 0, 0)
PS.Style_Config.BGCol.ShopCanvasBG = Color(20, 20, 20, 255)
PS.Style_Config.BGCol.ShopLeftCanvasBG = Color(30, 30, 30, 255)
PS.Style_Config.BGCol.ShopTitleBG = Color(50, 50, 50, 255)
PS.Style_Config.BGCol.ShopFilterLister = Color(10, 10, 10, 255)
PS.Style_Config.BGCol.ShopItemsLister = Color(10, 10, 10, 255)
PS.Style_Config.BGCol.InvCanvasBG = Color(20, 20, 20, 255)
PS.Style_Config.BGCol.InvLeftCanvasBG = Color(30, 30, 30, 255)
PS.Style_Config.BGCol.InvTitleBG = Color(50, 50, 50, 255)
PS.Style_Config.BGCol.InvFilterLister = Color(10, 10, 10, 255)
PS.Style_Config.BGCol.InvItemsLister = Color(10, 10, 10, 255)
PS.Style_Config.BGCol.AP_CanvasBG = Color(30, 30, 30, 255)
PS.Style_Config.BGCol.GP_TitleBG = Color(40, 40, 40, 255)
PS.Style_Config.BGCol.GP_BodyBG = Color(20, 20, 20, 255)
PS.Style_Config.BGCol.CC_Canvas = Color(20, 20, 20, 255)

PS.SetupBGColorStyle("black", "Schwarz")

timer.Simple(0, function()
	PS.LoadColorTable(GetConVar("shop_style"):GetString() or PS.Style_Config.UseDefaultColor)
	PS.LoadBGColorTable(GetConVar("shop_bgstyle"):GetString() or PS.Style_Config.UseDefaultBGColor)
end)