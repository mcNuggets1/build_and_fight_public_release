ITEM.Name = 'Browning Auto 5'
ITEM.Price = 60000
ITEM.Model = 'models/weapons/w_browning_auto.mdl'
ITEM.WeaponClass = 'm9k_browningauto5'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end