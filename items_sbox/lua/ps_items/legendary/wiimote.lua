ITEM.Name = 'Wiimote'
ITEM.Price = 60000
ITEM.Model = 'models/weapons/w_wiimote_meow.mdl'
ITEM.WeaponClass = 'weapon_wiimote'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end