ITEM.Name = 'HK 416'
ITEM.Price = 27000
ITEM.Model = 'models/weapons/w_hk_416.mdl'
ITEM.WeaponClass = 'm9k_m416'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end