surface.CreateFont("hitnums_indicator", {font = "coolvetica", antialias = true, size = 100, weight = 1000, blursize = 0, scanlines = 0, outline = true})

local indicators = {}
local lastcurtime = 0
local function SpawnIndicator(text, col, pos, vel, ttl)
	local ind = {}
	ind.text = text
	ind.pos = Vector(pos.x, pos.y, pos.z)
	ind.vel = Vector(vel.x, vel.y, vel.z)
	ind.col = Color(col.r, col.g, col.b)
	ind.ttl = ttl
	ind.life = ttl
	surface.SetFont("hitnums_indicator")
	local w, h = surface.GetTextSize(text)
	ind.widthH = w / 2
	ind.heightH = h / 2
	table.insert(indicators, ind)
end

local hitnums_enable = CreateClientConVar("cl_hitnums_enable", 1, FCVAR_ARCHIVE)
local hitnums_size = CreateClientConVar("cl_hitnums_size", 0.1, FCVAR_ARCHIVE)
local hitnums_alpha = CreateClientConVar("cl_hitnums_alpha", 1, FCVAR_ARCHIVE)
local hitnums_lifetime = CreateClientConVar("cl_hitnums_lifetime", 1, FCVAR_ARCHIVE)
net.Receive("hitnums_spawn", function()
	if !hitnums_enable:GetBool() then return end
	local dmg = net.ReadFloat()
	local dmgtype = net.ReadUInt(32)
	if dmg < 1 then
		dmg = math.Round(dmg, 3)
	else
		dmg = math.floor(dmg)
	end
	local crit = (net.ReadBit() ~= 0)
	local pos = net.ReadVector()
	local force = net.ReadVector()
	local col = Color(255, 230, 210)
	local ttl = hitnums_lifetime:GetFloat()
	if crit then
		txt = "Kritisch!"
		SpawnIndicator(txt, Color(255, 40, 40), pos, force + Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(1.25, 1.5)), ttl)
	end
	local txt = math.abs(dmg)
	if bit.band(dmgtype, bit.bor(DMG_BURN, DMG_SLOWBURN, DMG_PLASMA)) != 0 then
		col = Color(255, 120, 0)
	elseif bit.band(dmgtype, bit.bor(DMG_BLAST, DMG_BLAST_SURFACE)) != 0 then
		col = Color(240, 240, 50)
	elseif bit.band(dmgtype, bit.bor(DMG_ACID, DMG_POISON, DMG_RADIATION, DMG_NERVEGAS)) != 0 then
		col = Color(140, 255, 75)
	elseif bit.band(dmgtype, bit.bor(DMG_DISSOLVE, DMG_ENERGYBEAM, DMG_SHOCK)) != 0 then
		col = Color(100, 160, 255)
	end
	SpawnIndicator(txt, col, pos, force + Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(0.75, 1)), ttl)
end)

local local_ply
local function DrawIndicators()
	if !hitnums_enable:GetBool() then return end

	local curtime = CurTime()
	local dt = curtime - lastcurtime
	lastcurtime = curtime
	local ft = FrameTime()
	for _, ind in ipairs(indicators) do
		ind.life = ind.life - dt
		ind.vel.z = ind.vel.z - (dt * 2.5)
		ind.pos.x = ind.pos.x + (ind.vel.x * (dt * 50))
		ind.pos.y = ind.pos.y + (ind.vel.y * (dt * 50))
		ind.pos.z = ind.pos.z + (ind.vel.z * (dt * 50))
	end
	local i = 1
	while i <= #indicators do
		if indicators[i].life < 0 then
			table.remove(indicators, i)
		else
			i = i + 1
		end
	end

	if #indicators == 0 then return end

	local_ply = local_ply or LocalPlayer()
	local observer = (local_ply:GetViewEntity() or local_ply)
	local ang = observer:EyeAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
	ang = Angle(0, ang.y, ang.r)
	local scale = hitnums_size:GetFloat()
	local alphamul = hitnums_alpha:GetFloat() * 255
	local col
	for _, ind in ipairs(indicators) do
		col = ind.col
		cam.Start3D2D(ind.pos, ang, scale)
			surface.SetFont("hitnums_indicator")
			surface.SetTextColor(col.r, col.g, col.b, (ind.life / ind.ttl * alphamul))
			surface.SetTextPos(-ind.widthH, -ind.heightH)
			surface.DrawText(ind.text)
		cam.End3D2D()
	end
end
hook.Add("PostDrawTranslucentRenderables", "hitnums_drawindicators", DrawIndicators)