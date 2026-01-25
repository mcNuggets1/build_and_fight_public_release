ITEM.Name = 'Heiligenschein'
ITEM.Price = 100000
ITEM.Model = 'models/pony_halo.mdl'
ITEM.Attachment = 'eyes'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Kopf"
ITEM.UnboxOnly = 10

function ITEM:CanPlayerSee()
	return false
end

function ITEM:CanPlayerBuy()
	return false
end

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local Size = Vector(0.5, 0.5, 0.5)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(0, 0, 0)
	local MPos = Vector(-9, 0, -18)

	local MCustomPos = PS_CheckPMMods(ply, self.EquipGroup)
	if MCustomPos then
		MPos = Vector(MCustomPos[1] - 8, MCustomPos[2], MCustomPos[3] - 18.5)
	end

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end

local nexteffect = 0
function ITEM:PostModifyClientsideModel(ply, model, pos, ang)
	if nexteffect <= CurTime() then
		nexteffect = CurTime() + 0.2
		local edata = EffectData()
		edata:SetOrigin(pos + model:GetUp() * 29 + model:GetForward() * 6)
		util.Effect("pony_shiny", edata)
	end
end