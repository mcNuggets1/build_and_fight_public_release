ITEM.Name = 'M1918 BAR'
ITEM.Price = 42000
ITEM.Model = 'models/weapons/w_m1918_bar.mdl'
ITEM.WeaponClass = 'm9k_m1918bar'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end