PS = PS or {}
PS.__index = PS

PS.Items = PS.Items or {}
PS.Categories = PS.Categories or {}
PS.ClientsideModels = PS.ClientsideModels or {}

function PS:ValidateItems(items)
	if !istable(items) then
		return {}
	end
	for item_id, item in pairs(items) do
		if !self.Items[item_id] then
			items[item_id] = nil
		end
	end
	return items
end

function PS:ValidatePoints(points)
	if !isnumber(points) then
		return 0
	end
	return points >= 0 and points or 0
end

function PS:FindCategoryByName(cat_name)
	for id, cat in pairs(self.Categories) do
		if cat.Name == cat_name then
			return cat
		end
	end
	return false
end

local time = 0
local query = 0
local empty_func = function() end
local PS_HiddenGroup = nil
function PS:LoadItems()
	if !PS_HiddenGroup then
		PS_HiddenGroup = {}
		for group, _ in pairs(MG_DeveloperGroups) do
			table.insert(PS_HiddenGroup, group)
		end
	end

	time = 0
	local time_a = SysTime()
	local cnt = 0
	print("[PS] Starting to load all shop items...")
	local items_path = SERVER and "addons/" .. PS.Config.ItemFolder .. "/lua/ps_items/" or "ps_items/"
	local items_gamepath = SERVER and "MOD" or "LUA"
	local _, dirs = file.Find(items_path .. "*", items_gamepath)

	for _, category in pairs(dirs) do
		local f, _ = file.Find(items_path..category.."/__category.lua", items_gamepath)
		if #f > 0 then
			CATEGORY = {}
			CATEGORY.Name = ""
			CATEGORY.Order = 0
			CATEGORY.Weapon = false
			CATEGORY.AllowedEquipped = -1
			CATEGORY.AllowedUserGroups = {}
			CATEGORY.CanPlayerSee = function(self, ply)
				return true
			end

			if SERVER then 
				AddCSLuaFile("ps_items/"..category.."/__category.lua")
			end

			include("ps_items/"..category.."/__category.lua")
			if !PS.Categories[category] then
				PS.Categories[category] = CATEGORY
			end

			if CATEGORY.Hidden then
				CATEGORY.AllowedUserGroups = PS_HiddenGroup
				CATEGORY.CanPlayerSee = function(self, ply)
					return MG_DeveloperGroups[ply:GetUserGroup()]
				end
			end

			local files, _ = file.Find(items_path..category.."/*.lua", items_gamepath)
			local cnt2 = 0
			for _, name in pairs(files) do
				if name != "__category.lua" then
					if SERVER then 
						AddCSLuaFile("ps_items/"..category.."/"..name)
					end

					local category_tbl = CATEGORY
					local function AsyncCallback(_, _, status, content)
						local broken = false
						if status != 0 then
							if status == -1 then
								broken = true
							else
								print("[PS Items] Failed to load ps_items/"..category.."/"..name, "Error: " .. status)
								return
							end

							--error("[PS Items] Failed to load ps_items/"..category.."/"..name .. " Error: " .. status .. " Exists: " .. (file.Exists("ps_items/"..category.."/"..name, "LUA") and "Yes" or "No") .. "")
						end

						local time_a = SysTime()
						cnt = cnt + 1
						cnt2 = cnt2 + 1
						ITEM = {}
						ITEM.__index = ITEM
						ITEM.ID = string.gsub(string.lower(name), ".lua", "")
						ITEM.Category = category_tbl.Name
						ITEM.AlowedEquipped = category_tbl.AllowedEquipped
						ITEM.Price = 0
						ITEM.AdminOnly = false
						ITEM.AllowedUserGroups = {}
						ITEM.SingleUse = false
						ITEM.NoPreview = false
						ITEM.CanPlayerBuy = true
						ITEM.CanPlayerSell = true
						ITEM.CanPlayerEquip = true
						ITEM.CanPlayerHolster = true
						ITEM.EquipGroup = "znone"
						ITEM.OnBuy = empty_func
						ITEM.OnSell = empty_func
						ITEM.OnPlayerEquip = empty_func
						ITEM.OnEquip = empty_func
						ITEM.OnPlayerHolster = empty_func
						ITEM.OnHolster = empty_func
						ITEM.OnModify = empty_func
						ITEM.ModifyClientsideModel = function(ITEM, ply, model, pos, ang)
							return model, pos, ang
						end
						ITEM.PostModifyClientsideModel = empty_func //function(ITEM, ply, model, pos, ang) end
							
						if broken then
							include("ps_items/"..category.."/"..name)
						else
							RunString(content, items_path..category.."/"..name)
						end

						if category_tbl.Hidden or ITEM.Hidden then
							ITEM.Hidden = true
							ITEM.AllowedUserGroups = PS_HiddenGroup
							if category_tbl.Hidden_ShowOwners then
								ITEM.Hidden_ShowOwners = true
							end
							-- ITEM.Hidden_ShowOwners = true -- Shows the Item to all Item owners and lets them use it, but for everyone else it's hidden. If the whole Category is hidden, this won't work!
							ITEM.CanPlayerSee = function(self, ply)
								return (self.Hidden_ShowOwners and ply:PS_HasItem(self.ID)) or MG_DeveloperGroups[ply:GetUserGroup()]
							end
						end

						if ITEM.Model == "model" and category_tbl.Weapon and ITEM.WeaponClass then
							local class = weapons.Get(ITEM.WeaponClass)
							ITEM.Model = class and class.WorldModel or "model"
						end

						if !ITEM.Name then
							ErrorNoHalt("[SHOP] Fehlender Item-Name: "..category.."/"..name.."\n")
							return
						elseif !ITEM.Price then
							ErrorNoHalt("[SHOP] Fehlender Item-Preis: "..category.."/"..name.."\n")
							return
						elseif !ITEM.Model and !ITEM.Material then
							ErrorNoHalt("[SHOP] Fehlendes Modell oder Material: "..category.."/"..name.."\n")
							return
						end
			
						if category_tbl.Klasse then
							ITEM.Klasse = category_tbl.Klasse
						end

						if ITEM.Model then
							util.PrecacheModel(ITEM.Model)
						end
						self.Items[ITEM.ID] = ITEM
						ITEM = nil

						category_tbl.ItemCount = cnt2

						time = time + (SysTime() - time_a)
						query = query - 1
					end

					if SERVER or !game.IsDedicated() then -- We check IsDedicated because it will speed up loading clientside when testing.
						file.AsyncRead(items_path..category.."/"..name, items_gamepath, AsyncCallback)
					else
						AsyncCallback(nil, nil, -1, "") -- Solves a weird exploit with Lua Injection. Since legacy addons are also mounted to lcl/LUA.
					end

					query = query + 1
				end
			end
			CATEGORY = nil
		end
	end
	time = time + (SysTime() - time_a)

	hook.Add("Think", "PS_Loading", function()
		if query != 0 then return end

		PS.ItemCount = cnt
		print("[PS] Added "..cnt.." shop items in "..time.."s.")

		if CLIENT then
			net.Start("PS_AskForInformation")
			net.SendToServer()
		end
		hook.Call("PS_LoadItems")
		hook.Remove("Think", "PS_Loading")
	end)
end

function PS:IsCosmetic(item_id)
	local ITEM = PS.Items[item_id]
	return (ITEM.Bone or ITEM.Attachment) and !ITEM.WeaponClass and !ITEM.NoPreview
end

local meta = FindMetaTable("Player")
function meta:PS_GetUsergroup()
	return self:GetUserGroup()
end