if SERVER then
	AddCSLuaFile("pointshop/vgui/dpointshopbutton.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopmenu.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopitem.lua")
	AddCSLuaFile("pointshop/vgui/dpointshoppreview.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopcolorchooser.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopskinchooser.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopmatchooser.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopgivepoints.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopdesignoptions.lua")

	AddCSLuaFile("pointshop/sh_pointshop.lua")
	AddCSLuaFile("pointshop/sh_config.lua")
	AddCSLuaFile("pointshop/cl_player_extension.lua")
	AddCSLuaFile("pointshop/cl_pointshop.lua")
	AddCSLuaFile("pointshop/cl_design.lua")
	AddCSLuaFile("pointshop/vgui/dpointshopintro.lua")

	include("pointshop/sh_pointshop.lua")
	include("pointshop/sh_config.lua")
	include("pointshop/sv_player_extension.lua")
	include("pointshop/sv_pointshop.lua")
end

if CLIENT then
	include("pointshop/vgui/dpointshopbutton.lua")
	include("pointshop/vgui/dpointshopmenu.lua")
	include("pointshop/vgui/dpointshopitem.lua")
	include("pointshop/vgui/dpointshoppreview.lua")
	include("pointshop/vgui/dpointshopcolorchooser.lua")
	include("pointshop/vgui/dpointshopskinchooser.lua")
	include("pointshop/vgui/dpointshopmatchooser.lua")
	include("pointshop/vgui/dpointshopgivepoints.lua")
	include("pointshop/vgui/dpointshopdesignoptions.lua")

	include("pointshop/sh_pointshop.lua")
	include("pointshop/sh_config.lua")
	include("pointshop/cl_player_extension.lua")
	include("pointshop/cl_pointshop.lua")
	include("pointshop/cl_design.lua")
	include("pointshop/vgui/dpointshopintro.lua")
end

hook.Add("InitPostEntity", "PS_Items", function()
	PS:LoadItems()
end)