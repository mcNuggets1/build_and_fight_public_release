if (SERVER) then
	AddCSLuaFile()
end

sound.Add({
	name = "Witcher.Teleport",
	channel = CHAN_STREAM,
	volume = 1,
	level = 75,
	pitch = {100, 110},
	sound = "portal/portal_teleport.wav"
})

sound.Add({
	name = "Witcher.PortalOpen",
	channel = CHAN_STREAM,
	volume = 1,
	level = 80,
	pitch = {95, 105},
	sound = "portal/portal_open.wav"
})

sound.Add({
	name = "Witcher.PortalClose",
	channel = CHAN_STREAM,
	volume = 1,
	level = 80,
	pitch = {95, 105},
	sound = "portal/portal_dissipate.wav"
})

function DistanceToPlane(object_pos, plane_pos, plane_forward)
	local vec = object_pos - plane_pos
	plane_forward:Normalize()

	return plane_forward:Dot(vec)
end

function math.VectorAngles(forward, up)
	local angles = Angle(0, 0, 0)
	local left = up:Cross(forward)
	left:Normalize()
	local xydist = math.sqrt(forward.x * forward.x + forward.y * forward.y)

	if (xydist > 0.001) then
		angles.y = math.deg(math.atan2(forward.y, forward.x))
		angles.p = math.deg(math.atan2(-forward.z, xydist))
		angles.r = math.deg(math.atan2(left.z, (left.y * forward.x) - (left.x * forward.y)))
	else
		angles.y = math.deg(math.atan2(-left.x, left.y))
		angles.p = math.deg(math.atan2(-forward.z, xydist))
		angles.r = 0
	end

	return angles
end