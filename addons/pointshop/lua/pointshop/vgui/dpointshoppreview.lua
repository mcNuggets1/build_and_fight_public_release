local PANEL = {}
function PANEL:Init()
	self.Zoom = 100
	self.MinZoom = 40
	self.MaxZoom = 200
	self.Height = 40
	self.MinHeight = 20
	self.MaxHeight = 80
	self.CamPos = Vector(self.Zoom, 0, self.Height)
	self.ViewPos = Vector(0, 0, self.Height)
	self.CamAngle = Angle(0, 1.3, 0)
	self:SetAnimated(false)
	self.RingBurstDelay = SysTime()
	self.RingBurstCount = 0
	self.ZoomTime = SysTime()
	self.RingBurst = {}
	self:BurstRing()
	self.ZoomTime = SysTime() + 0.3
	self.CamUpTime = SysTime() + 0.3
end

function PANEL:LayoutEntity(ent)
	return false
end

function PANEL:OnMouseWheeled(mc)
	self.ZoomHere = self.ZoomHere or self.Zoom
	self.ZoomHere = self.ZoomHere - mc * 10
	self.ZoomHere = math.min(self.ZoomHere,self.MaxZoom)
	self.ZoomHere = math.max(self.ZoomHere,self.MinZoom)
	self.ZoomTime = SysTime() + 0.6
end

function PANEL:Think()
	if self.RingBurstDelay < SysTime() then
		if self.RingBurstCount == 0 then
			self.RingBurstDelay = SysTime() + 0.4
			self.RingBurstCount = 1
			self:BurstRing()
		elseif self.RingBurstCount == 1 then
			self.RingBurstDelay = SysTime() + 3
			self.RingBurstCount = 0
			self:BurstRing()
		end
	end
	self.ZoomHere = self.ZoomHere or self.Zoom
	self.Zoom = Lerp(RealFrameTime() * 10,self.Zoom,self.ZoomHere)
	if !self:IsHovered() then return end
	if input.IsMouseDown(MOUSE_LEFT) then
		if !self.LM then
			self.LM = true
			local MX,MY = gui.MousePos()
			self.LastMousePos_X = MX
			self.LastMousePos_Y = MY
		else
			local CX,CY = gui.MousePos()
			local DX,DY = self.LastMousePos_X-CX,self.LastMousePos_Y-CY
			if DX > 0.01 or DY > 0.01 then
				self.CamUpTime = SysTime() + 0.6
			end
			self.CamAngle.y = self.CamAngle.y - DX / 150
			self.Height = self.Height - DY / 30
			self.Height = math.min(self.Height,self.MaxHeight)
			self.Height = math.max(self.Height,self.MinHeight)
			self.CamPos = Vector(self.Zoom,0,self.Height)
			self.ViewPos = Vector(0, 0, self.Height)
			self.LastMousePos_X = CX
			self.LastMousePos_Y = CY
		end
	else
		if self.LM then
			self.LM = false
		end
	end
end

function PANEL:BurstRing()
	local ring = {}
	ring.Speed = 50
	ring.LifeTime = 2
	ring.StartSize = 10
	ring.EndSize = 500
	ring.CreatedTime = SysTime()
	table.insert(self.RingBurst,ring)
end

local cirmat = Material("particle/particle_ring_wave_additive")
function PANEL:Paint(w, h)
	self.CamPos = Vector(math.sin(self.CamAngle.y) * self.Zoom, math.cos(self.CamAngle.y) * self.Zoom, self.Height)
	self:SelectModels()
	local ent = self.Entity
	if !IsValid(ent) then return end
	surface.SetDrawColor(PS.Style_Config.BGCol.Preview)
	surface.DrawRect(0, 0, w, h)
	local x, y = self:LocalToScreen(0, 0)
	self:LayoutEntity(ent)
	local w, h = self:GetSize()
	cam.Start3D(self.CamPos, (self.ViewPos - self.CamPos):Angle(), self.fFOV, x, y, w, h, 5, 4096)
	render.SuppressEngineLighting(true)
	render.SetLightingOrigin(ent:GetPos())
	render.ResetModelLighting(self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255)
	render.SetColorModulation(self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255)
	render.SetBlend(math.min(self:GetAlpha() / 255, self.colColor.a / 255))
	for i=0, 6 do
		local col = self.DirectionalLight[i]
		if col then
			render.SetModelLighting(i, col.r / 255, col.g / 255, col.b / 255)
		end
	end
	self:DrawModels()
	render.SetMaterial(cirmat)
	render.DrawQuadEasy(Vector(0, 0, 0), Vector(0.1, 0, 90), 70, 70, PS.Style_Config.Col.PV.FootRing, SysTime() * 60)
	for k, v in pairs(self.RingBurst) do
		local DeltaTime = SysTime() - v.CreatedTime
		local DeltaPercent = DeltaTime/v.LifeTime
		local DeltaPercentREV = 1 - DeltaPercent
		if DeltaPercent <= 1 then
			local Col = PS.Style_Config.Col.PV.BurstRing
			local Size = v.StartSize + (DeltaPercent * (v.EndSize - v.StartSize))
			render.DrawQuadEasy(Vector(0, 0, 0), Vector(0.1, 0, 90), Size, Size, Color(Col.r, Col.g, Col.b, DeltaPercentREV * 255), 0)
		else
			self.RingBurst[k] = nil
		end
	end
	render.SetBlend(1)
	render.SuppressEngineLighting(false)
	cam.End3D()
	self.LastPaint = RealTime()
	local AnimationLerp = RealFrameTime()
	AnimationLerp = AnimationLerp * 5
	local Col1 = PS.Style_Config.Col.PV.Zoom
	local Col2 = PS.Style_Config.Col.PV.ZoomBar
	self.ZoomAlpha = self.ZoomAlpha or 0
	if self.ZoomTime and self.ZoomTime > SysTime() then
		self.ZoomAlpha = Lerp(AnimationLerp, self.ZoomAlpha, 255)
	else
		self.ZoomAlpha = Lerp(AnimationLerp, self.ZoomAlpha, 0)
	end
	if self.ZoomAlpha > 0 then
		draw.SimpleText("Zoom", "PS_TrebOut_S20", w - 60, h / 2 - 140, Color(Col2.r, Col2.g, Col2.b, self.ZoomAlpha), TEXT_ALIGN_CENTER)
		surface.SetDrawColor(Color(Col1.r, Col1.g, Col1.b, self.ZoomAlpha * 0.4))
		surface.DrawRect(w - 60, h / 2 - 120, 1, 240)
		local Percent = (self.Zoom - self.MinZoom) / (self.MaxZoom - self.MinZoom)
		local PosY = h / 2 - 120 + Percent * 230
		surface.SetDrawColor(Color(Col2.r,Col2.g, Col2.b, self.ZoomAlpha * 0.8))
		surface.DrawRect(w - 70, PosY, 20, 10)
	end
	local Col1 = PS.Style_Config.Col.PV.Height
	local Col2 = PS.Style_Config.Col.PV.HeightBar
	self.CamUpAlpha = self.CamUpAlpha or 0
	if self.CamUpTime and self.CamUpTime > SysTime() then
		self.CamUpAlpha = Lerp(AnimationLerp, self.CamUpAlpha, 255)
	else
		self.CamUpAlpha = Lerp(AnimationLerp, self.CamUpAlpha, 0)
	end
	if self.CamUpAlpha > 0 then
		draw.SimpleText("Kamera", "PS_TrebOut_S20", w - 130, h / 2 - 140, Color(Col2.r, Col2.g,Col2.b, self.CamUpAlpha), TEXT_ALIGN_CENTER)
		surface.SetDrawColor(Color(Col1.r, Col1.g, Col1.b, self.CamUpAlpha * 0.4))
		surface.DrawRect(w - 130, h / 2 - 120, 1, 240)
		local Percent = (self.Height - self.MinHeight) / (self.MaxHeight - self.MinHeight)
		local PosY = h / 2 - 120 + Percent * 230
		surface.SetDrawColor(Color(Col2.r, Col2.g, Col2.b, self.CamUpAlpha * 0.8))
		surface.DrawRect(w - 140, PosY, 20, 10)
	end
end

local collected_models = {}

local standard_models = {
	"models/player/leet.mdl",
	"models/player/guerilla.mdl",
	"models/player/arctic.mdl",
	"models/player/phoenix.mdl"
}

local player_model = "models/player.mdl"
local player_skin
local player_bgs

function PANEL:CreateClientModel(ITEM)
	if ITEM.Model then
		if IsValid(collected_models[ITEM.Model]) then
			return collected_models[ITEM.Model]
		end
		local cmodel = ClientsideModel(ITEM.Model, ITEM.RenderGroup or RENDERGROUP_OPAQUE)
		if !IsValid(cmodel) then return end
		cmodel:SetNoDraw(true)
		collected_models[ITEM.Model] = cmodel
		return cmodel
	end
	return false
end

function PANEL:ClearClientModels(collected)
	for k, v in pairs(collected_models) do
		if !collected[k] then
			v:Remove()
			collected_models[k] = nil
		end
	end
end

function PANEL:SelectModels()
	local ply = LocalPlayer()
	local has_pm = false
	local pm_data = {}
	local model = ply:GetModel()
	if model == "models/player.mdl" or !ply:Alive() or (ply.IsGhost and ply:IsGhost()) then
		local ply_items = ply:PS_GetItems()
		for k, v in pairs(ply_items) do
			local ITEM = PS.Items[k]
			if ITEM and ITEM.PlayerModel and ply:PS_HasItemEquipped(k) then
				model = ITEM.Model
				pm_data = v
			end
		end
		if model == "models/player.mdl" then
			if !table.HasValue(standard_models, player_model) then
				player_model = standard_models[math.random(1, #standard_models)]
			end
		else
			player_model = model
		end
		has_pm = false
	else
		has_pm = true
		player_model = model
	end
	if has_pm then
		player_skin = ply:GetSkin()
		player_bgs = {}
		for i=0, ply:GetNumBodyGroups() - 1 do
			table.insert(player_bgs, {bodygroup = i, count = ply:GetBodygroup(i)})
		end
	else
		pm_data = pm_data and pm_data.Modifiers
		if pm_data and pm_data.skin then
			player_skin = pm_data.skin
		else
			player_skin = 0
		end
		player_bgs = {}
		if pm_data and pm_data.bodygroups then
			for k, v in pairs(pm_data.bodygroups) do
				table.insert(player_bgs, {bodygroup = k, count = v})
			end
		end
	end
	local preview = false
	if PS.HoverModel then
		local ITEM = PS.Items[PS.HoverModel]
		if ITEM and !ITEM.Attachment and !ITEM.Bone and !ITEM.WeaponClass and !ITEM.NoPreview then
			preview = true
			self:SetModel("")
			self:SetModel(ITEM.Model)
		end
	end
	if !preview then
		self:SetModel(player_model)
		local ent = self.Entity
		if IsValid(ent) then
			if player_skin then
				ent:SetSkin(player_skin)
			end
			for _, v in ipairs(player_bgs or {}) do
				ent:SetBodygroup(v.bodygroup, v.count)
			end
		end
	end
end

function PANEL:DrawItemModel(item_id, hover_mdl)
	local ply = self.Entity
	if !IsValid(ply) then return false end
	local ITEM = PS.Items[item_id]
	if ITEM.NoPreview or ITEM.WeaponClass then return end
	if ITEM.CanBeShowen and !ITEM:CanBeShowen(ply) then return end
	local item_attachment = ITEM.Attachment
	local item_bone = ITEM.Bone
	if !item_attachment and !item_bone then
		return false
	end
	local model = hover_mdl and PS.HoverModelCModel or !hover_mdl and self:CreateClientModel(ITEM)
	if !IsValid(model) then return false end
	local pos, ang
	if item_attachment then
		local attach_id = ply:LookupAttachment(item_attachment)
		if !attach_id then return false end
		local attach = ply:GetAttachment(attach_id)
		if !attach then return false end
		pos = attach.Pos
		ang = attach.Ang
	else
		local bone_id = ply:LookupBone(item_bone)
		if !bone_id then return false end
		local matrix = ply:GetBoneMatrix(bone_id)
		if matrix then
			pos = matrix:GetTranslation()
			ang = matrix:GetAngles()
		else
			pos, ang = ply:GetBonePosition(bone_id)
		end
	end
	if !pos and !ang then return false end
	model, pos, ang = ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetPos(pos)
	model:SetAngles(ang)
	model:SetupBones()
	model:DrawModel()
	ITEM:PostModifyClientsideModel(ply, model, pos, ang)
	return true
end

function PANEL:DrawModels()
	local ply = LocalPlayer()
	local ent = self.Entity
	if !IsValid(ent) then return end
	ent:DrawModel()
	if PS.HoverModel then
		local allowed = self:DrawItemModel(PS.HoverModel, true)
		if allowed then return end
	end
	local collected = {}
	local ply_items = ply:PS_GetItems()
	for k, v in pairs(ply_items) do
		local ITEM = PS.Items[k]
		if ITEM and ITEM.Model and (ITEM.Attachment or ITEM.Bone) and ply:PS_HasItemEquipped(k) then
			collected[ITEM.Model] = true
			self:DrawItemModel(ITEM.ID)
		end
	end
	self:ClearClientModels(collected)
end
vgui.Register("DPointShopPreview", PANEL, "DModelPanel")