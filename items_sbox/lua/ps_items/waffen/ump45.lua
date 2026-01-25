ITEM.Name = 'HK UMP45'
ITEM.Price = 25000
ITEM.Model = 'models/weapons/w_hk_ump45.mdl'
ITEM.WeaponClass = 'm9k_ump45'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end