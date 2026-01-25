ITEM.Name = 'Blutfarbe: Mechanisch'
ITEM.Price = 100000
ITEM.Model = 'models/dog.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Blutfarbe"

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:SetBloodColor(BLOOD_COLOR_MECH)
	end
end

function ITEM:OnHolster(ply)
	ply:SetBloodColor(BLOOD_COLOR_RED)
end