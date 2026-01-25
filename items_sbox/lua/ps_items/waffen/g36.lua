ITEM.Name = 'G36'
ITEM.Price = 26000
ITEM.Model = 'models/weapons/w_hk_g36c.mdl'
ITEM.WeaponClass = 'm9k_g36'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end