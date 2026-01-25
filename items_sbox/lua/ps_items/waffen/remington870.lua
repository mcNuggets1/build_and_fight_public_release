ITEM.Name = 'Remington 870'
ITEM.Price = 33000
ITEM.Model = 'models/weapons/w_remington_870_tact.mdl'
ITEM.WeaponClass = 'm9k_remington870'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end