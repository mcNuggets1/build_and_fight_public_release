ITEM.Name = 'Medi Gun'
ITEM.Price = 100000
ITEM.Model = 'models/weapons/w_irifle.mdl'
ITEM.WeaponClass = 'weapon_medigun'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end