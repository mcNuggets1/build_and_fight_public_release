ITEM.Name = 'Buch der Transparenz'
ITEM.Price = 200000
ITEM.Model = 'models/props_lab/binderblue.mdl'
ITEM.WeaponClass = 'weapon_book'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end