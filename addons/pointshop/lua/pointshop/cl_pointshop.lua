PS.ShopMenu = PS.ShopMenu
PS.ClientsideModels = PS.ClientsideModels or {}
PS.HoverModel = PS.HoverModel
PS.HoverModelCModel = PS.HoverModelCModel
PS.Ragdolls = PS.Ragdolls or {}

function PS:CloseAllExtraMenus()
	if IsValid(PS_GiveMenuPanel) then
		PS_GiveMenuPanel:Remove()
	end
	if IsValid(PS_ColorPanel) then
		PS_ColorPanel:Remove()
	end
	if IsValid(PS_SkinPanel) then
		PS_SkinPanel:Remove()
	end
	if IsValid(PS_MatPanel) then
		PS_MatPanel:Remove()
	end
	if IsValid(PS_DesignPanel) then
		PS_DesignPanel:Remove()
	end
	CloseDermaMenus()
end

function PS:ToggleMenu()
	PS:CloseAllExtraMenus()
	local shop_menu = PS.ShopMenu
	if !IsValid(shop_menu) then
		PS.ShopMenu = vgui.Create("DPointShopMenu")
		shop_menu = PS.ShopMenu
		shop_menu:MakePopup()
		PS.IntroShop(shop_menu, true)
		hook.Run("PS_OnToggleMenu", self, true)
	elseif shop_menu:IsVisible() then
		shop_menu:SetVisible(false)
		hook.Run("PS_OnToggleMenu", self, false)
	else
		shop_menu:SetVisible(true)
		PS.IntroShop(shop_menu, false)
		hook.Run("PS_OnToggleMenu", self, true)
	end
end

function PS:CloseMenu()
	PS:CloseAllExtraMenus()
	if IsValid(PS.ShopMenu) then
		PS.ShopMenu:Remove()
	end
	hook.Run("PS_OnCloseMenu", self)
end

local PS_InfoPanel
function PS:ShowNotice(text)
	if IsValid(PS_InfoPanel) then PS_InfoPanel:Remove() end	
	PS_InfoPanel = vgui.Create("DPanel", PS.ShopMenu)
	PS_InfoPanel:SetSize(ScrW(), ScrH())
	PS_InfoPanel:MakePopup()
	PS_InfoPanel.Paint = function(slf, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText(text, "PS_TrebOut_S35", ScrW() / 2, ScrH() / 2 - 100, color_white, TEXT_ALIGN_CENTER)
	end
	PS_InfoPanel.Think = function(slf)
	end
	local Button_Okay = vgui.Create("PS_DSWButton", PS_InfoPanel)
	Button_Okay:SetPos(PS_InfoPanel:GetWide() / 2 - 100, PS_InfoPanel:GetTall() / 3 * 2 - 100)
	Button_Okay:SetSize(200, 30)
	Button_Okay.Font = "PS_TrebOut_S25"
	Button_Okay:SetTexts("In Ordnung")
	Button_Okay.Click = function(slf)
		PS_InfoPanel:Remove()
	end
end

local PS_AskPanel
function PS:ShowAsker(txt, callback, denycallback)
	if IsValid(PS_AskPanel) then PS_AskPanel:Remove() end	
	PS_AskPanel = vgui.Create("DPanel", PS.ShopMenu)
	PS_AskPanel:SetSize(ScrW(), ScrH())
	PS_AskPanel:MakePopup()
	PS_AskPanel.Paint = function(self)
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		draw.SimpleText(txt, "PS_TrebOut_S35", ScrW() / 2, ScrH() / 2  - 100, color_white, TEXT_ALIGN_CENTER)
	end
	local Button_Accept = vgui.Create("PS_DSWButton", PS_AskPanel)
	Button_Accept:SetPos(PS_AskPanel:GetWide() / 2 - 220, PS_AskPanel:GetTall() / 3 * 2 - 100)
	Button_Accept:SetSize(200, 30)
	Button_Accept.Font = "PS_TrebOut_S25"
	Button_Accept:SetTexts("Ja")
	Button_Accept.Click = function()
		PS_AskPanel:Remove()
		if callback then
			callback()
		end
	end
	local Button_Decline = vgui.Create("PS_DSWButton", PS_AskPanel)
	Button_Decline:SetPos(PS_AskPanel:GetWide() / 2 + 20, PS_AskPanel:GetTall() / 3 * 2 - 100)
	Button_Decline:SetSize(200, 30)
	Button_Decline.Font = "PS_TrebOut_S25"
	Button_Decline:SetTexts("Nein")
	Button_Decline.Click = function()
		PS_AskPanel:Remove()
		if denycallback then
			denycallback()
		end
	end
end

local PS_AskPanel
function PS:ShowSearch(txt, callback, denycallback, alphabetic, value)
	if IsValid(PS_AskPanel) then PS_AskPanel:Remove() end	
	PS_AskPanel = vgui.Create("DFrame", PS.ShopMenu)
	PS_AskPanel:SetSize(ScrW(), ScrH())
	PS_AskPanel:SetTitle("")
	PS_AskPanel:ShowCloseButton(false)
	PS_AskPanel:SetDraggable(false)
	PS_AskPanel:MakePopup()
	PS_AskPanel.Paint = function(self, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 200))
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText(txt, "PS_TrebOut_S35", ScrW() / 2, ScrH() / 2  - 150, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
	local TextEntry = vgui.Create("DTextEntry", PS_AskPanel)
	TextEntry:SetPos(PS_AskPanel:GetWide() / 2 - 220, PS_AskPanel:GetTall() / 3 * 2 - 180)
	TextEntry:SetSize(440, 30)
	TextEntry:SetFont("PS_Treb_S25")
	if !alphabetic then 
		TextEntry:SetNumeric(true)
	end
	TextEntry:SetValue(value or "")
	TextEntry:RequestFocus()
	local Button_Accept = vgui.Create("PS_DSWButton", PS_AskPanel)
	Button_Accept:SetPos(PS_AskPanel:GetWide() / 2 - 220, PS_AskPanel:GetTall() / 3 * 2 - 100)
	Button_Accept:SetSize(200, 30)
	Button_Accept.Font = "PS_TrebOut_S25"
	Button_Accept:SetTexts("Bestätigen")
	Button_Accept.Click = function()
		PS_AskPanel:Remove()
		if callback then
			callback(TextEntry:GetValue())
		end
	end
	local Button_Decline = vgui.Create("PS_DSWButton", PS_AskPanel)
	Button_Decline:SetPos(PS_AskPanel:GetWide() / 2 + 20, PS_AskPanel:GetTall() / 3 * 2 - 100)
	Button_Decline:SetSize(200, 30)
	Button_Decline.Font = "PS_TrebOut_S25"
	Button_Decline:SetTexts("Abbrechen")
	Button_Decline.Click = function()
		PS_AskPanel:Remove()
		if denycallback then
			denycallback(TextEntry:GetValue())
		end
	end
end

local key_to_press = PS.Config.ShopKey
local key_down = false
local function OpenShop()
	if input.IsKeyDown(key_to_press) then
		if key_down then return end
		key_down = true
		PS:ToggleMenu()
	else
		key_down = false
	end
end
hook.Add("Think", "PS_OpenShop", OpenShop)

function PS:SetHoverItem(item_id)
	local ITEM = PS.Items[item_id]
	local model = ITEM.Model
	if model then
		self.HoverModel = item_id
		self.HoverModelCModel = ClientsideModel(model, ITEM.RenderGroup or RENDERGROUP_OPAQUE)
		if !IsValid(self.HoverModelCModel) then return end
		self.HoverModelCModel:SetNoDraw(true)
	end
end

function PS:RemoveHoverItem()
	self.HoverModel = nil
	if IsValid(self.HoverModelCModel) then
		self.HoverModelCModel:Remove()
	end
	self.HoverModelCModel = nil
end

function PS:ShowColorChooser(item, modifications)
	local chooser = vgui.Create("DPointShopColorChooser")
	chooser:SetColor(modifications.color)
	chooser.OnChoose = function(color)
		modifications.color = color
		self:SendModifications(item.ID, modifications)
	end
end

function PS:ShowSkinChooser(item, modifications)
	local chooser = vgui.Create("DPointShopSkinChooser")
	chooser:SetModel(item.Model)
	if modifications.skin then
		chooser:SetSkin(modifications.skin)
	end
	if modifications.bodygroups then
		for k,v in pairs(modifications.bodygroups) do
			chooser:SetBodygroup(k, v)
		end
	end
	chooser.OnChoose = function(bodygroups, skin)
		modifications.skin = skin
		modifications.bodygroups = bodygroups
		self:SendModifications(item.ID, modifications)
	end
end

local default_materials = {
	"models/wireframe",
	"debug/env_cubemap_model",
	"models/shadertest/shader3",
	"models/shadertest/shader4",
	"models/shadertest/shader5",
	"models/debug/debugwhite",
	"models/props_combine/stasisshield_sheet",
	"models/props_combine/portalball001_sheet",
	"models/props_combine/com_shield001a",
	"models/props_c17/frostedglass_01a",
	"models/props_lab/tank_glass001",
	"models/props_combine/tprings_globe",
	"models/rendertarget",
	"models/screenspace",
	"brick/brick_model",
	"models/props_pipes/guttermetal01a",
	"models/props_pipes/pipesystem01a_skin3",
	"models/props_wasteland/wood_fence01a",
	"models/props_foliage/tree_deciduous_01a_trunk",
	"models/props_c17/furniturefabric003a",
	"models/props_c17/furnituremetal001a",
	"models/props_c17/paper01",
	"models/flesh",
	"phoenix_storms/metalset_1-2",
	"phoenix_storms/metalfloor_2-3",
	"phoenix_storms/plastic",
	"phoenix_storms/wood",
	"phoenix_storms/bluemetal",
	"phoenix_storms/cube",
	"phoenix_storms/dome",
	"phoenix_storms/gear",
	"phoenix_storms/stripes",
	"phoenix_storms/wire/pcb_green",
	"phoenix_storms/wire/pcb_red",
	"phoenix_storms/wire/pcb_blue",
	"hunter/myplastic",
	"models/xqm/lightlinesred_tool",
	"models/dav0r/hoverball",
	"models/combine_scanner/scanner_eye",
	"models/combine_citadel/combine_citadel001",
	"models/effects/vol_lightmask02",
	"models/props_lab/warp_sheet",
	"models/props_lab/xencrystal_sheet",
	"models/props_pipes/pipemetal001a",
	"models/worldcraft/axis_helper/axis_helper",
	"phoenix_storms/checkers_map",
	"phoenix_storms/pack2/interior_sides",
	"phoenix_storms/wood_side"
}

local randommat = CreateClientConVar("ps_rnd_mat", 0, FCVAR_ARCHIVE)

function PS:ShowMatChooser(item, modifications, mats)
	local chooser = vgui.Create("DPointShopMatChooser")
	if istable(modifications.material) then
		modifications.material = ""
	end
	chooser:SetMaterials(mats or default_materials)
	chooser:SetMaterial(modifications.material or "")
	chooser.OnChoose = function(material)
		if GetConVar("ps_rnd_mat"):GetBool() then
			modifications.material = default_materials
		else
			modifications.material = material
		end
		self:SendModifications(item.ID, modifications)
	end
end

function PS:SendModifications(item_id, modifications)
	net.Start("PS_ModifyItem")
		net.WriteString(item_id)
		net.WriteTable(modifications)
	net.SendToServer()
end

net.Receive("PS_ToggleMenu", function(len)
	PS:ToggleMenu()
end)

net.Receive("PS_SendItems", function(len)
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	local leng = net.ReadUInt(16)
	local items = net.ReadData(leng)
	items = util.JSONToTable(util.Decompress(items))
	ply.PS_Items = PS:ValidateItems(items)
	hook.Run("PS_ItemsAdjusted")
end)

net.Receive("PS_SendPoints", function(len)
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	local points = net.ReadUInt(32)
	ply.PS_Points = PS:ValidatePoints(points)
	hook.Run("PS_PointsAdjusted")
end)

net.Receive("PS_NetworkItems", function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	local leng = net.ReadUInt(16)
	local items = net.ReadData(leng)
	items = util.JSONToTable(util.Decompress(items))
	ply.PS_Items = PS:ValidateItems(items)
	if ply == LocalPlayer() then
		hook.Run("PS_ItemsAdjusted")
	end
end)

net.Receive("PS_NetworkPoints", function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	local points = net.ReadUInt(32)
	ply.PS_Points = PS:ValidatePoints(points)
	if ply == LocalPlayer() then
		hook.Run("PS_PointsAdjusted")
	end
end)

net.Receive("PS_SendClientsideModel", function(len)
	local ply = LocalPlayer()
	if !IsValid(ply) then return end
	local item_id = net.ReadString()
	ply:PS_AddClientsideModel(item_id)
end)

net.Receive("PS_AddClientsideModel", function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	local item_id = net.ReadString()
	ply:PS_AddClientsideModel(item_id)
end)

net.Receive("PS_RemoveClientsideModel", function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	local item_id = net.ReadString()
	ply:PS_RemoveClientsideModel(item_id)
end)

net.Receive("PS_SendClientsideModels", function(len)
	local itms = net.ReadTable()
	for ply, items in pairs(itms) do
		if !IsValid(ply) then continue end
		for _, item_id in pairs(items) do
			if PS.Items[item_id] then
				ply:PS_AddClientsideModel(item_id)
			end
		end
	end
end)

net.Receive("PS_SendPlayerClientsideModels", function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	local items = net.ReadTable()
	ply:PS_RemoveAllClientsideModels()
	for _, item_id in pairs(items) do
		if PS.Items[item_id] then
			ply:PS_AddClientsideModel(item_id)
		end
	end
end)

net.Receive("PS_SendNotification", function(len)
	local str = net.ReadString()
	notification.AddLegacy(str, NOTIFY_GENERIC, 5)
	print(str)
end)

net.Receive("PS_SendNotice", function(len)
	local str = net.ReadString()
	PS:ShowNotice(str)
end)

local reg = debug.getregistry()

local LookupAttachment = reg.Entity.LookupAttachment
local GetAttachment = reg.Entity.GetAttachment

local LookupBone = reg.Entity.LookupBone
local GetBoneMatrix = reg.Entity.GetBoneMatrix
local GetBonePosition = reg.Entity.GetBonePosition

local GetTranslation = reg.VMatrix.GetTranslation
local GetAngles = reg.VMatrix.GetAngles

local SetPos = reg.Entity.SetPos
local SetAngles = reg.Entity.SetAngles
local SetupBones = reg.Entity.SetupBones
local DrawModel = reg.Entity.DrawModel

local function PostPlayerDraw(ply)
	if ply.IsGhost and ply:IsGhost() then return end
	local cl_models = PS.ClientsideModels[ply]
	if !cl_models or ply:GetNoDraw() then return end
	for item_id, model in pairs(cl_models) do
		if !model:IsValid() then continue end
		local ITEM = PS.Items[item_id]
		if ITEM.CanBeShowen and !ITEM:CanBeShowen(ply) then continue  end
		local item_attachment = ITEM.Attachment
		local item_bone = ITEM.Bone
		if !item_attachment and !item_bone then
			PS.ClientsideModels[ply][item_id] = nil
			continue
		end
		local pos, ang
		if item_attachment then
			local attach_id = LookupAttachment(ply, item_attachment)
			if !attach_id then continue end
			local attach = GetAttachment(ply, attach_id)
			if !attach then continue end
			pos = attach.Pos
			ang = attach.Ang
		else
			local bone_id = LookupBone(ply, item_bone)
			if !bone_id then continue end
			local matrix = GetBoneMatrix(ply, bone_id)
			if matrix then
				pos = GetTranslation(matrix)
				ang = GetAngles(matrix)
			else
				pos, ang = GetBonePosition(ply, bone_id)
			end
		end
		if !pos and !ang then continue end
		
		model, pos, ang = ITEM:ModifyClientsideModel(ply, model, pos, ang)
		SetPos(model, pos)
		SetAngles(model, ang)
		SetupBones(model)
		DrawModel(model)
		ITEM:PostModifyClientsideModel(ply, model, pos, ang)
	end
end
hook.Add("PostPlayerDraw", "PS_PostPlayerDraw", PostPlayerDraw)

hook.Add("NetworkEntityCreated", "PS_NetworkEntityCreated", function(ent)
	local class = ent:GetClass()
	if CORPSE then
		if class == "prop_ragdoll" then
			PS.Ragdolls[ent] = true
		end
	elseif class == "class C_HL2MPRagdoll" then
		PS.Ragdolls[ent] = true
	end
end)

local function CreateProceduralEntity(ent, tb, ITEM)
	local model = tb.PS_Models[ITEM.Model]
	if IsValid(model) then return model end
	local model = ClientsideModel(ITEM.Model, ITEM.RenderGroup or RENDERGROUP_OPAQUE)
	if IsValid(model) then
		model:SetNoDraw(true)
		ent:CallOnRemove(tostring(model:EntIndex()), function()
			if IsValid(model) then
				model:Remove()
			end
		end)
		tb.PS_Models[ITEM.ID] = model
	end
	return model
end

local local_ply
hook.Add("PostDrawOpaqueRenderables", "PS_PostDrawOpaqueRenderables", function(depth, sky)
	local_ply = local_ply or LocalPlayer()
	for ent in pairs(PS.Ragdolls) do
		if !IsValid(ent) then
			PS.Ragdolls[ent] = nil
			continue
		end
		if local_ply:GetObserverTarget() == ent and local_ply:GetObserverMode() == OBS_MODE_IN_EYE then
			continue
		end
		if ent:IsDormant() or ent:GetNoDraw() or ent:GetPos():DistToSqr(local_ply:EyePos()) > 1000000 then
			continue
		end
		local owner = ent:GetClass() == "prop_ragdoll" and ent:GetDTEntity(0) or ent:GetRagdollOwner()
		if owner:IsValid() and owner:IsPlayer() then
			local tb = ent:GetTable()
			tb.PS_Models = tb.PS_Models or (PS.ClientsideModels[owner] and table.Copy(PS.ClientsideModels[owner]))
			local cl_models = tb.PS_Models
			if !cl_models then return end
			for item_id, model in pairs(cl_models) do
				local ITEM = PS.Items[item_id]
				if ITEM.CanBeShowen and !ITEM:CanBeShowen(ply) then continue end
				if !IsValid(model) then
					model = CreateProceduralEntity(ent, tb, ITEM)
					if !IsValid(model) then continue end
				end
				local item_attachment = ITEM.Attachment
				local item_bone = ITEM.Bone
				if !item_attachment and !item_bone then
					continue
				end
				local pos, ang
				if item_attachment then
					local attach_id = LookupAttachment(ent, item_attachment)
					if !attach_id then continue end
					local attach = GetAttachment(ent, attach_id)
					if !attach then continue end
					pos = attach.Pos
					ang = attach.Ang
				else
					local bone_id = LookupBone(ent, item_bone)
					if !bone_id then continue end
					local matrix = GetBoneMatrix(ent, bone_id)
					if matrix then
						pos = GetTranslation(matrix)
						ang = GetAngles(matrix)
					else
						pos, ang = GetBonePosition(ent, bone_id)
					end
				end
				if !pos and !ang then continue end
				model, pos, ang = ITEM:ModifyClientsideModel(ent, model, pos, ang)
				model:SetPos(pos)
				model:SetAngles(ang)
				model:SetupBones()
				model:DrawModel()
				ITEM:PostModifyClientsideModel(ent, model, pos, ang)
			end
		end
	end
end)