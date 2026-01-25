ITEM.Name = 'Zielraketenwerfer'
ITEM.Price = 7000
ITEM.Model = 'models/weapons/w_rocket_launcher.mdl'
ITEM.WeaponClass = 'weapon_rpg'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID, "rpg_round", 2)
end