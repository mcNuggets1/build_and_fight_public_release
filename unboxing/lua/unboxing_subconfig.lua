UnboxItems = {}
UnboxConfig = {}

local count = 1
function Unbox_AddExtraKey(ItemName, KeyAmount, ItemChance, ItemColor)
	UnboxItems[count] = {}
	UnboxItems[count].ItemName = ItemName
	UnboxItems[count].Type = "KEY"
	UnboxItems[count].KeyAmount = KeyAmount
	UnboxItems[count].ItemChance = ItemChance
	UnboxItems[count].ItemColor = ItemColor
	count = count + 1
end

function Unbox_AddExperience(ItemName, XPAmount, ItemChance, ItemColor)
	UnboxItems[count] = {}
	UnboxItems[count].ItemName = ItemName
	UnboxItems[count].Type = "XP"
	UnboxItems[count].XPAmount = XPAmount
	UnboxItems[count].ItemChance = ItemChance
	UnboxItems[count].ItemColor = ItemColor
	count = count + 1
end

function Unbox_AddPointShopPoints(ItemName, PointAmount, ItemChance, ItemColor)
	UnboxItems[count] = {}
	UnboxItems[count].ItemName = ItemName
	UnboxItems[count].Type = "POINTS"
	UnboxItems[count].Points = PointAmount
	UnboxItems[count].ItemChance = ItemChance
	UnboxItems[count].ItemColor = ItemColor
	count = count + 1
end

function Unbox_AddPointShopItem(ItemName, ItemClassName, ItemUseModel, ItemModel, ItemCategory, ItemPrice, ItemColor, ItemChance)
	UnboxItems[count] = {}
	UnboxItems[count].ItemName = ItemName
	UnboxItems[count].Type = "PITEM"
	UnboxItems[count].ItemClassName = ItemClassName
	UnboxItems[count].ItemUseModel = ItemUseModel
	if UnboxItems[count].ItemUseModel then
		UnboxItems[count].ItemModel = ItemModel
	elseif !UnboxItems[count].ItemUseModel then
		UnboxItems[count].ItemMateral = ItemModel
	else
		UnboxItems[count].ItemMateral = "materials/unboxing/trail.png"
	end
	UnboxItems[count].ItemCategory = ItemCategory
	UnboxItems[count].ItemPrice = ItemPrice
	UnboxItems[count].ItemChance = ItemChance
	UnboxItems[count].ItemColor = ItemColor
	count = count + 1
end