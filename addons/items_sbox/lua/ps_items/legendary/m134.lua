ITEM.Name = 'M134 Maschinengewehr'
ITEM.Price = 400000
ITEM.Model = 'models/weapons/w_m134_minigun.mdl'
ITEM.WeaponClass = 'm9k_minigun'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end