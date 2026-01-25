ITEM.Name = 'Messer'
ITEM.Price = 5000
ITEM.Model = 'models/khrcw2/doipack/w_kabar.mdl'
ITEM.WeaponClass = 'm9k_knife'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end