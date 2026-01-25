ITEM.Name = 'Barret M98B'
ITEM.Price = 37000
ITEM.Model = 'models/weapons/w_barrett_m98b.mdl'
ITEM.WeaponClass = 'm9k_m98b'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end