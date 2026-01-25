ITEM.Name = 'KRISS Vector'
ITEM.Price = 32000
ITEM.Model = 'models/weapons/w_kriss_vector.mdl'
ITEM.WeaponClass = 'm9k_vector'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end