ITEM.Name = 'Barret M82'
ITEM.Price = 40000
ITEM.Model = 'models/weapons/w_barret_m82.mdl'
ITEM.WeaponClass = 'm9k_barret_m82'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end