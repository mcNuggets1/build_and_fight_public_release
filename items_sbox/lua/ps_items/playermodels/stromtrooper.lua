ITEM.Name = 'Stormtrooper'
ITEM.Price = 98000
ITEM.Model = 'models/player/deckboy/storm_trooper_pm/storm_trooper_pm.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end