ITEM.Name = 'TEC-9'
ITEM.Price = 15000
ITEM.Model = 'models/weapons/w_intratec_tec9.mdl'
ITEM.WeaponClass = 'm9k_tec9'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end