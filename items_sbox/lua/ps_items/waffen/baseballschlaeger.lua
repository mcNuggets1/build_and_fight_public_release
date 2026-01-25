ITEM.Name = 'Baseballschläger'
ITEM.Price = 6000
ITEM.Model = 'models/weapons/tfa_nmrih/w_me_bat_metal.mdl'
ITEM.WeaponClass = 'm9k_baseball_bat'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end