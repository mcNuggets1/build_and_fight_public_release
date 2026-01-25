ITEM.Name = 'Winchester 1897'
ITEM.Price = 30000
ITEM.Model = 'models/weapons/w_winchester_1897_trench.mdl'
ITEM.WeaponClass = 'm9k_1897winchester'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end