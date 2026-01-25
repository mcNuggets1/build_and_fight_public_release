ITEM.Name = '6% mehr Sprungkraft'
ITEM.Price = 30000
ITEM.Model = 'models/props_junk/shoe001a.mdl'
ITEM.NoPreview = true

local default = 200

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() and (ply:GetJumpPower() == default) then
		ply:SetJumpPower(default * 1.06)
	end
end

function ITEM:OnHolster(ply)
	if ply:Alive() and (math.Round(ply:GetJumpPower(), 1) == default * 1.06) then
		ply:SetJumpPower(default)
	end
end