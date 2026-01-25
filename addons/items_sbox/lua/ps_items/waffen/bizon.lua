ITEM.Name = 'Bizon PP19'
ITEM.Price = 24000
ITEM.Model = 'models/weapons/w_pp19_bizon.mdl'
ITEM.WeaponClass = 'm9k_bizonp19'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end