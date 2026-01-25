ITEM.Name = 'Lichkings Helm'
ITEM.Price = 25000
ITEM.Model = 'models/maxxy/lich_king_enhanced/arthas_helmet.mdl'
ITEM.Attachment = 'eyes'
ITEM.Weight = 2

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local MAngle = Angle(270, 270, 0)
	local MPos = Vector(-4.5, 0, -92)

	local MCustomPos = PS_CheckPMMods(ply, self.EquipGroup)
	if MCustomPos then
		MPos = Vector(MCustomPos[1] - 3, MCustomPos[2], MCustomPos[3] - 92)
	end

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end