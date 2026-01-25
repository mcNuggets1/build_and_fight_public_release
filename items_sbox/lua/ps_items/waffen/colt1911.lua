ITEM.Name = 'Colt 1911'
ITEM.Price = 8600
ITEM.Model = 'models/weapons/s_dmgf_co1911.mdl'
ITEM.WeaponClass = 'm9k_colt1911'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end