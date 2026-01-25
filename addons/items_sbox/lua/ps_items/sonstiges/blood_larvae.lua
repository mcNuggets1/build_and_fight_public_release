ITEM.Name = 'Blutfarbe: Larve'
ITEM.Price = 80000
ITEM.Model = 'models/antlion.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Blutfarbe"

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:SetBloodColor(BLOOD_COLOR_ANTLION_WORKER)
	end
end

function ITEM:OnHolster(ply)
	ply:SetBloodColor(BLOOD_COLOR_RED)
end