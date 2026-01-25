ITEM.Name = 'Nervengas'
ITEM.Price = 50000
ITEM.Model = 'models/healthvial.mdl'
ITEM.WeaponClass = 'm9k_nerve_gas'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang, panel)
	model:SetMaterial("models/weapons/gv/nerve_vial.vmt")
	return model, pos, ang
end