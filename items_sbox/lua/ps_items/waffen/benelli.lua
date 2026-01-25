ITEM.Name = 'Benelli M3'
ITEM.Price = 28000
ITEM.Model = 'models/weapons/w_benelli_m3.mdl'
ITEM.WeaponClass = 'm9k_m3'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end