ITEM.Name = 'HK MP7'
ITEM.Price = 28000
ITEM.Model = 'models/weapons/w_mp7_silenced.mdl'
ITEM.WeaponClass = 'm9k_mp7'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end