local meta = FindMetaTable("Player")
function meta:PS_PlayerSpawn()
	if !self.PS_FirstLoadCompleted or self.ULXExclusive == "spectating" then return end
	timer.Simple(0, function()
		if !IsValid(self) then return end
		if self.IsSpec and self:IsSpec() then return end
		if self.IsGhost and self:IsGhost() then return end
		self:PS_EquipItems()
	end)
end

hook.Add("PS_OnLoadPlayerData", "PS_LoadEquippedItems", function(ply)
	timer.Simple(0, function()
		if !IsValid(ply) then return end
		if ply.IsSpec and ply:IsSpec() then return end
		if ply.IsGhost and ply:IsGhost() then return end
		ply:PS_EquipItems(1)
		hook.Run("PS_OnFirstEquipItems", self)
	end)
	timer.Simple(15, function()
		if !IsValid(self) then return end
		self:PS_Notify("Du hast "..string.Comma(self:PS_GetPoints()).." "..PS.Config.PointsName.."! Drücke "..PS.Config.ShopKeyName..", um den Shop zu öffnen.")
	end)
end)

function meta:PS_PlayerInitialSpawn()
	timer.Simple(0, function()
		if !IsValid(self) then return end
		self:PS_LoadData()
	end)
	if PS.Config.PointsOverTime then
		timer.Create("PS_PointsOverTime_"..self:EntIndex(), PS.Config.PointsOverTimeDelay * 60, 0, function()
			if !IsValid(self) or (self.GetForceSpec and self:GetForceSpec()) or (GetRoundState and GetRoundState() == ROUND_WAIT) then return end
			local money = PS.Config.PointsOverTimeAmount
			if self.MG_AddMoney then
				self:MG_AddMoney(money)
			else
				self:PS_GivePoints(money)
			end
			self:PS_Notify("Du hast ", string.Comma(money), " ", PS.Config.PointsName, " für das Spielen auf dem Server erhalten!")
		end)
	end
end

function meta:PS_EquipItems(delay_cosmetics)
	for item_id, item in pairs(self.PS_Items or {}) do
		local ITEM = PS.Items[item_id]
		if item.Equipped then
			if PS:IsCosmetic(item_id) then
				timer.Simple(delay_cosmetics or 0, function()
					if !IsValid(self) then return end
					if self.IsSpec and self:IsSpec() then return end
					if self.IsGhost and self:IsGhost() then return end
					ITEM:OnEquip(self, item.Modifiers)
				end)
			else
				if ITEM.WeaponClass and noWeapons then continue end
				if ITEM.Klasse and ITEM.Klasse != tbl.class then continue end
				ITEM:OnEquip(self, item.Modifiers)
			end
		end
	end
	hook.Run("PS_OnEquipItems", self)
end

function meta:PS_HolsterItems(death)
	for item_id, item in pairs(self.PS_Items or {}) do
		if item.Equipped then
			local ITEM = PS.Items[item_id]
			if death then
				if PS:IsCosmetic(item_id) then
					continue
				end
			end
			ITEM:OnHolster(self, item.Modifiers)
		end
	end
	hook.Run("PS_OnHolsterItems", self)
end

function meta:PS_DoPlayerDeath()
	self:PS_HolsterItems(true)
end

function meta:PS_PlayerSilentDeath()
	self:PS_HolsterItems(true)
end

function meta:PS_PlayerDisconnected()
	timer.Remove("PS_PointsOverTime_"..self:EntIndex())
	PS.ClientsideModels[self] = nil
	self:PS_Save()
	self:PS_HolsterItems()
end

function meta:PS_Save()
	if !IsValid(self) or !self.PS_FirstLoadCompleted then return end
	PS:SetPlayerData(self, self.PS_Points, self.PS_Items)
	hook.Run("PS_OnSavePlayerData", self, self.PS_Points, self.PS_Items)
end

function meta:PS_LoadData()
	self.PS_Points = 0
	self.PS_Items = {}
	PS:GetPlayerData(self, function(points, items)
		if !IsValid(self) then return end
		self.PS_Points = (tonumber(points) or 0) + self.PS_Points
		local new_items = items
		table.Merge(new_items, self.PS_Items)
		self.PS_Items = new_items
		self.PS_FirstLoadCompleted = true
		if self.PS_QueueForInitialize then
			ply.PS_QueueForInitialize = nil
			ply:PS_SendAll()
		end
		timer.Simple(1, function()
			if !IsValid(self) then return end
			self:PS_NetworkPoints(true)
			self:PS_NetworkItems(true)
		end)
		hook.Run("PS_OnLoadPlayerData", self, self.PS_Points, self.PS_Items)
	end)
end

function meta:PS_GivePoints(points, sender)
	self.PS_Points = self.PS_Points + points
	self:PS_NetworkPoints()
	self:PS_Save()
	hook.Run("PS_OnGivePoints", self, points, sender)
end

function meta:PS_TakePoints(points, admin)
	self.PS_Points = math.max(0, self.PS_Points - points)
	self:PS_NetworkPoints()
	self:PS_Save()
	hook.Run("PS_OnTakePoints", self, points, admin)
end

function meta:PS_SetPoints(points, admin)
	self.PS_Points = points
	self:PS_NetworkPoints()
	self:PS_Save()
	hook.Run("PS_OnSetPoints", self, points, admin)
end

function meta:PS_GetPoints()
	return self.PS_Points or 0
end

function meta:PS_HasPoints(points)
	return self.PS_Points >= points
end

function meta:PS_GiveItem(item_id, admin)
	if !self.PS_FirstLoadCompleted then return false end
	if !PS.Items[item_id] then return false end
	self.PS_Items[item_id] = {Modifiers = {}, Equipped = false}
	self:PS_NetworkItems()
	self:PS_Save()
	hook.Run("PS_OnGiveItem", self, item_id, admin)
	return true
end

function meta:PS_TakeItem(item_id, admin)
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	self.PS_Items[item_id] = nil
	self:PS_NetworkItems()
	self:PS_Save()
	hook.Run("PS_OnTakeItem", self, item_id, admin)
	return true
end

function meta:PS_BuyItem(item_id)
	if !self.PS_FirstLoadCompleted then return false end
	local ITEM = PS.Items[item_id]
	if !ITEM then return false end
	local points = PS.Config.CalculateBuyPrice(self, ITEM)
	if !self:PS_HasPoints(points) then return false end
	if ITEM.AdminOnly and !self:IsAdmin() then
		self:PS_Notice("Dieses Item ist nur für Admins verfügbar!")
		return false
	end
	if ITEM.AllowedUserGroups and #ITEM.AllowedUserGroups > 0 then
		if !table.HasValue(ITEM.AllowedUserGroups, self:PS_GetUsergroup()) then
			self:PS_Notice("Dieses Item ist nur für VIPs!")
			return false
		end
	end
	local cat_name = ITEM.Category
	local CATEGORY = PS:FindCategoryByName(cat_name)
	if CATEGORY.AllowedUserGroups and #CATEGORY.AllowedUserGroups > 0 then
		if !table.HasValue(CATEGORY.AllowedUserGroups, self:PS_GetUsergroup()) then
			self:PS_Notice("Diese Kategorie ist nur für VIPs!")
			return false
		end
	end
	if CATEGORY.CanPlayerSee then
		if !CATEGORY:CanPlayerSee(self) then
			self:PS_Notice("Du hast keine Berechtigung dieses Item zu kaufen!")
			return false
		end
	end
	if ITEM.CanPlayerBuy != nil then
		local allowed, message
		if isfunction(ITEM.CanPlayerBuy) then
			allowed, message = ITEM:CanPlayerBuy(self)
		elseif isbool(ITEM.CanPlayerBuy) then
			allowed = ITEM.CanPlayerBuy
		end
		if !allowed then
			self:PS_Notice("Du hast keine Berechtigung dieses Item zu kaufen!")
			return false
		end
	end
	self:PS_TakePoints(points)
	self:PS_Notify("Du hast ", ITEM.Name, " für ", string.Comma(points), " "..PS.Config.PointsName.." gekauft!")
	ITEM:OnBuy(self)
	hook.Run("PS_OnBuyItem", self, item_id)
	if ITEM.SingleUse then
		timer.Simple(1, function()
			if IsValid(self) then
				self:PS_Notify("Hinweis: Das zuvor gekaufte Item kann nur einmal benutzt werden.")
			end
		end)
		--return -- Don't return. Give the Item :<
	end
	self:PS_GiveItem(item_id)
	self:PS_Save()
	return true
end

function meta:PS_SellItem(item_id)
	if !self.PS_FirstLoadCompleted then return false end
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	local ITEM = PS.Items[item_id]
	if ITEM.CanPlayerSell != nil then
		local allowed, message
		if isfunction(ITEM.CanPlayerSell) then
			allowed, message = ITEM:CanPlayerSell(self)
		elseif isbool(ITEM.CanPlayerSell) then
			allowed = ITEM.CanPlayerSell
		end
		if !allowed then
			self:PS_Notice("Du hast keine Berechtigung dieses Item zu verkaufen!")
			return false
		end
	end
	local points = PS.Config.CalculateSellPrice(self, ITEM)
	self:PS_GivePoints(points)
	self:PS_Save()
	ITEM:OnHolster(self)
	ITEM:OnSell(self)
	self:PS_Notify("Du hast ", ITEM.Name, " für ", string.Comma(points), " "..PS.Config.PointsName.." verkauft!")
	hook.Run("PS_OnSellItem", self, item_id)
	return self:PS_TakeItem(item_id)
end

function meta:PS_HasItem(item_id)
	return self.PS_Items[item_id] or false
end

function meta:PS_HasItemEquipped(item_id)
	if !self:PS_HasItem(item_id) then return false end
	return self.PS_Items[item_id].Equipped or false
end

function meta:PS_NumItemsEquippedFromCategory(cat_name)
	local count = 0
	for item_id, item in pairs(self.PS_Items or {}) do
		local ITEM = PS.Items[item_id]
		if ITEM.Category == cat_name and item.Equipped then
			count = count + (ITEM.Weight or 1)
		end
	end
	return count
end

function meta:PS_NumItemsEquippedFromCustomCategory(cat_name)
	local count = 0
	for item_id, item in pairs(self.PS_Items or {}) do
		local ITEM = PS.Items[item_id]
		if ITEM.EquipGroup != "znone" and ITEM.EquipGroup == cat_name and item.Equipped then
			count = count + (ITEM.Weight or 1)
		end
	end
	return count
end

function meta:PS_EquipItem(item_id)
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	local ITEM = PS.Items[item_id]
	if ITEM.CanPlayerEquip != nil then
		if isfunction(ITEM.CanPlayerEquip) then
			allowed = ITEM:CanPlayerEquip(self)
		elseif isbool(ITEM.CanPlayerEquip) then
			allowed = ITEM.CanPlayerEquip
		end
		if !allowed then return false end
	end
	local cat_name = ITEM.Category
	local CATEGORY = PS:FindCategoryByName(cat_name)
	if CATEGORY and CATEGORY.AllowedEquipped and CATEGORY.AllowedEquipped > -1 then
		if self:PS_NumItemsEquippedFromCategory(cat_name) + (ITEM.Weight or 1) > CATEGORY.AllowedEquipped then
			self:PS_Notice("Du kannst keine weiteren Items dieser Kategorie ausrüsten!")
			return false
		end
	end
	if ITEM.EquipGroup != "znone" and ITEM.MaxEquip and ITEM.MaxEquip > -1 then
		if self:PS_NumItemsEquippedFromCustomCategory(ITEM.EquipGroup) + (ITEM.Weight or 1) > ITEM.MaxEquip then
			self:PS_Notice("Du kannst keine weiteren Items dieser Art ausrüsten!")
			return false
		end
	end
	self.PS_Items[item_id].Equipped = true
	ITEM:OnPlayerEquip(self, self.PS_Items[item_id].Modifiers)
	self:PS_Notify("Du hast ", ITEM.Name, " ausgerüstet.")
	self:PS_NetworkItems()
	self:PS_Save()
	if !PS:IsCosmetic(item_id) then
		if self.IsSpec and self:IsSpec() then return false end
		if self.IsGhost and self:IsGhost() then return false end
	end
	ITEM:OnEquip(self, self.PS_Items[item_id].Modifiers)
	hook.Run("PS_OnEquipItem", self, item_id)
	return true
end

function meta:PS_HolsterItem(item_id)
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	self.PS_Items[item_id].Equipped = false
	local ITEM = PS.Items[item_id]
	if ITEM.CanPlayerHolster != nil then
		if isfunction(ITEM.CanPlayerHolster) then
			allowed = ITEM:CanPlayerHolster(self)
		elseif isbool(ITEM.CanPlayerHolster) then
			allowed = ITEM.CanPlayerHolster
		end
		if !allowed then return false end
	end
	ITEM:OnPlayerHolster(self)
	self:PS_Notify("Du hast ", ITEM.Name, " aus deiner Ausrüstung entfernt.")
	self:PS_NetworkItems()
	self:PS_Save()
	if !PS:IsCosmetic(item_id) then
		if self.IsSpec and self:IsSpec() then return false end
		if self.IsGhost and self:IsGhost() then return false end
	end
	ITEM:OnHolster(self)
	hook.Run("PS_OnHolsterItem", self, item_id)
	return true
end

function meta:PS_ModifyItem(item_id, modifications)
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	if !istable(modifications) then return false end
	for key, value in pairs(modifications) do
		self.PS_Items[item_id].Modifiers[key] = value
	end
	self:PS_NetworkItems()
	self:PS_Save()
	hook.Run("PS_OnModifyItem", self, item_id, modifications)
	if self:PS_HasItemEquipped(item_id) then
		if self.IsSpec and self:IsSpec() then return false end
		if self.IsGhost and self:IsGhost() then return false end
		local ITEM = PS.Items[item_id]
		ITEM:OnModify(self, self.PS_Items[item_id].Modifiers)
	end
	return true
end

function meta:PS_AddClientsideModel(item_id)
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	if !PS.ClientsideModels[self] then
		PS.ClientsideModels[self] = {}
	end
	PS.ClientsideModels[self][item_id] = item_id
	net.Start("PS_AddClientsideModel")
		net.WriteEntity(self)
		net.WriteString(item_id)
	net.SendOmit(self)
	net.Start("PS_SendClientsideModel")
		net.WriteString(item_id)
	net.Send(self)
	hook.Run("PS_OnClientsideModelAdded", self, item_id)
	return true
end

function meta:PS_RemoveClientsideModel(item_id)
	if !PS.Items[item_id] then return false end
	if !self:PS_HasItem(item_id) then return false end
	if !PS.ClientsideModels[self] or !PS.ClientsideModels[self][item_id] then return false end
	net.Start("PS_RemoveClientsideModel")
		net.WriteEntity(self)
		net.WriteString(item_id)
	net.Broadcast()
	PS.ClientsideModels[self][item_id] = nil
	hook.Run("PS_OnClientsideModelRemoved", self, item_id)
	return true
end

function meta:PS_ToggleMenu(show)
	net.Start("PS_ToggleMenu")
	net.Send(self)
	hook.Run("PS_OnNetworkPointShopMenu", self, show)
end

function meta:PS_SendAll()
	self:PS_SendPoints()
	self:PS_SendItems()
	self:PS_SendClientsideModels()
	for _, v in ipairs(player.GetAll()) do
		if !v.PS_FirstLoadCompleted then continue end
		v:PS_NetworkPoints(self)
		v:PS_NetworkItems(self)
	end
end

function meta:PS_SendPoints()
	net.Start("PS_SendPoints")
		net.WriteUInt(self.PS_Points, 32)
	net.Send(self)
	hook.Run("PS_OnSendPoints", self)
end

function meta:PS_SendItems()
	local items = util.Compress(util.TableToJSON(self.PS_Items))
	local leng = items:len()
	net.Start("PS_SendItems")
		net.WriteUInt(leng, 16)
		net.WriteData(items, leng)
	net.Send(self)
	hook.Run("PS_OnSendItems", self)
end

function meta:PS_NetworkPoints(typ)
	net.Start("PS_NetworkPoints")
		net.WriteEntity(self)
		net.WriteUInt(self.PS_Points, 32)
	if IsEntity(typ) then
		net.Send(typ)
	elseif typ == true then
		net.SendOmit(self)
	else
		net.Broadcast()
	end
	hook.Run("PS_OnNetworkPoints", self, typ, self.PS_Points)
end

function meta:PS_NetworkItems(typ)
	local items = util.Compress(util.TableToJSON(self.PS_Items))
	local leng = items:len()
	net.Start("PS_NetworkItems")
		net.WriteEntity(self)
		net.WriteUInt(leng, 16)
		net.WriteData(items, leng)
	if IsEntity(typ) then
		net.Send(typ)
	elseif typ == true then
		net.SendOmit(self)
	else
		net.Broadcast()
	end
	hook.Run("PS_OnNetworkItems", self, typ, self.PS_Items)
end

function meta:PS_SendClientsideModels()
	net.Start("PS_SendClientsideModels")
		net.WriteTable(PS.ClientsideModels)
	net.Send(self)
	hook.Run("PS_OnSendClientsideModels", self, PS.ClientsideModels)
end

function meta:PS_SendPlayerClientsideModels()
	local models = PS.ClientsideModels[self]
	net.Start("PS_SendPlayerClientsideModels")
		net.WriteEntity(self)
		net.WriteTable(models)
	net.Broadcast()
	hook.Run("PS_OnSendPlayerClientsideModels", self, PS.ClientsideModels[self])
end

function meta:PS_Notify(...)
	local str = table.concat({...}, "")
	net.Start("PS_SendNotification")
		net.WriteString(str)
	net.Send(self)
	hook.Run("PS_OnPointShopNotify", self, str)
end

function meta:PS_Notice(...)
	local str = table.concat({...}, "")
	net.Start("PS_SendNotice")
		net.WriteString(str)
	net.Send(self)
	hook.Run("PS_OnPointShopNotice", self, str)
end
