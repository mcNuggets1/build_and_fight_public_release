ITEM.Name = 'Vorschlaghammer'
ITEM.Price = 10000
ITEM.Model = 'models/weapons/tfa_nmrih/w_me_sledge.mdl'
ITEM.WeaponClass = 'm9k_sledgehammer'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end