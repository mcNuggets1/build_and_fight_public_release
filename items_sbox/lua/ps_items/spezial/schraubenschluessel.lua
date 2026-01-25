ITEM.Name = 'Schraubenschlüssel'
ITEM.Price = 3000
ITEM.Model = 'models/vc-mod/v_wrench.mdl'
ITEM.WeaponClass = 'vc_wrench'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end