ITEM.Name = 'M61 Granate'
ITEM.Price = 30000
ITEM.Model = 'models/weapons/w_m61_fraggynade.mdl'
ITEM.WeaponClass = 'm9k_m61_frag'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "m61_frag", 2)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end