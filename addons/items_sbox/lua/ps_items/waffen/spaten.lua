ITEM.Name = 'Spaten'
ITEM.Price = 7000
ITEM.Model = 'models/khrcw2/doipack/w_etoolus.mdl'
ITEM.WeaponClass = 'm9k_spade'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end