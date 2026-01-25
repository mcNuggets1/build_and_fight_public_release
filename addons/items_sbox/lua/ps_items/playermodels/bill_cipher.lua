ITEM.Name = 'Bill Cipher'
ITEM.Price = 500000
ITEM.Model = 'models/polycapn/bill_cipher.mdl'
ITEM.PlayerModel = true

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, self.Model, modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end