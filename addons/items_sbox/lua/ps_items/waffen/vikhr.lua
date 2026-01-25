ITEM.Name = 'SR-3M Vikhr'
ITEM.Price = 34000
ITEM.Model = 'models/weapons/w_dmg_vikhr.mdl'
ITEM.WeaponClass = 'm9k_vikhr'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end