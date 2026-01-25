ITEM.Name = 'SVD Dragunov'
ITEM.Price = 70000
ITEM.Model = 'models/weapons/w_svd_dragunov.mdl'
ITEM.WeaponClass = 'm9k_dragunov'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end