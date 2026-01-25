ITEM.Name = 'Großer Kopf'
ITEM.Price = 40000
ITEM.Model = 'models/Gibs/HGIBS.mdl'
ITEM.NoPreview = true
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Größe"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		local boneid = ply:LookupBone("ValveBiped.Bip01_Head1")
		if boneid then
			ply:ManipulateBoneScale(boneid, Vector(1.25, 1.25, 1.25))
		end
	end
end

function ITEM:OnHolster(ply)
	if ply:Alive() then
		local boneid = ply:LookupBone("ValveBiped.Bip01_Head1")
		if boneid then
			ply:ManipulateBoneScale(boneid, Vector(1, 1, 1))
		end
	end
end