TOOL.Category = "Build & Fight"
TOOL.Name = "#tool.weight.name"

TOOL.ClientConVar["set"] = "1"

if CLIENT then
	language.Add("tool.weight.name", "Gewicht")
	language.Add("tool.weight.desc", "Ändert das Gewicht eines Gegenstands")
	language.Add("tool.weight.left", "Gewicht setzen")
	language.Add("tool.weight.right", "Gewicht kopieren")
	language.Add("tool.weight.reload", "Gewicht zurücksetzen")
	language.Add("tool.weight.set", "Gewicht:")
end

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}

local function SetMass(Player, Entity, Mass)
	if !SERVER then return end
	if Mass then
		local phys = Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(Mass)
		end
	end
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if !IsValid(ent) or ent:IsPlayer() then return false end
	if CLIENT then return true end
	if !IsValid(ent:GetPhysicsObject()) then return end
	local mass = tonumber(self:GetClientInfo("set"))
	if mass > 0 and mass <= 50000 then
		ent.OldMass = ent:GetPhysicsObject():GetMass()
		SetMass(self:GetOwner(), ent, mass)
	elseif mass < 0 then
		self:GetOwner():ChatPrint("Das Gewicht muss über 0 liegen!")
	else
		self:GetOwner():ChatPrint("Das Gewicht muss unter 50,000 liegen!")
	end
	return true
end

function TOOL:RightClick(trace)
	local ent = trace.Entity
	if !IsValid(ent) or ent:IsPlayer() then return false end
	if CLIENT then return true end
	if !IsValid(ent:GetPhysicsObject()) then return end
	self:GetOwner():ConCommand("weight_set "..ent:GetPhysicsObject():GetMass())
	return true
end

function TOOL:Reload(trace)
	local ent = trace.Entity
	if !IsValid(ent) or ent:IsPlayer() then return false end
	if CLIENT then return true end
	if !IsValid(ent:GetPhysicsObject()) then return end
	local mass = ent.OldMass or ent:GetPhysicsObject():GetMass()
	SetMass(self:GetOwner(), ent, mass)
	return true
end

function TOOL.BuildCPanel(cp)
	cp:AddControl("Header", {Text = "#tool.weight.name", Description = "#tool.weight.desc"})
	cp:AddControl("Slider", {Label = "#tool.weight.set", Type = "Numeric", Min = "1", Max = "50000", Command = "weight_set"})
end