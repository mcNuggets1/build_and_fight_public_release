ITEM.Name = 'MP40'
ITEM.Price = 26000
ITEM.Model = 'models/weapons/w_mp40smg.mdl'
ITEM.WeaponClass = 'm9k_mp40'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end