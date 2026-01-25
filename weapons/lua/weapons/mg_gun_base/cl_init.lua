include("shared.lua")

hook.Add("OnContextMenuOpen", "MG_DisableContextMenu", function()
	if GetConVar("mg_m9k_disablecontextmenu"):GetBool() then
		local wep = LocalPlayer():GetActiveWeapon()
		if (wep:IsValid() and (wep.IsGun or wep.IsGrenade)) then
			return false
		end
	end
end)

SWEP.CH_Aiming = false
SWEP.CH_AimTime = 0
SWEP.CH_AimDiff = 0
SWEP.CH_AimDiff2 = 0
SWEP.CH_Jumping = false
SWEP.CH_JumpTime = 0
SWEP.CH_JumpDiff = 0
SWEP.CH_JumpDiff2 = 0
SWEP.CH_Scale = 0

function SWEP:InitClient()
	self.HasCrosshair = self.DrawCrosshair
	self.VElements = table.FullCopy(self.VElements)
	self.WElements = table.FullCopy(self.WElements)
	self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
	self:CreateModels(self.VElements)
	self:CreateModels(self.WElements, true)
	if IsValid(self.Owner) and !self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
			if (self.ShowViewModel == nil or self.ShowViewModel) then
				vm:SetColor(color_white)
			else
				vm:SetMaterial("debug/hsv")
			end
		end
	end
	if self.DrawWeaponInfoBox and self.AutoInsertInfo then
		local bind = self.Translations.Primary
		self.Instructions = bind..": "..self.Translations.Shoot
		if self.CanAim then
			local bind = self.Translations.Secondary
			self.Instructions = self.Instructions.."\n"..bind..": "..self.Translations.Aim
		end
		if self.CanReload then
			local bind = self.Translations.Reload
			self.Instructions = self.Instructions.."\n"..bind..": "..self.Translations.ReloadAction
		end
		if self.CanSilence then
			local bind = self.Translations.Use
			local bind2 = self.Translations.Secondary
			self.Instructions = self.Instructions.."\n"..bind.." + "..bind2..": "..self.Translations.Silence
		end
		if self.CanSelectFire then
			local bind = self.Translations.Use
			local bind2 = self.Translations.Reload
			self.Instructions = self.Instructions.."\n"..bind.." + "..bind2..": "..self.Translations.SelectFire
		end
	end
	if self.ForceWeaponIcon then
		self.WepSelectIcon = surface.GetTextureID(string.gsub("vgui/hud/name", "name", self.ClassName))
	end
	self.LastFOV = GetConVar("fov_desired"):GetInt()
	self.CH_Jumping = IsValid(self.Owner) and (!self.Owner:OnGround() or self.Owner:GetMoveType() != MOVETYPE_WALK) or false
end

local vector_0 = Vector(0, 0, 0)
local angle_0 = Angle(0, 0, 0)
local vector_1 = Vector(1, 1, 1)
function SWEP:DeployClient()
	self:HideAttachments(false)
	self:HideViewModel(false)
	self.AimingClientside = false
	self.RunningClientside = false
	if self.HasCrosshair then
		self.DrawCrosshair = true
	end
	self.SwayScale = 1
	self.BobScale = 1
	self.LastFOV = GetConVar("fov_desired"):GetInt()
	self.LastZoomSysTime = 0
	self.LastAim = false
	self.LastMultiX = 0
	self.MoveToPos = vector_0
	self.AngleToPos = angle_0
	self.CH_Aiming = false
	self.CH_Jumping = IsValid(self.Owner) and (!self.Owner:OnGround() or self.Owner:GetMoveType() != MOVETYPE_WALK) or false
end

function SWEP:HolsterClient()
	self:HideAttachments(false)
	self:HideViewModel(false)
	if self.HasCrosshair then
		self.DrawCrosshair = true
	end
	self.SwayScale = 1
	self.BobScale = 1
	self.LastFOV = GetConVar("fov_desired"):GetInt()
	self.LastZoomSysTime = 0
	self.LastAim = false
	self.LastMultiX = 0
	self.MoveToPos = vector_0
	self.AngleToPos = angle_0
	self.CH_Aiming = false
	self.CH_Jumping = false
end

function SWEP:ClearAllModels(noWorld)
	local vm = IsValid(self.Owner) and self.Owner:GetViewModel()
	if IsValid(vm) then
		self:ResetBonePositions(vm)
	end
	self:ClearModels(self.VElements)

	if noWorld then return end
	self:ClearModels(self.WElements)
end

local sights_opacity = CreateConVar("mg_m9k_aiming_crosshair_opacity", 0.6, FCVAR_ARCHIVE)
local crosshair_size = CreateConVar("mg_m9k_crosshair_size", 0.9, FCVAR_ARCHIVE)
local crosshair_thickness = CreateConVar("mg_m9k_crosshair_thickness", 0.1, FCVAR_ARCHIVE)
local crosshair_color_r = CreateConVar("mg_m9k_crosshair_color_r", 255, FCVAR_ARCHIVE)
local crosshair_color_g = CreateConVar("mg_m9k_crosshair_color_g", 255, FCVAR_ARCHIVE)
local crosshair_color_b = CreateConVar("mg_m9k_crosshair_color_b", 255, FCVAR_ARCHIVE)
local disable_crosshair = CreateConVar("mg_m9k_disable_crosshair", 0, FCVAR_ARCHIVE)
local alternate_crosshair = CreateConVar("mg_m9k_alternate_crosshair", 0, FCVAR_ARCHIVE)

function SWEP:CrosshairThink(self_tbl, self_dt)
	if !self_tbl or !self_dt then return end
	local cur_time = CurTime()
	local aiming = self:GetPredictedAiming()
	if aiming then
		if !self_tbl.CH_Aiming then
			self_tbl.CH_Aiming = true
			self_tbl.CH_AimTime = cur_time
		end
	elseif self_tbl.CH_Aiming then
		self_tbl.CH_Aiming = false
		self_tbl.CH_AimTime = cur_time
	end
	local owner = self:GetOwner()
	if owner:IsValid() and (owner:GetMoveType() != MOVETYPE_WALK or !owner:OnGround()) then
		if !self_tbl.CH_Jumping then
			self_tbl.CH_Jumping = true
			self_tbl.CH_JumpTime = cur_time
		end
	elseif self_tbl.CH_Jumping then
		self_tbl.CH_Jumping = false
		self_tbl.CH_JumpTime = cur_time
	end
	local spread = (GetConVar("mg_m9k_spreadmultiplicator"):GetFloat() or 1)
	local maxspread = 15 * self_tbl.Primary.Spread * spread
	local minspread = 15 * self_tbl.Primary.IronAccuracy * spread
	if self_tbl.CH_Aiming then
		self_tbl.CH_Scale = math.max(0.15, Lerp((cur_time - self_tbl.CH_AimTime) * 8 - self_tbl.CH_AimDiff2, maxspread, minspread))
		self_tbl.CH_AimDiff = math.min((cur_time - self_tbl.CH_AimTime - self_tbl.CH_AimDiff2) * 8, 1) - 1
	else
		self_tbl.CH_Scale = math.max(0.15, Lerp((cur_time - self_tbl.CH_AimTime) * 8 - self_tbl.CH_AimDiff, minspread, maxspread))
		self_tbl.CH_AimDiff2 = math.min((cur_time - self_tbl.CH_AimTime - self_tbl.CH_AimDiff) * 8, 1) - 1
	end
	if self_tbl.CH_Jumping then
		self_tbl.CH_Scale = Lerp((cur_time - self_tbl.CH_JumpTime) * 8 - self_tbl.CH_JumpDiff2, self_tbl.CH_Scale, self_tbl.CH_Scale * GetConVar("mg_m9k_jumppenaltymult"):GetFloat())
		self_tbl.CH_JumpDiff = math.min((cur_time - self_tbl.CH_JumpTime - self_tbl.CH_JumpDiff2) * 8, 1) - 1
	else
		self_tbl.CH_Scale = Lerp((cur_time - self_tbl.CH_JumpTime) * 8 - self_tbl.CH_JumpDiff, self_tbl.CH_Scale * GetConVar("mg_m9k_jumppenaltymult"):GetFloat(), self_tbl.CH_Scale)
		self_tbl.CH_JumpDiff2 = math.min((cur_time - self_tbl.CH_JumpTime - self_tbl.CH_JumpDiff) * 8, 1) - 1
	end
	self_tbl.CH_Scale = Lerp((cur_time - self:LastShootTime()) * 8, self_tbl.CH_Scale * 2, self_tbl.CH_Scale)
end

function SWEP:DoDrawCrosshair()
	if alternate_crosshair:GetBool() then return end
	if disable_crosshair:GetBool() or !self.DrawCrosshair then return true end
	if self.CH_Scale == 0 then
		local self_tbl = self:GetTable()
		self:CrosshairThink(self_tbl, self_tbl.dt)
	end
	local x, y = ScrW() / 2, ScrH() / 2
	local alpha = self:GetPredictedAiming() and sights_opacity:GetFloat() or 1
	local gap = math.Round(20 * self.CH_Scale)
	local length = math.floor(10 * crosshair_size:GetFloat())
	local outline = math.floor(25 * crosshair_thickness:GetFloat())
	surface.SetDrawColor(0, 0, 0, 255 * alpha)
	surface.DrawRect(x - length - gap, y - outline / 2, length, outline)
	surface.DrawRect(x + gap, y - outline / 2, length, outline)
	surface.DrawRect(x - outline / 2, y - gap - length, outline, length)
	surface.DrawRect(x - outline / 2, y + gap, outline, length)
	surface.SetDrawColor(crosshair_color_r:GetInt(), crosshair_color_g:GetInt(), crosshair_color_b:GetInt(), 255 * alpha)
	surface.DrawRect(x - length - gap + length * 0.05, y - outline / 4, length * 0.95, outline / 2)
	surface.DrawRect(x + gap + length * 0.05, y - outline / 4, length * 0.95, outline / 2)
	surface.DrawRect(x - outline / 4, y - gap - length + length * 0.05, outline / 2, length * 0.95)
	surface.DrawRect(x - outline / 4, y + gap + length * 0.05, outline / 2, length * 0.95)
	return true
end

concommand.Add("mg_m9k_crosshair_reset", function()
	RunConsoleCommand("mg_m9k_aiming_crosshair_opacity", 0.6)
	RunConsoleCommand("mg_m9k_crosshair_size", 0.9)
	RunConsoleCommand("mg_m9k_crosshair_thickness", 0.1)
	RunConsoleCommand("mg_m9k_crosshair_color_r", 255)
	RunConsoleCommand("mg_m9k_crosshair_color_g", 255)
	RunConsoleCommand("mg_m9k_crosshair_color_b", 255)
	RunConsoleCommand("mg_m9k_disable_crosshair", 0)
	RunConsoleCommand("mg_m9k_alternate_crosshair", 0)
end)

SWEP.vRenderOrder = nil
function SWEP:ViewModelDrawn(vm)
	local tbl = self:GetTable()
	if !tbl.VElements then return end
	self:UpdateBonePositions(vm)
	if !tbl.vRenderOrder then	   
		tbl.vRenderOrder = {}
		for k, v in pairs(tbl.VElements) do
			if (v.type == "Model") then
				table.insert(tbl.vRenderOrder, 1, k)
			elseif (v.type == "Sprite" or v.type == "Quad") then
				table.insert(tbl.vRenderOrder, k)
			end
		end
	end
	for k, name in ipairs(tbl.vRenderOrder) do
		local v = tbl.VElements[name]
		if !v then tbl.vRenderOrder = nil break end
		if v.hide then continue end	   
		local model = v.modelEnt
		local sprite = v.spriteMaterial   
		if !v.bone then continue end   
		local pos, ang = self:GetBoneOrientation(tbl.VElements, v, vm)
		if !pos then continue end	   
		if (v.type == "Model" and IsValid(model)) then
			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			model:SetAngles(ang)
			local matrix = Matrix()
			matrix:Scale(v.size)
			model:EnableMatrix("RenderMultiply", matrix) 
			if (v.material == "") then
				model:SetMaterial("")
			elseif (model:GetMaterial() != v.material) then
				model:SetMaterial(v.material)
			end
			if (v.skin and v.skin != model:GetSkin()) then
				model:SetSkin(v.skin)
			end		   
			if v.bodygroup then
				for k, v in pairs(v.bodygroup) do
					if model:GetBodygroup(k) != v then
						model:SetBodygroup(k, v)
					end
				end
			end	   
			if v.surpresslightning then
				render.SuppressEngineLighting(true)
			end
			render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
			render.SetBlend(v.color.a/255)
			model:DrawModel()
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)
			if v.surpresslightning then
				render.SuppressEngineLighting(false)
			end
		elseif (v.type == "Sprite" and sprite) then
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			render.SetMaterial(sprite)
			render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)		   
		elseif (v.type == "Quad" and v.draw_func) then
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
			cam.End3D2D()
		end
	end
end

SWEP.wRenderOrder = nil
function SWEP:DrawWorldModel()
	local tbl = self:GetTable()
	local owner = self:GetOwner()
	if (tbl.ShowWorldModel == nil or tbl.ShowWorldModel) or tbl.ShowWorldModelNoOwner and !IsValid(owner) then
		self:DrawModel()
	end
	if !tbl.WElements then return end
	if !tbl.wRenderOrder then
		tbl.wRenderOrder = {}
		for k, v in pairs(tbl.WElements) do
			if (v.type == "Model") then
				table.insert(tbl.wRenderOrder, 1, k)
			elseif (v.type == "Sprite" or v.type == "Quad") then
				table.insert(tbl.wRenderOrder, k)
			end
		end
	end
	if IsValid(owner) then
		bone_ent = owner
	else
		bone_ent = self
	end
	for k, name in pairs(tbl.wRenderOrder) do
		local v = tbl.WElements[name]
		if !v then tbl.wRenderOrder = nil break end
		if v.hide then continue end
		local pos, ang
		if v.bone then
			pos, ang = self:GetBoneOrientation(tbl.WElements, v, bone_ent)
		else
			pos, ang = self:GetBoneOrientation(tbl.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
		end
		if !pos then continue end
		local model = v.modelEnt
		local sprite = v.spriteMaterial
		if (v.type == "Model" and IsValid(model)) then
			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			model:SetAngles(ang)
			local matrix = Matrix()
			matrix:Scale(v.size)
			model:EnableMatrix("RenderMultiply", matrix)
			if (v.material == "") then
				model:SetMaterial("")
			elseif (model:GetMaterial() != v.material) then
				model:SetMaterial(v.material)
			end
			if (v.skin and v.skin != model:GetSkin()) then
				model:SetSkin(v.skin)
			end
			if v.bodygroup then
				for k, v in pairs(v.bodygroup) do
					if (model:GetBodygroup(k) != v) then
						model:SetBodygroup(k, v)
					end
				end
			end
			if v.surpresslightning then
				render.SuppressEngineLighting(true)
			end
			render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
			render.SetBlend(v.color.a/255)
			model:DrawModel()
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)
			if v.surpresslightning then
				render.SuppressEngineLighting(false)
			end  
		elseif (v.type == "Sprite" and sprite) then
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			render.SetMaterial(sprite)
			render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
		elseif (v.type == "Quad" and v.draw_func) then
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			cam.Start3D2D(drawpos, ang, v.size)
			v.draw_func(self)
			cam.End3D2D()
		end
	end
end

function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
	local bone, pos, ang
	if (tab.rel and tab.rel != "") then
		local v = basetab[tab.rel]
		if !v then return end
		pos, ang = self:GetBoneOrientation(basetab, v, ent)
		if !pos then return end
		pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		ang:RotateAroundAxis(ang:Up(), v.angle.y)
		ang:RotateAroundAxis(ang:Right(), v.angle.p)
		ang:RotateAroundAxis(ang:Forward(), v.angle.r)
	else
		bone = ent:LookupBone(bone_override or tab.bone)
		if !bone then return end
		pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
		local m = ent:GetBoneMatrix(bone)
		if m then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		local owner = self:GetOwner()
		if (IsValid(owner) and owner:IsPlayer() and ent == owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r
		end
	end
	return pos, ang
end

MG_CollectedWorldModels = {}

function SWEP:CreateModels(tab, collectGarbage)
	if !tab then return end
	for k, v in pairs(tab) do
		if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME")) then
			SafeRemoveEntity(v.modelEnt)
			v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
			if IsValid(v.modelEnt) then
				v.modelEnt:SetPos(self:GetPos())
				v.modelEnt:SetAngles(self:GetAngles())
				v.modelEnt:SetParent(self)
				v.modelEnt:SetNoDraw(true)
				v.createdModel = v.model

				if collectGarbage then
					MG_CollectedWorldModels[v.modelEnt] = self
				end
			else
				v.modelEnt = nil
			end
		elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) and file.Exists("materials/"..v.sprite..".vmt", "GAME")) then 
			local name = v.sprite.."-"
			local params = {["$basetexture"] = v.sprite}
			local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}
			for i, j in pairs(tocheck) do
				if v[j] then
					params["$"..j] = 1
					name = name.."1"
				else
					name = name.."0"
				end
			end
			v.createdSprite = v.sprite
			v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
		end
	end
end

function SWEP:ClearModels(tab)
	if !tab then return end
	for _, v in pairs(tab) do
		if v.type == "Model" and IsValid(v.modelEnt) then
			SafeRemoveEntity(v.modelEnt)
		end
	end
end

local allbones
function SWEP:UpdateBonePositions(vm)
	if self.ViewModelBoneMods then
		if !vm:GetBoneCount() then return end
		local boneloop = self.ViewModelBoneMods
		allbones = {}
		for i=0, vm:GetBoneCount() do
			local bonename = vm:GetBoneName(i)
			if (self.ViewModelBoneMods[bonename]) then
				allbones[bonename] = self.ViewModelBoneMods[bonename]
			else
				allbones[bonename] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)}
			end
		end
		boneloop = allbones
		for k, v in pairs(boneloop) do
			local bone = vm:LookupBone(k)
			if !bone then continue end
			local s = Vector(v.scale.x,v.scale.y,v.scale.z)
			local p = Vector(v.pos.x,v.pos.y,v.pos.z)
			local ms = Vector(1, 1, 1)
			local cur = vm:GetBoneParent(bone)
			while(cur >= 0) do
				local pscale = boneloop[vm:GetBoneName(cur)].scale
				ms = ms * pscale
				cur = vm:GetBoneParent(cur)
			end
			s = s * ms
			if vm:GetManipulateBoneScale(bone) != s then
			  	vm:ManipulateBoneScale(bone, s)
			end
			if vm:GetManipulateBoneAngles(bone) != v.angle then
			 	vm:ManipulateBoneAngles(bone, v.angle)
			end
			if vm:GetManipulateBonePosition(bone) != p then
				vm:ManipulateBonePosition(bone, p)
			end
		end
   	else
		self:ResetBonePositions(vm)
	end
end

local vector_1 = Vector(1, 1, 1)
local angle_0 = Angle(0, 0, 0)
local vector_0 = Vector(0, 0, 0)
function SWEP:ResetBonePositions(vm)
	local bones = vm:GetBoneCount()
	if !bones or bones == -1 then return end
	for i=0, bones do
		vm:ManipulateBoneScale(i, vector_1)
		vm:ManipulateBoneAngles(i, angle_0)
		vm:ManipulateBonePosition(i, vector_0)
	end
end

function table.FullCopy(tab)
	if !tab then return nil end
	local res = {}
	for k, v in pairs(tab) do
		if istable(v) then
			res[k] = table.FullCopy(v)
		elseif isvector(v) then
			res[k] = Vector(v.x, v.y, v.z)
		elseif isangle(v) then
			res[k] = Angle(v.p, v.y, v.r)
		else
			res[k] = v
		end
	end
	return res
end

timer.Create("MG_CleanupWorldModels", 1, 0, function()
	for ent, parentEnt in pairs(MG_CollectedWorldModels) do
		if !ent:IsValid() then
			MG_CollectedWorldModels[ent] = nil
		elseif !parentEnt:IsValid() then
			SafeRemoveEntity(ent)
			MG_CollectedWorldModels[ent] = nil
		end
	end
end)

local nextcheck = CurTime()
local local_ply
local function ResetBoneHack()
	local cur_time = CurTime()
	if nextcheck > cur_time then return end
	nextcheck = cur_time + 0.25
	local_ply = local_ply or LocalPlayer()
	if !local_ply:IsValid() then
		local_ply = LocalPlayer()
		if !local_ply:IsValid() then return end
	end
	local wep = local_ply:GetActiveWeapon()
	if wep:IsValid() then
		local owner = wep:GetOwner()
		if owner:IsValid() then
			if wep.ViewModelBoneMods then return end
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				local bone_cnt = vm:GetBoneCount()
				if bone_cnt == -1 then return end
				for i=0, bone_cnt do
					if vm:GetManipulateBoneScale(i) == vector_1 and vm:GetManipulateBoneAngles(i) == angle_0 and vm:GetManipulateBonePosition(i) == vector_0 then continue end
					vm:ManipulateBoneScale(i, vector_1)
					vm:ManipulateBoneAngles(i, angle_0)
					vm:ManipulateBonePosition(i, vector_0)
				end
			end
		end
	end
end
hook.Add("Think", "ResetBoneHack", ResetBoneHack)

SWEP.LastAim = false
SWEP.LastMultiX = 0
SWEP.LastIronSysTime = 0
function SWEP:GetViewModelPosition(pos, ang)
	local tb = self:GetTable()
	local lowered = self:GetLowered() and tb.QueueLowerAnim <= CurTime()
	local aiming = self:GetPredictedAiming()
	local running = self:GetPredictedRunning()
	local ironsights = lowered or aiming or running
	if lowered then
		tb.MoveToPos = tb.LoweredPos or vector_0
		tb.AngleToPos = tb.LoweredAng or vector_0
	elseif aiming then
		tb.MoveToPos = tb.SightsPos or vector_0
		tb.AngleToPos = tb.SightsAng or vector_0
	elseif running then
		tb.MoveToPos = tb.RunSightsPos or vector_0
		tb.AngleToPos = tb.RunSightsAng or vector_0
	end
	if aiming != tb.LastAim then
		tb.LastAim = aiming
		if tb.AimHideAttachments then
			self:HideAttachments(tb.LastAim)
		end
		if tb.AimHideViewModel then
			self:HideViewModel(tb.LastAim)
		end
	end
	local sys_time = SysTime()
	local multx
	if ironsights then
		multx = (tb.LastMultiX == 1 and 1) or Lerp((sys_time - tb.LastIronSysTime) * 15, tb.LastMultiX, 1)
	else
		multx = (tb.LastMultiX == 0 and 0) or Lerp((sys_time - tb.LastIronSysTime) * 15, tb.LastMultiX, 0)
	end
	tb.LastIronSysTime = sys_time
	if tb.AngleToPos then
		local offset = tb.AngleToPos
		ang:RotateAroundAxis(ang:Right(), offset.x * multx)
		ang:RotateAroundAxis(ang:Up(), offset.y * multx)
		ang:RotateAroundAxis(ang:Forward(), offset.z * multx)
	end
	if tb.MoveToPos then
		local offset = tb.MoveToPos
		pos = pos + offset.x * ang:Right() * multx
		pos = pos + offset.y * ang:Forward() * multx
		pos = pos + offset.z * ang:Up() * multx
	end
	tb.LastMultiX = multx
	return pos, ang
end

SWEP.LastZoomSysTime = 0
function SWEP:TranslateFOV(fov)
	if self:GetOwner():InVehicle() then return end

	local tb = self:GetTable()
	local sights_fov = tb.Secondary.SightsFOV
	if sights_fov == 0 then return fov end
	if !tb.LastFOV then
		tb.LastFOV = GetConVar("fov_desired"):GetInt()
	end
	local sys_time = SysTime()
	local multx = (tb.LastFOV == sights_fov and sights_fov) or Lerp((sys_time - tb.LastZoomSysTime) * 20, tb.LastFOV, sights_fov)
	if !tb.LastAim then
		multx = (tb.LastFOV == fov and fov) or Lerp((sys_time - tb.LastZoomSysTime) * 20, tb.LastFOV, fov)
	end
	tb.LastZoomSysTime = sys_time
	tb.LastFOV = multx
	return multx
end

function SWEP:PreDrawViewModel()
	if self.ShouldHideViewModel then
		render.SetBlend(0)
	end
end

function SWEP:HideViewModel(hide)
	self.ShouldHideViewModel = hide
end

function SWEP:HideAttachments(hide)
	for _, model in pairs(self.VElements) do
		model.hide = hide
	end
end