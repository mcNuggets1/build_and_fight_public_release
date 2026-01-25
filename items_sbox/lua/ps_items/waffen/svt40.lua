ITEM.Name = 'SVT40'
ITEM.Price = 60000
ITEM.Model = 'models/weapons/w_svt_40.mdl'
ITEM.WeaponClass = 'm9k_svt40'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end