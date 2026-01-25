if SERVER then
	AddCSLuaFile()
end

SWEP.Base = "weapon_base"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.VElements = {}
SWEP.WElements = {}

function SWEP:Initialize()
	if CLIENT then
		self.VElements = table.FullCopy(self.VElements)
		self.WElements = table.FullCopy(self.WElements)
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements, true)
		local owner = self:GetOwner()
		if IsValid(owner) then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255, 255, 255, 255))
				else
					vm:SetColor(Color(255, 255, 255, 1))
					vm:SetMaterial("debug/hsv")			
				end
			end
		end
	end
end

function SWEP:Holster()
	local owner = self:GetOwner()
	if CLIENT and IsValid(owner) then
		local vm = owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	return true
end

function SWEP:OnRemove(fullUpdate)
	if fullUpdate then
		self.hadFullUpdate = true
		return
	end

	local owner = self:GetOwner()
	if CLIENT and IsValid(owner) then
		local vm = owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	if CLIENT then
		self:ClearModels(self.VElements)
		-- self:ClearModels(self.WElements)
	end
end

if SERVER then return end

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
	if tbl.hadFullUpdate then
		self:CreateModels(self.WElements, true)
		tbl.hadFullUpdate = nil
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
		if !v then
			tbl.wRenderOrder = nil break
		end
		if v.hide then continue end
		local bone_ent
		if IsValid(owner) and !v.weaponbone then
			bone_ent = owner
		else
			bone_ent = self
		end
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