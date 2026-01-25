ITEM.Name = 'Nitro Glycerine'
ITEM.Price = 75000
ITEM.Model = 'models/weapons/w_nitro.mdl'
ITEM.WeaponClass = 'm9k_nitro'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end