ITEM.Name = 'Proxymine'
ITEM.Price = 80000
ITEM.Model = 'models/weapons/w_px_planted.mdl'
ITEM.WeaponClass = 'm9k_proxy_mine'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end