ITEM.Name = 'Superfäuste'
ITEM.Price = 150000
ITEM.Material = 'vgui/entities/m9k_fists.vmt'
ITEM.WeaponClass = 'weapon_superfists'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end