local connectmessages = CreateClientConVar("cl_connectmessages", 1, FCVAR_ARCHIVE)
local disconnectmessages = CreateClientConVar("cl_disconnectmessages", 1, FCVAR_ARCHIVE)

usermessage.Hook("Player_Connect", function(data)
	if !connectmessages:GetBool() then return end
	local N = data:ReadString()
	chat.AddText(Color(255, 255, 153, 255), N, Color(255, 255, 255, 255), " ist dem Server beigetreten.")
end)

usermessage.Hook("Player_Disconnect", function(data)
	if !disconnectmessages:GetBool() then return end
	local N = data:ReadString()
	local R = data:ReadString()
	chat.AddText(Color(255, 255, 153, 255), N, Color(255, 255, 255, 255), " hat den Server verlassen. "..R)
end)