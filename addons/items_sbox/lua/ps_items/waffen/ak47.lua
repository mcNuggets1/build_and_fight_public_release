ITEM.Name = 'AK-47'
ITEM.Price = 25000
ITEM.Model = 'models/weapons/w_ak47_m9k.mdl'
ITEM.WeaponClass = 'm9k_ak47'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end