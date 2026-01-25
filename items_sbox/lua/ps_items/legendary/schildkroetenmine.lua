ITEM.Name = 'Schildkrötenmine'
ITEM.Price = 80000
ITEM.Model = 'models/props/de_tides/vending_turtle.mdl'
ITEM.WeaponClass = 'weapon_mineturtle'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end