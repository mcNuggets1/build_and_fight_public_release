ITEM.Name = 'Zufälliges Pet'
ITEM.Price = 250000
ITEM.Model = 'models/props/de_tides/vending_turtle.mdl'
ITEM.NoPreview = true

local Pets = {}

timer.Simple(0, function()
	for _, v in pairs(PS.Items) do
		if v.Category == "Pets" and v.Name != "Zufälliges Pet" then
			table.insert(Pets, v.PetName)
		end
	end
end)

function ITEM:OnEquip(ply)
	local PetName = Pets[math.random(#Pets)]
	if ply:Alive() then
		ply:CreatePet(PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang, panel)
	model:SetMaterial("models/wireframe")
	return model, pos, ang
end