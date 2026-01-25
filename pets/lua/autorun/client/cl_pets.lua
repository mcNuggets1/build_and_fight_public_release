local Entity = FindMetaTable("Entity")
local hide_own_effect = CreateClientConVar("cl_pets_hideowneffects", 0, FCVAR_ARCHIVE)
local hide_effect = CreateClientConVar("cl_pets_hideeffects", 0, FCVAR_ARCHIVE)
function Entity:AttachPetParticles(effect)
	if !Pets.EnableAllParticles then return end
	local is_owner = self:GetOwner() == LocalPlayer()
	local pos = self:GetPos()
	local edata = EffectData()
	edata:SetStart(pos)
	edata:SetOrigin(pos)
	edata:SetEntity(self)
	if is_owner and !hide_own_effect:GetBool() or !is_owner then
		if !hide_effect:GetBool() then
			util.Effect(effect, edata)
		end
	end
end