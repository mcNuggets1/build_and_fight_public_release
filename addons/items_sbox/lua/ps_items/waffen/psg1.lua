ITEM.Name = 'PSG-1'
ITEM.Price = 53000
ITEM.Model = 'models/weapons/w_hk_psg1.mdl'
ITEM.WeaponClass = 'm9k_psg1'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end