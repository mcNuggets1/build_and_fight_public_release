ITEM.Name = 'ACR'
ITEM.Price = 21000
ITEM.Model = 'models/weapons/w_masada_acr.mdl'
ITEM.WeaponClass = 'm9k_acr'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end