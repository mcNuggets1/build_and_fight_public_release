ITEM.Name = 'Fahrrad'
ITEM.Price = 240000
ITEM.Model = 'models/props_junk/bicycle01a.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Pelvis'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Rücken"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local Size = Vector(0.80, 0.80, 0.80)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(268, 0, 50)
	local MPos = Vector(0, -7.8299999237061, -10)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end