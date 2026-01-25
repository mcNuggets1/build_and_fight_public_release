ITEM.Name = 'HK SL8'
ITEM.Price = 29000
ITEM.Model = 'models/weapons/w_hk_sl8.mdl'
ITEM.WeaponClass = 'm9k_sl8'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end