ITEM.Name = 'Jagdbogen'
ITEM.Price = 150000
ITEM.Model = 'models/weapons/w_huntingbow.mdl'
ITEM.WeaponClass = 'weapon_huntingbow'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "arrows", 15)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "arrows", 15)
end