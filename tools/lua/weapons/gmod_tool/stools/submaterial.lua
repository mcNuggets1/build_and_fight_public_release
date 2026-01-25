TOOL.Category = "Render"
TOOL.Name = "Submaterial"

if CLIENT then
	language.Add("tool.submaterial.name", "Submaterial")
	language.Add("tool.submaterial.desc", "Hiermit können Submaterialien von Objekten überschrieben werden, wobei nicht jedes Objekt dies unterstützt.")
	language.Add("tool.submaterial.left", "Submaterial auf ausgewählte Position anwenden")
	language.Add("tool.submaterial.reload", "Material kopieren")
	language.Add("tool.submaterial.right", "Zu standardmäßigem Material zurücksetzen")
	language.Add("tool.submaterial.help", "Textur anwenden:")
	language.Add("tool.submateril.selectedmat", "Textur:")
end

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

TOOL.ClientConVar["override"] = "debug/env_cubemap_model"
TOOL.ClientConVar["index"] = 0

local function SetSubMaterial(Player, Entity, Data)
	if SERVER then
		local Mats = Entity:GetMaterials()
		local MatCount = table.Count(Mats)
		for i = 0, MatCount-1 do
			local si = "SubMaterialOverride_"..tostring(i)
			if Data[si] and ((!game.SinglePlayer() and string.lower(Data[si]) == "pp/copy") or Data[si] == "") then 
				Data[si] = nil
			end
			Entity:SetSubMaterial(i, Data[si] or "")			
		end
		duplicator.ClearEntityModifier(Entity, "submaterial")
		if table.Count(Data) > 0 then
			duplicator.StoreEntityModifier(Entity, "submaterial", Data)
		end
	end
	return true
end
duplicator.RegisterEntityModifier("submaterial", SetSubMaterial)

local function UpdateSubMat(Player, Entity, Index, Material)
	local Mats = Entity:GetMaterials()
	local MatCount = table.Count(Mats)
	if Index < 0 or Index >= MatCount then return end
	local Data = {}
	for i = 0, MatCount-1 do
		local mat = Entity:GetSubMaterial(i)
		if i == Index then mat = Material end
		if mat and mat != "" then
			Data["SubMaterialOverride_"..tostring(i)] = mat
		end	
	end
	return SetSubMaterial(Player, Entity, Data)		
end

local function SetMaterial(Player, Entity, Data)
	if SERVER then
		if !Data.MaterialOverride or (Data.MaterialOverride and (!game.SinglePlayer() and string.lower(Data.MaterialOverride) == "pp/copy")) then return end
		Entity:SetMaterial(Data.MaterialOverride)
		duplicator.StoreEntityModifier(Entity, "material", Data)
	end
	return true
end
duplicator.RegisterEntityModifier("material", SetMaterial)

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if !IsValid(ent) then return end
	if CLIENT then return true end
	if IsValid(ent.AttachedEntity) then
		ent = ent.AttachedEntity
	end
	local mat = self:GetClientInfo("override")
	local index = self:GetClientNumber("index" , 0)
	if index < 1 then
		SetMaterial(self:GetOwner(), ent, {MaterialOverride = mat})
	else
		UpdateSubMat(self:GetOwner(), ent, index-1, mat)
	end	
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
	if !IsValid(trace.Entity) then return end
	if CLIENT then return true end
	if IsValid(ent.AttachedEntity) then ent = ent.AttachedEntity end
	local index = self:GetClientNumber("index" , 0)
	if index < 1 then
		SetMaterial(self:GetOwner(), ent, {MaterialOverride = ""})
	else
		UpdateSubMat(self:GetOwner(), ent, index - 1, "")
	end
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
	if !IsValid(ent) then return end
	if SERVER then return true end
	if IsValid(ent.AttachedEntity) then
		ent = ent.AttachedEntity
	end
	local mat = self.HudData.EntCurMatString
	if mat and mat == "" then
		mat = ent:GetMaterial()
	end
	if !mat or mat != "" then
		RunConsoleCommand("submaterial_override", mat)
	end
	return true
end

if CLIENT then
	local function get_active_tool(ply, tool)
		local wep = ply:GetActiveWeapon()
		if !wep:IsValid() or wep:GetClass() != "gmod_tool" or wep:GetMode() != tool then return end
		return wep:GetToolObject(tool)
	end

	TOOL.AimEnt = nil
	TOOL.HudData = {}
	TOOL.SelIndx = 1
	TOOL.ToolMatString = ""

	function TOOL:Scroll(trace, dir)
		if !IsValid(self.AimEnt) then return end
		local Mats = self.AimEnt:GetMaterials()
		local MatCount = table.Count(Mats)
		self.SelIndx = self.SelIndx + dir
		if (self.SelIndx < 0) then
			self.SelIndx = MatCount
		end
		if (self.SelIndx > MatCount) then
			self.SelIndx = 0
		end
		RunConsoleCommand("submaterial_index", tostring(self.SelIndx))
		return true
	end

	function TOOL:ScrollUp(trace)
		return self:Scroll(trace, -1)
	end

	function TOOL:ScrollDown(trace)
		return self:Scroll(trace, 1)
	end

	local function hookfunc(ply, bind, pressed)
		if !pressed then return end
		if bind == "invnext" then
			local self = get_active_tool(ply, "submaterial")
			if !self then return end
			return self:ScrollDown(ply:GetEyeTrace())
		elseif bind == "invprev" then
			local self = get_active_tool(ply, "submaterial")
			if !self then return end
			return self:ScrollUp(ply:GetEyeTrace())
		end
	end
	if game.SinglePlayer() then
		timer.Simple(5, function()
			hook.Add("PlayerBindPress", "submat_tool_playerbindpress", hookfunc)
		end)
	else
		hook.Add("PlayerBindPress", "submat_tool_playerbindpress", hookfunc)
	end

	local function FixVertexLitMaterial(Mat)
		if !Mat then return Mat end
		local strImage = Mat:GetName()
		if (string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable")) then
			local t = Mat:GetString("$basetexture")
			if t then
				local params = {}
				params["$basetexture"] = t
				params["$vertexcolor"] = 1
				params["$vertexalpha"] = 1
				Mat = CreateMaterial(strImage .. "_hud_fx", "UnlitGeneric", params)
			end
		end
		return Mat
	end	

	function TOOL:Think()
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent.AttachedEntity) then
			ent = ent.AttachedEntity
		end
		if self.AimEnt != ent then
			self.AimEnt = ent
			if IsValid(self.AimEnt) then
				self.SelIndx = 0
				RunConsoleCommand("submaterial_index", tostring(self.SelIndx))
				self.HudData.Mats = self.AimEnt:GetMaterials()
			end
		end
			if IsValid(self.AimEnt) then
				self.HudData.CurMats = table.Copy(self.HudData.Mats)
				self.HudData.OvrMats = {}
				local MatCount = table.Count(self.HudData.Mats)
				for i = 1, MatCount do
					local mat = self.AimEnt:GetSubMaterial(i-1)
					if mat and mat != "" then
						self.HudData.OvrMats[i] = mat
					end	
				end
				table.Merge(self.HudData.CurMats, self.HudData.OvrMats)
				self.HudData.GlobalMat = self.AimEnt:GetMaterial()
				local EntCurMatString = self.HudData.GlobalMat
				local EntOrigMatString = self.HudData.GlobalMat
				if self.SelIndx > 0 then
					EntCurMatString = self.HudData.CurMats[self.SelIndx]
					EntOrigMatString = self.HudData.Mats[self.SelIndx]
				end 
				if self.HudData.EntCurMatString!= EntCurMatString then
					self.HudData.EntCurMatString = EntCurMatString
					self.HudData.EntCurMat = FixVertexLitMaterial(Material(EntCurMatString)) 
				end
				if self.HudData.EntOrigMatString!= EntOrigMatString then
					self.HudData.EntOrigMatString = EntOrigMatString
					self.HudData.EntOrigMat = FixVertexLitMaterial(Material(EntOrigMatString)) 
				end
			end
		if IsValid(self.AimEnt) and self.ToolMatString!= GetConVarString("submaterial_override") then
			self.ToolMatString = GetConVarString("submaterial_override")
 			self.HudData.ToolMat = FixVertexLitMaterial(Material(self.ToolMatString))
		end
	end

	function TOOL:DrawHUD()
		if IsValid(self.AimEnt) then
			local Rg = ScrW() / 2 - 50
			local MaxW = 0
			local TextH = 0
			surface.SetFont("ChatFont")
			local count = table.Count(self.HudData.Mats)
			local Hdr = tostring(self.AimEnt)..": "..tostring(count).." "..(count == 1 and "Material" or "Materialien")
			MaxW, TextH = surface.GetTextSize(Hdr)
			local HdrH = TextH + 5
			for _, s in pairs(self.HudData.CurMats) do
				local ts, _ = surface.GetTextSize(s)
				if MaxW < ts then
					MaxW = ts
				end
			end
			local LH = 4 * 2 + HdrH + TextH * (1 + table.Count(self.HudData.Mats))
			local LW = 4 * 2 + MaxW
			local LL = Rg - LW
			local LT = ScrH() / 2 - LH / 2
			surface.SetDrawColor(Color(64, 64, 95, 191))
			surface.DrawRect(LL, LT, LW, LH)
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetTextPos(LL + 4, LT + 4)
			surface.DrawText(Hdr)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawLine(LL + 3, LT + 4 + TextH + 3, Rg - 3, LT + 4 + TextH + 3)
			surface.SetDrawColor(Color(0, 127, 0, 191))
			surface.DrawRect(LL + 3, LT + 4 + HdrH + TextH * self.SelIndx, LW - 3 - 3, TextH)
			local s = "<Kein Material>"
			if !self.HudData.GlobalMat or self.HudData.GlobalMat == "" then 
				surface.SetTextColor(Color(255, 255, 255, 255)) 
			else
				surface.SetTextColor(Color(0, 0, 255, 255))
				s = self.HudData.GlobalMat
			end
			surface.SetTextPos(LL + 4, LT + 4 + HdrH)
			surface.DrawText(s)
			for i, s in pairs(self.HudData.CurMats) do
				if self.HudData.OvrMats[i] then
					surface.SetTextColor(Color(255, 0, 0, 255))
				else
					surface.SetTextColor(Color(255, 255, 255, 255))
				end
				surface.SetTextPos(LL + 4, LT + 4 + HdrH + TextH * i)
				surface.DrawText(s)
			end
			local StrToolInfo = "Werkzeug-Material:"
			local StrOrigMatInfo = "Originales Material:"
			local StrCurMatInfo = "Derzeitiges Material:"
			local MaxW, _ = surface.GetTextSize(StrToolInfo)
			local ts, _ = surface.GetTextSize(StrOrigMatInfo)
			if MaxW < ts then
				MaxW = ts
			end
			local ts, _ = surface.GetTextSize(StrCurMatInfo)
			if MaxW < ts then
				MaxW = ts
			end
			local ts, _ = surface.GetTextSize(self.ToolMatString)
			if MaxW < ts then
				MaxW = ts
			end
			local ts, _ = surface.GetTextSize(self.HudData.EntOrigMatString)
			if MaxW < ts then
				MaxW = ts
			end
			local ts, _ = surface.GetTextSize(self.HudData.EntCurMatString)
			if MaxW < ts then
				MaxW = ts
			end
			local IL = ScrW() / 2 + 50
			local IH = 4 * 4 + (64) * 3
			local IT = ScrH() / 2 - IH / 2
			surface.SetDrawColor(Color(64, 64, 95, 191))
			surface.DrawRect(IL, IT, 76 + MaxW, IH)
			surface.SetTextColor(Color(255, 255, 255, 255))
			surface.SetDrawColor(Color(255, 255, 255, 255))
			if self.HudData.ToolMat  then
				surface.SetMaterial(self.HudData.ToolMat)
				surface.DrawTexturedRect(IL + 4, IT + 4, 64, 64)
			end
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8)
			surface.DrawText(StrToolInfo)
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8 + TextH)
			surface.DrawText(self.ToolMatString)
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8 + TextH * 2)
			surface.DrawText(self.SelIndx == 0 and "[Global]" or "Index: "..self.SelIndx - 1)
			if self.HudData.EntOrigMat  then
				surface.SetMaterial(self.HudData.EntOrigMat)	
				surface.DrawTexturedRect(IL + 4, IT + 4 + (64 + 4), 64, 64)
			end
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8 + 64 + 4)
			surface.DrawText(StrOrigMatInfo)
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8 + 64 + 4 + TextH)
			surface.DrawText(self.HudData.EntOrigMatString)
			if self.HudData.EntCurMat  then
				surface.SetMaterial(self.HudData.EntCurMat)
				surface.DrawTexturedRect(IL + 4, IT + 4 + (64 + 4) * 2, 64, 64)
			end
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8 + (64 + 4) * 2)
			surface.DrawText(StrCurMatInfo)
			surface.SetTextPos(IL + 4 + 64 + 4, IT + 8 + (64 + 4) * 2 + TextH)
			surface.DrawText(self.HudData.EntCurMatString)
		end
	end
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {Description = "#tool.submaterial.help"})
	CPanel:AddControl("TextBox", {Label = "#tool.submateril.selectedmat", Command = "submaterial_override", MaxLength = "48"})
	local filter = CPanel:AddControl("TextBox", {Label = "#spawnmenu.quick_filter_tool"})
	filter:SetUpdateOnType(true)
	local materials = {}
	for id, str in pairs(list.Get("OverrideMaterials")) do
		if !table.HasValue(materials, str) then
			table.insert(materials, str)
		end
	end
	local matlist = CPanel:MatSelect("submaterial_override", materials, true, 0.25, 0.25)
	filter.OnValueChange = function(s, txt)
		for id, pnl in pairs(matlist.Controls) do
			if !pnl.Value:lower():find(txt:lower()) then
				pnl:SetVisible(false)
			else
				pnl:SetVisible(true)
			end
		end
		matlist:InvalidateChildren()
		CPanel:InvalidateChildren()
	end
end