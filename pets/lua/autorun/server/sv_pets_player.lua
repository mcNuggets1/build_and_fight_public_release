local Player = FindMetaTable("Player")
function Player:GetPet()
	return self.Pet
end

function Player:AddPet(ent)
	self.Pet = ent
end

function Player:CreatePet(name)
	if IsValid(self.Pet) then
		self.Pet:Remove()
	end
	local ent = ents.Create(name)
	if !IsValid(ent) then return end
	ent:SetPos(self:GetPos() + Vector(0, 0, 60))
	ent:SetOwner(self)
	ent:Spawn()
	ent:Activate()
	self:AddPet(ent)
	hook.Run("Pets_OnCreatePet", ent, name)
	return ent
end

function Player:RemovePet()
	local pet = self:GetPet()
	if !IsValid(pet) then return end
	hook.Run("Pets_OnRemovePet", pet, name)
	pet:Remove()
	self.Pet = nil
end