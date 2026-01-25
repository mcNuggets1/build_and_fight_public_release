ITEM.Name = 'Blutfarbe: Gelb'
ITEM.Price = 75000
ITEM.Model = 'models/zombie/fast.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Blutfarbe"

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:SetBloodColor(BLOOD_COLOR_YELLOW)
	end
end

function ITEM:OnHolster(ply)
	ply:SetBloodColor(BLOOD_COLOR_RED)
end