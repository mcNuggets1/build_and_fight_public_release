include("datatypes/sql.lua")

util.AddNetworkString("PVP_OpenStats")
util.AddNetworkString("PVP_OpenOtherPlayerStats")
util.AddNetworkString("PVP_ChangeProfilePrivacy")

net.Receive("PVP_OpenStats", function(len, ply)
	local player = net.ReadEntity()
	if !IsValid(player) then return end
	net.Start("PVP_OpenStats")
		net.WriteTable(player.Stats or {})
		net.WriteEntity(player)
		net.WriteBit(ply.Stats.PrivateProfile == 1)
	net.Send(ply)
end)

net.Receive("PVP_OpenOtherPlayerStats", function(len, ply)
	local sid = net.ReadString()
	Stats.GetOtherPlayerStats(sid, function(data)
		net.Start("PVP_OpenStats")
			net.WriteTable(data or {})
			net.WriteEntity(NULL)
			net.WriteBit(ply.Stats.PrivateProfile == 1)
		net.Send(ply)
	end)
end)

net.Receive("PVP_ChangeProfilePrivacy", function(len, ply)
	local bit = net.ReadBit()
	ply.Stats.PrivateProfile = bit
end)

hook.Add("PlayerSay", "PVP_OpenStats", function(ply, text)
	if (string.lower(text) == "!stats") then
		ply:ConCommand("openstats")
		return ""
	end
end)

concommand.Add("openstats", function(ply)
	net.Start("PVP_OpenStats")
		net.WriteTable(ply.Stats)
		net.WriteEntity(NULL)
		net.WriteBit(ply.Stats.PrivateProfile == 1)
	net.Send(ply)
end)