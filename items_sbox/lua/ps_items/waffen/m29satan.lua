ITEM.Name = 'M29 Satan'
ITEM.Price = 14000
ITEM.Model = 'models/weapons/w_m29_satan.mdl'
ITEM.WeaponClass = 'm9k_m29satan'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end