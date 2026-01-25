ITEM.Name = 'Intervention'
ITEM.Price = 34000
ITEM.Model = 'models/weapons/w_snip_int.mdl'
ITEM.WeaponClass = 'm9k_intervention'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end