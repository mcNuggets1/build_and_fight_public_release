ITEM.Name = 'Machete'
ITEM.Price = 9000
ITEM.Model = 'models/weapons/tfa_nmrih/w_me_machete.mdl'
ITEM.WeaponClass = 'm9k_machete'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end