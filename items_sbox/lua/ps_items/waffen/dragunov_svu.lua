ITEM.Name = 'Dragunov SVU'
ITEM.Price = 43000
ITEM.Model = 'models/weapons/w_dragunov_svu.mdl'
ITEM.WeaponClass = 'm9k_svu'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end