TOOL.Category = "Construction"
TOOL.Name = "#Auftrieb"

TOOL.ClientConVar["ratio"] = "0"

if CLIENT then
	language.Add("Tool.buoyancy.name", "Auftrieb")
	language.Add("Tool.buoyancy.desc", "Lässt Props schwimmen")
	language.Add("Tool.buoyancy.left", "Auftrieb eines Props konfigurieren")
	language.Add("Tool.buoyancy.right", "Auftrieb eines Props zurücksetzen")
end

TOOL.Information = {
	{name = "left"},
	{name = "right"}
}

local function SetBuoyancy(ply, ent, data)
	local ratio = data.Ratio
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		local ratio = math.Clamp(data.Ratio, -1000, 1000) / 100
		ent.BuoyancyRatio = ratio
		phys:SetBuoyancyRatio(ratio)
		phys:Wake()
	end
	return true
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if !ent or !IsValid(ent) then return false end
	if CLIENT then return true end
	SetBuoyancy(self:GetOwner(), ent, { Ratio = self:GetClientNumber("ratio") })
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
	if !ent or !IsValid(ent) then return false end
	if CLIENT then return true end
	SetBuoyancy(self:GetOwner(), ent, { Ratio = self:GetClientNumber("0") })
	return true
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(panel)	
	panel:AddControl("Header", {Description = "Lässt Props schwimmen"})
	panel:AddControl("ComboBox", {MenuButton = 1, Folder = "buoyancy", Options = {["#preset.default"] = ConVarsDefault}, CVars = table.GetKeys(ConVarsDefault)})
	panel:NumSlider("Wasserauftrieb", "buoyancy_ratio", -1000, 1000)
end

if SERVER then
	local function OnDrop(ply, ent)
		if ent.BuoyancyRatio then
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				timer.Simple(0, function()
					if !IsValid(phys) then return end
					phys:SetBuoyancyRatio(ent.BuoyancyRatio)
				end)
			end
		end
	end
	hook.Add("PhysgunDrop", "buoyancy", OnDrop)
	hook.Add("GravGunOnDropped", "buoyancy", OnDrop)
end