hook.Add("PlayerInitialSpawn", "Connect_Message", function(ply)
	local N = ply:Name()
	umsg.Start("Player_Connect")
		umsg.String(N)
	umsg.End()
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "Disconnect_Message", function(ply)
	local p = Player(ply.userid)
	if !IsValid(p) then return end
	local N = ply.name
	local R = ply.reason
	umsg.Start("Player_Disconnect")
		umsg.String(N)
		umsg.String(R)
	umsg.End()
end)