ITEM.Name = 'Sans Fähigkeiten'
ITEM.Price = 200000
ITEM.Model = 'models/evangelos/undertale/gasterblaster.mdl'
ITEM.WeaponClass = 'weapon_undertale_sans'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end