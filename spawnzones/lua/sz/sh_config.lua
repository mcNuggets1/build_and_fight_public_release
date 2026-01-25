SZ.Data = {}
SZ.Config = {}

SZ.Config.EnableProtectionTime = 10
SZ.Config.DisableProtectionTime = 3

SZ:AddNewZone("gm_construct", {
	Center = Vector(1337, -85, -79),
	SizeBackwards = Vector(-800, -811, -100),
	SizeForwards = Vector(500, 980, 135)
})

SZ:AddNewZone("gm_flatgrass", {
	Center = Vector(-4, 3, -12223),
	SizeBackwards = Vector(-800, -850, -100),
	SizeForwards = Vector(800, 850, 500)
})

SZ:AddNewZone("gm_highway14800", {
	Center = Vector(-1293, 452, -4087),
	SizeBackwards = Vector(-800, -850, -500),
	SizeForwards = Vector(800, 850, 500)
})

SZ:AddNewZone("mg_station_2_3", {
	Center = Vector(-502, 192, -502),
	SizeBackwards = Vector(-270, -570, -200),
	SizeForwards = Vector(250, 459, 78)
})

SZ:AddNewZone("gm_excess_island", {
	Center = Vector(364, -2554, 64),
	SizeBackwards = Vector(-299, -197, -64),
	SizeForwards = Vector(307, 153, 150)
})

SZ:AddNewZone("gm_excess_waters", {
	Center = Vector(5104, -3197, 544),
	SizeBackwards = Vector(-495, -450, -64),
	SizeForwards = Vector(600, 446, 150)
})

SZ:AddNewZone("gm_trainconstruct2", {
	Center = Vector(-2404, 329, -175),
	SizeBackwards = Vector(-630, -585, -145),
	SizeForwards = Vector(484, 550, 174)
})

SZ:AddNewZone("gm_genesis_b24", {
	Center = Vector(1534, -9985, -8767),
	SizeBackwards = Vector(-200, -400, -65),
	SizeForwards = Vector(200, 200, 200)
})

SZ:AddNewZone("gm_freespace_13", {
	Center = Vector(-3189.946045, -0.977248, -14450.15625),
	SizeBackwards = Vector(-250, -500, -143),
	SizeForwards = Vector(410, 500, 75)
})

SZ:AddNewZone("gm_cloudbuild", {
	Center = Vector(4093.80176, 1485.18835, 171.67363),
	SizeBackwards = Vector(-333, -253.2, -115),
	SizeForwards = Vector(337.5, 130.1, 100)
})

SZ:AddNewZone("gm_excess_construct_mg", {
	Center = Vector(1457.294922, 2691.525879, 109.767754),
	SizeBackwards = Vector(-689, -643, -114),
	SizeForwards = Vector(350, 635, 90)
})

SZ:AddNewZone("gm_wuhu", {
	Center = Vector(7.337734, 0.812658, -8943.730469),
	SizeBackwards = Vector(-1520, -1000, -210),
	SizeForwards = Vector(1520, 1000, 350)
})

SZ:AddNewZone("gm_goldencity", {
	Center = Vector(4092.590332, -2681.744873, 390.572144),
	SizeBackwards = Vector(-1916.5, -1670, -400),
	SizeForwards = Vector(1923, 1659, 200)
})

SZ:AddNewZone("gm_york_remaster", {
	Center = Vector(1534, -7140, 275.777527),
	SizeBackwards = Vector(-1000, -819, -275),
	SizeForwards = Vector(1000, 867, 200)
})

SZ:AddNewZone("gm_echocity_circuit_v1", { 
	Center = Vector(4352.469238, 1983.699463, 0.031250),
	SizeBackwards = Vector(-241, -447, 0),
	SizeForwards = Vector(767, 578, 258)
})

SZ:AddNewZone("gm_ultrabox", { 
	Center = Vector(6.857646, 168.031250, 96.031250),
	SizeBackwards = Vector(-1014.5, -953, 0),
	SizeForwards = Vector(1001, 618, 311)
})

SZ:AddNewZone("gm_modern_island_04", { 
	Center = Vector(11776.739258, -11776.362305, -6143.968750),
	SizeBackwards = Vector(-500, -515, 0),
	SizeForwards = Vector(500, 515, 258)
})

local function GetBBox(center)
	local pos = center + Vector(0, 0, 1)

	local max_length = 1000000
	local right = Angle(0, 0, 0):Right()
	local right_pos = Trace(pos, right * max_length)
	local left_pos = Trace(pos, -right * max_length)

	local forward = Angle(0, 90, 0):Right()
	local forward_pos = Trace(pos, forward * max_length)
	local backward_pos = Trace(pos, -forward * max_length)

	local up = Vector(0, 0, 1)
	local up_pos = Trace(pos, up * max_length)
	local down_pos = Trace(pos, -up * max_length)

	if !game.IsDedicated() then
		local time = 10
		debugoverlay.Sphere(right_pos, 10, time, Color(255, 255, 255), true)
		debugoverlay.Sphere(left_pos, 10, time, Color(255, 255, 0), true)

		debugoverlay.Sphere(up_pos, 10, time, Color(255, 0, 0), true)
		debugoverlay.Sphere(down_pos, 10, time, Color(0, 255, 0), true)

		debugoverlay.Sphere(forward_pos, 10, time, Color(0, 255, 255), true)
		debugoverlay.Sphere(backward_pos, 10, time, Color(0, 0, 255), true)
	end

	local SizeBackwards = Vector((backward_pos - pos)[1], (right_pos - pos)[2], (down_pos - pos)[3])
	local SizeForwards = Vector((forward_pos - pos)[1], (left_pos - pos)[2], (up_pos - pos)[3])

	print([[
SZ:AddNewZone("]] .. game.GetMap() .. [[", {
	Center = Vector(]] .. math.Round(center[1]) .. ", " .. math.Round(center[2]) .. ", " .. math.Round(center[3]) .. [[),
	SizeBackwards = Vector(]] .. math.Round(SizeBackwards[1]) .. ", " .. math.Round(SizeBackwards[2]) .. ", " .. math.Round(SizeBackwards[3]) .. [[),
	SizeForwards = Vector(]] .. math.Round(SizeForwards[1]) .. ", " .. math.Round(SizeForwards[2]) .. ", " .. math.Round(SizeForwards[3]) .. [[)
})]])
end

-- Helper function -> lua_run CreateSpawn()
function CreateSpawn()
	if !game.IsDedicated() then
		GetBBox(Entity(1):GetPos())
	end
end