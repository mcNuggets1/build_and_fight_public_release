ITEM.Name = 'Stern-Brille'
ITEM.Price = 3000
ITEM.Model = 'models/gmod_tower/starglasses.mdl'
ITEM.Attachment = 'eyes'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Brillen"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local MAngle = Angle(0, 0, 0)
	local MPos = Vector(-1.4, 0, -0.5)

	local MCustomPos = PS_CheckPMMods(ply, self.EquipGroup)
	if MCustomPos then
		MPos = Vector(MCustomPos[1] - 0.5, MCustomPos[2], MCustomPos[3])
	end

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end