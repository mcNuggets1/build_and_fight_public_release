ITEM.Name = 'Weihnachtsgeist'
ITEM.Price = 120000
ITEM.Model = 'models/captainbigbutt/skeyler/hats/santa.mdl'
ITEM.PetName = 'christmas_spirit'
ITEM.NoPreview = true

function ITEM:OnEquip(ply)
	if ply:Alive() then
		ply:CreatePet(self.PetName)
	end
end

function ITEM:OnHolster(ply)
	ply:RemovePet()
end