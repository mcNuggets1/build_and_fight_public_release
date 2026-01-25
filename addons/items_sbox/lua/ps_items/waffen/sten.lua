ITEM.Name = 'STEN'
ITEM.Price = 14000
ITEM.Model = 'models/weapons/w_sten.mdl'
ITEM.WeaponClass = 'm9k_sten'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end