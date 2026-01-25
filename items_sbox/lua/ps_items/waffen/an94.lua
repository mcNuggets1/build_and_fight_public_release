ITEM.Name = 'AN-94'
ITEM.Price = 35000
ITEM.Model = 'models/weapons/w_rif_an_94.mdl'
ITEM.WeaponClass = 'm9k_an94'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end