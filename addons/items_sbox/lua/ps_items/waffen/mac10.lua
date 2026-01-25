ITEM.Name = 'MAC 10'
ITEM.Price = 31000
ITEM.Model = 'models/weapons/w_notmic_98bmac10.mdl'
ITEM.WeaponClass = 'm9k_mac10'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end