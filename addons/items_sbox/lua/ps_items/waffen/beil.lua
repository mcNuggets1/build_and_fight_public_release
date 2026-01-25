ITEM.Name = 'Beil'
ITEM.Price = 8000
ITEM.Model = 'models/weapons/tfa_nmrih/w_me_hatchet.mdl'
ITEM.WeaponClass = 'm9k_hatchet'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end