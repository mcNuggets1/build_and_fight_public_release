achievements.LocalData = {}

net.Receive("Achv_SendData", function(len)
	local number = net.ReadInt(16)
	for i = 1, number do
		local id = net.ReadString()
		achievements.LocalData[id] = {Value = net.ReadInt(31), Completed = net.ReadBit() == 1}
		if achievements.LocalData[id].Completed then
			achievements.LocalData[id].CompletedOn = net.ReadInt(32)
		end
	end
	achievements.DataRetrieved = true
end)

net.Receive("Achv_Unlock", function(len)
	local ply = net.ReadEntity()
	if !IsValid(ply) then return end
	local achv = achievements.GetAchievement(net.ReadString())
	achievements.Award(ply, achv.Name, achv.Icon)
end)

function achievements.GetPlayerData(id)
	local baseData = {Value = 0,Completed = false,CompletedOn = 0}
	local plyData = achievements.LocalData[id] or {}
	table.Merge(baseData, plyData)
	return baseData
end